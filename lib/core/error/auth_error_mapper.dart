/// Firebase error codes -> copy a user can act on.
///
/// Moved out of `AuthProvider._friendlyError` so that the mapping is shared,
/// testable on its own, and not duplicated the next time another feature has
/// to re-authenticate.
String messageForAuthCode(String code) {
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
    case 'user-disabled':
      return 'This account has been disabled.';
    default:
      return 'Authentication failed. Please try again.';
  }
}

/// Firestore error codes -> user-facing copy.
String messageForFirestoreCode(String code) {
  switch (code) {
    case 'permission-denied':
      return "You don't have permission to do that.";
    case 'unavailable':
      return 'Cannot reach the server. Check your connection.';
    case 'not-found':
      return 'That listing no longer exists.';
    case 'failed-precondition':
      return 'The app needs a database index that has not been created yet.';
    default:
      return 'Something went wrong. Please try again.';
  }
}
