import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sokopop_flutter_app/app.dart';
import 'package:sokopop_flutter_app/core/di/service_locator.dart';

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

  // Wire up data sources, repositories and use cases before the first frame.
  await initDependencies();

  // NOTE: the portrait-only lock that used to live here has been removed.
  // The rubric asks for landscape responsiveness and a rotation demo, and
  // SystemChrome.setPreferredOrientations made both impossible. Screens now
  // need checking for overflow in landscape.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const SokopopApp());
}
