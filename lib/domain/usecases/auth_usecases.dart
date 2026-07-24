import '../../data/repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases({AuthRepository? repository})
      : repository = repository ?? AuthRepository();

  Future<String?> getLastEmail() => repository.getLastEmail();

  Future<bool> signIn(String email, String password) async {
    try {
      await repository.signInWithEmail(email: email, password: password);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      await repository.signInWithGoogle();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> signUp(String fullName, String email, String password) async {
    try {
      await repository.signUpWithEmail(
        fullName: fullName,
        email: email,
        password: password,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() => repository.signOut();

  Future<void> sendPasswordReset(String email) => repository.sendPasswordReset(email);
}
