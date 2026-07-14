import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/listing_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/notifications_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC15WFIGy52k5eOSiaUzY-AKxzplIz2FHg",
        authDomain: "sokopop.firebaseapp.com",
        projectId: "sokopop",
        storageBucket: "sokopop.firebasestorage.app",
        messagingSenderId: "1099152154419",
        appId: "1:1099152154419:web:295a711662e62eb88f2846",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const SokopopApp());
}

class SokopopApp extends StatelessWidget {
  const SokopopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ListingProvider()),
      ],
      child: MaterialApp(
        title: 'Sokopop',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const AuthGate(),
        routes: {
          '/sign_in': (_) => const SignInScreen(),
          '/create_account': (_) => const CreateAccountScreen(),
          '/forgot_password': (_) => const ForgotPasswordScreen(),
          '/home': (_) => const HomeScreen(),
          '/notifications': (_) => const NotificationsScreen(),
        },
      ),
    );
  }
}

/// AuthGate keeps the user signed in after the app restarts (auth persistence).
/// - Logged in  -> straight to HomeScreen
/// - Logged out -> SplashScreen (Get Started / Sign in flow)
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
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