import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordReset {
  const SendPasswordReset(this._repository);

  final AuthRepository _repository;

  Future<void> call(String email) {
    final trimmed = email.trim();
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      throw const ValidationFailure('Enter the email address on your account.');
    }
    return _repository.sendPasswordReset(trimmed);
  }
}
