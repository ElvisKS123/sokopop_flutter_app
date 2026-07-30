import 'package:sokopop_flutter_app/features/auth/domain/repositories/auth_repository.dart';

/// SharedPreferences: pre-fills the sign-in screen with the last email used.
class GetLastEmail {
  const GetLastEmail(this._repository);

  final AuthRepository _repository;

  Future<String?> call() => _repository.getLastEmail();
}
