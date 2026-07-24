import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:sokopop_flutter_app/features/auth/domain/repositories/auth_repository.dart';

class SignUpWithEmail {
  const SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  Future<AppUser> call({
    required String fullName,
    required String email,
    required String password,
  }) {
    final name = fullName.trim();
    final trimmed = email.trim();

    if (name.length < 2) {
      throw const ValidationFailure('Enter your full name.');
    }
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      throw const ValidationFailure('That email address is not valid.');
    }
    if (password.length < 6) {
      throw const ValidationFailure('Password must be at least 6 characters.');
    }

    return _repository.signUpWithEmail(
      fullName: name,
      email: trimmed,
      password: password,
    );
  }
}
