import 'package:flutter/material.dart';
import 'package:login_sample/functions.dart';
import 'package:login_sample/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      title: 'Login Application',
      home: const SplashScreen(),
    );
  }
}
