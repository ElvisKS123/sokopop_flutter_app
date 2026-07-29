import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/get_last_email.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/send_password_reset.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/sign_out.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/watch_auth_state.dart';

/// Presentation-layer state. Screens listen to this instead of calling
/// Firebase directly.
///
/// Two things changed from the original:
///   1. Dependencies are injected instead of constructed here, so this class
///      can be tested with fake use cases.
///   2. It no longer imports `firebase_auth`. `_friendlyError` moved to
///      `core/error/auth_error_mapper.dart` and the repository does the
///      translating, so this class just displays whatever message it receives.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required WatchAuthState watchAuthState,
    required SignInWithEmail signInWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required SignInWithGoogle signInWithGoogle,
    required SendPasswordReset sendPasswordResetUseCase,
    required SignOut signOutUseCase,
    required GetLastEmail getLastEmailUseCase,
  })  : _watchAuthState = watchAuthState,
        _signInWithEmail = signInWithEmail,
        _signUpWithEmail = signUpWithEmail,
        _signInWithGoogle = signInWithGoogle,
        _sendPasswordReset = sendPasswordResetUseCase,
        _signOut = signOutUseCase,
        _getLastEmail = getLastEmailUseCase {
    // Keep _currentUser in sync with Firebase even when the app is restarted
    // into an existing session (nobody calls signIn in that case). Without
    // this, the ListingProvider proxy would never learn the user's id and
    // every ownership check would fail after a cold start.
    _authSubscription = _watchAuthState().listen((user) {
      if (_currentUser?.id == user?.id) return;
      _currentUser = user;
      notifyListeners();
    });
  }

  StreamSubscription<AppUser?>? _authSubscription;

  final WatchAuthState _watchAuthState;
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithGoogle _signInWithGoogle;
  final SendPasswordReset _sendPasswordReset;
  final SignOut _signOut;
  final GetLastEmail _getLastEmail;

  bool isLoading = false;
  String? errorMessage;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  /// Backs the AuthGate in `app.dart`, which needs `connectionState` to show
  /// a loader while Firebase restores the session.
  Stream<AppUser?> get authStateChanges => _watchAuthState();

  Future<String?> getLastEmail() => _getLastEmail();

  /// All of these return true on success; the screen reads [errorMessage]
  /// on false. Same contract the screens already use.
  Future<bool> signUp(String fullName, String email, String password) {
    return _run(() => _signUpWithEmail(
          fullName: fullName,
          email: email,
          password: password,
        ));
  }

  Future<bool> signIn(String email, String password) {
    return _run(() => _signInWithEmail(email: email, password: password));
  }

  Future<bool> signInWithGoogle() => _run(_signInWithGoogle.call);

  Future<bool> sendPasswordReset(String email) =>
      _run(() => _sendPasswordReset(email));

  Future<void> signOut() async {
    await _run(_signOut.call);
    _currentUser = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void clearError() {
    if (errorMessage == null) return;
    errorMessage = null;
    notifyListeners();
  }

  /// Sets loading, runs the action, and stores an already-worded failure
  /// message. Note there is no Firebase error-code switch left here.
  Future<bool> _run(Future<dynamic> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await action();
      if (result is AppUser) _currentUser = result;
      isLoading = false;
      notifyListeners();
      return true;
    } on Failure catch (failure) {
      errorMessage = failure.message;
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
}
