import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

import '../services/auth_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosmic Explorer',
      theme: ThemeData(
          colorScheme: ColorScheme.dark(
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        secondary: Colors.deepPurpleAccent,
        onSecondary: Colors.white,
        // background: Colors.white,
        // onBackground: Colors.white,
        // surface: Colors.white,
        // onSurface: Colors.white,
        error: Colors.redAccent,
      )),
      home: const AuthService(),
    );
  }
}
