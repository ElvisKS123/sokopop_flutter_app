import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:sokopop_flutter_app/features/auth/data/datasources/auth_remote_data_source.dart';

/// Presentation-layer state management (Provider / ChangeNotifier).
/// Screens listen to this class instead of calling Firebase directly.
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  User? get currentUser => _repo.currentUser;
  Stream<User?> get authStateChanges => _repo.authStateChanges;

  Future<String?> getLastEmail() => _repo.getLastEmail();

  /// Returns true on success, false on failure (screen shows errorMessage).
  Future<bool> signUp(String fullName, String email, String password) async {
    return _run(() => _repo.signUpWithEmail(
        fullName: fullName, email: email, password: password));
  }

  Future<bool> signIn(String email, String password) async {
    return _run(() => _repo.signInWithEmail(email: email, password: password));
  }

  Future<bool> signInWithGoogle() async {
    return _run(() => _repo.signInWithGoogle());
  }

  Future<bool> sendPasswordReset(String email) async {
    return _run(() => _repo.sendPasswordReset(email));
  }

  Future<void> signOut() async {
    await _repo.signOut();
    notifyListeners();
  }

  /// Shared wrapper: sets loading, catches Firebase errors, maps them
  /// to friendly messages for the snackbars.
  Future<bool> _run(Future<dynamic> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _friendlyError(e.code);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-not-found':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'wrong-password':
        return 'Incorrect password. Try again or reset it.';
      case 'email-already-in-use':
        return 'An account already exists with this email. Sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Check your network.';
      case 'sign-in-cancelled':
        return 'Google sign-in was cancelled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
