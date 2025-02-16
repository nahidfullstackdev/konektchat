import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:konekt_chat/screens/introduction_screen.dart';
import 'package:konekt_chat/screens/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return IntroScreen();
          }
        },
      ),
    );
  }
}
