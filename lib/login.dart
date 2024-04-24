import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_sample/home.dart';
import 'package:login_sample/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final useridget = TextEditingController();
  final passwordget = TextEditingController();
  bool mismatch = true;
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                const Text(
                  'WELOCME TO LOGIN PAGE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: useridget,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the user id',
                      filled: true,
                      fillColor: Colors.white),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordget,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the password',
                      filled: true,
                      fillColor: Colors.white),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Visibility(
                      visible: !mismatch,
                      child: const Text(
                        'Username and Password is mismatch',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
                ElevatedButton.icon(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        loginpath(context);
                      } else {
                        null;
                      }
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Login'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginpath(BuildContext context) async {
    final userid = useridget.text;
    final password = passwordget.text;
    if (userid == 'meghanathan@gmail.com' || password == 'haihai') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyHome()));
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setBool(realkey, true);
    } else {
      setState(() {
        mismatch = false;
      });
    }
  }
}
