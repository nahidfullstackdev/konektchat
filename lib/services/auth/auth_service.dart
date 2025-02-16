// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:konekt_chat/common/repository/comonFirebaseStorageRepo.dart';
import 'package:konekt_chat/common/utils/utils.dart';
import 'package:konekt_chat/models/user_model.dart';
import 'package:konekt_chat/screens/home_screen.dart';
import 'package:konekt_chat/screens/introduction_screen.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    firebaseStorage: FirebaseStorage.instance,
  );
});

class AuthService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;

  AuthService({
    required this.auth,
    required this.firestore,
    required this.firebaseStorage,
  });

  User? getCurrentUser() {
    return auth.currentUser;
  }

  // // signup with email auth...

  void signOut(BuildContext context) async {
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      IntroScreen.routeName,
      (route) => false,
    );
  }

  void signUpwithEmail(
      BuildContext context, String email, String password) async {
    try {
      // create user..
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
      return;
    }
  }

  // //login Email Auth...
  void signInwithEmail(
      BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.routeName,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }

// saving user data to firebase....
  void saveUserDataToFirestore({
    required BuildContext context,
    required String username,
    required String password,
    required File? profilePic,
  }) async {
    try {
      // Check if currentUser is null
      if (auth.currentUser == null) {
        throw Exception("User is not authenticated.");
      }

      String uid = auth.currentUser!.uid;
      String photoUrl = profileAvatar;

      if (profilePic != null) {
        photoUrl =
            await Commonfirebasestoragerepo(firebaseStorage: firebaseStorage)
                .storeFileToFirebase('profilePic/$uid', profilePic);
      }

      final user = UserModel(
        uid: uid,
        name: username,
        email: auth.currentUser!.email ??
            '', // Provide a default value if email is null
        password: password,
        isOnline: true,
        groupId: [],
        profilePic: photoUrl,
      );

      await firestore.collection('users').doc(uid).set(user.toMap());
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context: context, content: e.toString());
      }
    }
  }
}
