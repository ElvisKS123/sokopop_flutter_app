import 'package:sokopop_flutter_app/features/auth/domain/entities/app_user.dart';

/// The contract the domain layer owns; `data/` implements it.
///
/// This inversion is what keeps the domain and presentation layers free of
/// Firebase imports.
abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  AppUser? get currentUser;

  Future<AppUser> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  });

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> signInWithGoogle();

  Future<void> sendPasswordReset(String email);

  Future<void> signOut();

  /// SharedPreferences-backed convenience for the sign-in screen.
  Future<String?> getLastEmail();
}
