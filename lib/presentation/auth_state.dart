import 'package:flutter/foundation.dart';

import '../data/repositories/auth_repository.dart';
import '../domain/usecases/auth_usecases.dart';

class AuthState extends ChangeNotifier {
  AuthState({AuthRepository? repository})
      : _useCases = AuthUseCases(repository: repository);

  final AuthUseCases _useCases;

  bool isLoading = false;
  String? errorMessage;

  Future<String?> getLastEmail() async {
    try {
      return _useCases.getLastEmail();
    } catch (_) {
      errorMessage = 'Unable to load last email.';
      notifyListeners();
      return null;
    }
  }

  Future<bool> signIn(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final ok = await _useCases.signIn(email, password);
    isLoading = false;

    if (!ok) {
      errorMessage = 'Unable to sign in. Please try again.';
    }

    notifyListeners();
    return ok;
  }

  Future<bool> signInWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final ok = await _useCases.signInWithGoogle();
    isLoading = false;

    if (!ok) {
      errorMessage = 'Google sign-in failed.';
    }

    notifyListeners();
    return ok;
  }

  Future<bool> signUp(String fullName, String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final ok = await _useCases.signUp(fullName, email, password);
    isLoading = false;

    if (!ok) {
      errorMessage = 'Unable to create account. Please try again.';
    }

    notifyListeners();
    return ok;
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();
    await _useCases.signOut();
    isLoading = false;
    notifyListeners();
  }
}
