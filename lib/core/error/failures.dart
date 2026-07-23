/// A [Failure] is the only error type the presentation layer ever sees.
///
/// Repositories catch `FirebaseAuthException`, `FirebaseException` and friends
/// and rethrow one of these, so no provider or screen has to know what
/// `invalid-credential` means.
sealed class Failure implements Exception {
  const Failure(this.message);

  /// Already worded for a snackbar.
  final String message;

  @override
  String toString() => message;
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Check your network.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = "You don't have permission to do that."]);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

/// Thrown by use cases when input breaks a business rule, before any
/// network call is made.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
