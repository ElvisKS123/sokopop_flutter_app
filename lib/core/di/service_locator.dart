import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:sokopop_flutter_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sokopop_flutter_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sokopop_flutter_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sokopop_flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/get_last_email.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/send_password_reset.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/sign_out.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/sign_up_with_email.dart';
import 'package:sokopop_flutter_app/features/auth/domain/usecases/watch_auth_state.dart';

/// Service locator.
///
/// Replaces the hardcoded `final AuthRepository _repo = AuthRepository();` that
/// used to sit inside `AuthProvider` — presentation was building its own data
/// layer, which made both untestable. Every class now receives its dependencies
/// through its constructor, and this file is the single place that decides what
/// gets injected.
final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ---- External SDKs ---------------------------------------------------
  sl
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance)
    ..registerLazySingleton<GoogleSignIn>(GoogleSignIn.new);

  // ---- Feature: auth ---------------------------------------------------
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        auth: sl(),
        firestore: sl(),
        googleSignIn: sl(),
      ),
    )
    ..registerLazySingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl.new)
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), local: sl()),
    )
    ..registerLazySingleton(() => WatchAuthState(sl()))
    ..registerLazySingleton(() => SignInWithEmail(sl()))
    ..registerLazySingleton(() => SignUpWithEmail(sl()))
    ..registerLazySingleton(() => SignInWithGoogle(sl()))
    ..registerLazySingleton(() => SendPasswordReset(sl()))
    ..registerLazySingleton(() => SignOut(sl()))
    ..registerLazySingleton(() => GetLastEmail(sl()));

  // ---- Feature: listings -----------------------------------------------
  // Registered in a follow-up commit, once the listing repository exists.
}
