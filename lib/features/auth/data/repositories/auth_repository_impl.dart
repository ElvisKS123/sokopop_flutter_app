import 'package:firebase_auth/firebase_auth.dart';

import 'package:sokopop_flutter_app/core/error/auth_error_mapper.dart';
import 'package:sokopop_flutter_app/core/error/failures.dart';
import 'package:sokopop_flutter_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sokopop_flutter_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sokopop_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:sokopop_flutter_app/features/auth/domain/repositories/auth_repository.dart';

/// Implements the domain contract. Its whole job: call the data sources and
/// translate Firebase exceptions into `Failure`s.
///
/// `_guard` is the single place that translation happens, which is why every
/// method below is two or three lines long.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Stream<AppUser?> get authStateChanges => _remote.authStateChanges;

  @override
  AppUser? get currentUser => _remote.currentUser;

  @override
  Future<AppUser> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final user = await _remote.signUpWithEmail(
        fullName: fullName,
        email: email,
        password: password,
      );
      await _local.cacheLastEmail(user.email);
      return user;
    });
  }

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final user =
          await _remote.signInWithEmail(email: email, password: password);
      await _local.cacheLastEmail(user.email);
      return user;
    });
  }

  @override
  Future<AppUser> signInWithGoogle() {
    return _guard(() async {
      final user = await _remote.signInWithGoogle();
      await _local.cacheLastEmail(user.email);
      return user;
    });
  }

  @override
  Future<void> sendPasswordReset(String email) =>
      _guard(() => _remote.sendPasswordReset(email));

  @override
  Future<void> signOut() => _guard(_remote.signOut);

  @override
  Future<String?> getLastEmail() async {
    try {
      return await _local.getLastEmail();
    } catch (_) {
      // A missing preference is never worth failing a screen over.
      return null;
    }
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const NetworkFailure();
      }
      throw AuthFailure(messageForAuthCode(e.code));
    } on FirebaseException catch (e) {
      throw ServerFailure(messageForFirestoreCode(e.code));
    } on Failure {
      rethrow;
    } catch (_) {
      throw const ServerFailure();
    }
  }
}
