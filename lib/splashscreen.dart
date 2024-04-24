import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_sample/home.dart';
import 'package:login_sample/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

const realkey = 'userloggedin';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkUserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon-for-student-19.jpg',
              height: 100,
              width: 100,
            ),
            const Text(
              'STUDENT DETAILS APP',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            )
          ],
        ),
      ),
    );
  }

  Future<void> loginPath() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Future<void> checkUserLoggedIn() async {
    final sharedPref = await SharedPreferences.getInstance();
    final userloggedin = sharedPref.getBool(realkey);
    if (userloggedin == null || userloggedin == false) {
      loginPath();
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context1) => const MyHome()));
    }
  }
}
