import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:sokopop_flutter_app/features/auth/domain/repositories/auth_repository.dart';

/// Validation lives here, not in `sign_in_screen.dart`. The screen can be
/// redesigned from scratch and these rules still hold.
class SignInWithEmail {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call({required String email, required String password}) {
    final trimmed = email.trim();

    if (trimmed.isEmpty) {
      throw const ValidationFailure('Enter your email address.');
    }
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      throw const ValidationFailure('That email address is not valid.');
    }
    if (password.length < 6) {
      throw const ValidationFailure('Password must be at least 6 characters.');
    }

    return _repository.signInWithEmail(email: trimmed, password: password);
  }
}
