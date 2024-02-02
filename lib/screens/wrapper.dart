import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zone_trader/authentication/signin.dart';
import 'package:zone_trader/screens/startpage.dart';

class AuthWrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            return const StartPage();
          } else {
            // User is not signed in
            return const SignInScreen();
          }
        }
      },
    );
  }
}