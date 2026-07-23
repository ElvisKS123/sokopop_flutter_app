import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sokopop_flutter_app/core/di/service_locator.dart';
import 'package:sokopop_flutter_app/core/router/app_routes.dart';
import 'package:sokopop_flutter_app/core/theme/app_theme.dart';
import 'package:sokopop_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:sokopop_flutter_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:sokopop_flutter_app/features/auth/presentation/screens/create_account_screen.dart';
import 'package:sokopop_flutter_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sokopop_flutter_app/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:sokopop_flutter_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/providers/listing_provider.dart';
import 'package:sokopop_flutter_app/features/listings/presentation/screens/home_screen.dart';
import 'package:sokopop_flutter_app/features/profile/presentation/screens/notifications_screen.dart';

/// Root widget, split out of `main.dart` so that file only does start-up.
class SokopopApp extends StatelessWidget {
  const SokopopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Built from the service locator instead of constructing its own
        // repository.
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            watchAuthState: sl(),
            signInWithEmail: sl(),
            signUpWithEmail: sl(),
            signInWithGoogle: sl(),
            sendPasswordResetUseCase: sl(),
            signOutUseCase: sl(),
            getLastEmailUseCase: sl(),
          ),
        ),
        // Proxy so the listings feature always knows who is signed in,
        // without importing anything from the auth feature's data layer.
        ChangeNotifierProxyProvider<AuthProvider, ListingProvider>(
          create: (_) => ListingProvider(
            watchActiveListings: sl(),
            createListingUseCase: sl(),
            updateListingUseCase: sl(),
            markAsSoldUseCase: sl(),
            deleteListingUseCase: sl(),
            filterListings: sl(),
          ),
          update: (_, auth, listings) =>
              listings!..updateCurrentUser(auth.currentUser?.id),
        ),
      ],
      child: MaterialApp(
        title: 'Sokopop',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const AuthGate(),
        routes: {
          AppRoutes.signIn: (_) => const SignInScreen(),
          AppRoutes.createAccount: (_) => const CreateAccountScreen(),
          AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.notifications: (_) => const NotificationsScreen(),
        },
      ),
    );
  }
}

/// Keeps the user signed in across restarts (auth persistence).
/// - Logged in  -> HomeScreen
/// - Logged out -> SplashScreen (Get Started / Sign in flow)
///
/// Now typed on the domain entity rather than `firebase_auth.User`.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: context.read<AuthProvider>().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            ),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const SplashScreen();
      },
    );
  }
}
