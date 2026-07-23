import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:sokopop_flutter_app/features/auth/data/models/user_model.dart';

/// The ONLY file in the auth feature allowed to import `firebase_auth`.
/// Everything above it works with `AppUser`.
///
/// Logic here is unchanged from the original `data/repositories/auth_repository.dart`
/// — email verification, the Firestore user document, and the Google flow all
/// behave exactly as before. What changed is that it no longer touches
/// SharedPreferences (see `auth_local_data_source.dart`) and it now returns a
/// model instead of a raw `UserCredential`.
abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;

  Future<UserModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _db = firestore,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<UserModel?> get authStateChanges => _auth.authStateChanges().map(
        (user) => user == null ? null : UserModel.fromFirebaseUser(user),
      );

  @override
  UserModel? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : UserModel.fromFirebaseUser(user);
  }

  /// ---------- EMAIL / PASSWORD ----------

  @override
  Future<UserModel> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user?.updateDisplayName(fullName.trim());
    await credential.user?.sendEmailVerification();
    await _createUserDoc(credential.user!, fullName: fullName.trim());
    await credential.user?.reload();

    return UserModel(
      id: credential.user!.uid,
      email: credential.user!.email ?? email.trim(),
      displayName: fullName.trim(),
      photoUrl: credential.user!.photoURL,
    );
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return UserModel.fromFirebaseUser(credential.user!);
  }

  /// ---------- GOOGLE SIGN-IN ----------

  @override
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User closed the Google popup.
      throw FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign-in was cancelled.',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    if (userCredential.additionalUserInfo?.isNewUser == true) {
      await _createUserDoc(
        userCredential.user!,
        fullName: userCredential.user!.displayName ?? 'ALU Student',
      );
    }

    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  /// ---------- PASSWORD RESET ----------

  @override
  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  /// ---------- SIGN OUT ----------

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // clears the Google session too
    await _auth.signOut();
  }

  /// ---------- PRIVATE ----------

  Future<void> _createUserDoc(User user, {required String fullName}) async {
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName,
      'email': user.email,
      'photoUrl': user.photoURL,
      'isVerifiedStudent': (user.email ?? '').endsWith('@alustudent.com'),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
