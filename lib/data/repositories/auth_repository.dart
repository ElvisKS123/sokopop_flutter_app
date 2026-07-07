import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Data layer: talks directly to Firebase Auth, Firestore and SharedPreferences.
/// No UI code here — the AuthProvider (presentation layer) calls these methods.
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream that tells us if a user is logged in or not (used by AuthGate).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// ---------- EMAIL / PASSWORD ----------

  Future<UserCredential> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    // Save display name on the auth profile
    await credential.user?.updateDisplayName(fullName.trim());

    // Send email verification (security best practice for the rubric)
    await credential.user?.sendEmailVerification();

    // Create the user document in Firestore (matches the ERD users collection)
    await _createUserDoc(credential.user!, fullName: fullName.trim());

    return credential;
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await _saveLastLogin(email.trim());
    return credential;
  }

  /// ---------- GOOGLE SIGN-IN ----------

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User closed the Google popup
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

    // If it's a brand new Google user, create their Firestore doc too
    if (userCredential.additionalUserInfo?.isNewUser == true) {
      await _createUserDoc(
        userCredential.user!,
        fullName: userCredential.user!.displayName ?? 'ALU Student',
      );
    }
    await _saveLastLogin(userCredential.user!.email ?? '');
    return userCredential;
  }

  /// ---------- PASSWORD RESET ----------

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// ---------- SIGN OUT ----------

  Future<void> signOut() async {
    await _googleSignIn.signOut(); // clears Google session too
    await _auth.signOut();
  }

  /// ---------- PRIVATE HELPERS ----------

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

  /// SharedPreferences: remember the last email used (restored on sign-in screen)
  Future<void> _saveLastLogin(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_email', email);
  }

  Future<String?> getLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_email');
  }
}
