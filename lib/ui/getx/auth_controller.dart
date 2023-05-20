import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/user_model.dart';
import '../utils/app_colors.dart';

class AuthController extends GetxController {

  Future<bool> registerWithEmailAndPassword(String email, String password,
      String type, String shopName, String userName) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      userCredential.user!.sendEmailVerification();

      userCredential.user!.sendEmailVerification();
      log('username controller ${userCredential.user!.uid}');

      UserModel user = UserModel(
          userName: userName,
          id: userCredential.user!.uid,
          email: email,
          type: type,
          shopName: shopName);
      UserModel().saveUser(user);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        customeMessage(
            "Error",
            "Weak Password!",
            const Icon(
              Icons.error,
              color: Colors.red,
            ));
      } else if (e.code == 'email-already-in-use') {
        customeMessage(
            "Error",
            "Email Provided already Exists",
            const Icon(
              Icons.error,
              color: Colors.red,
            ));
      }
      return false;
    } catch (e) {
      customeMessage(
          "Error",
          e.toString(),
          const Icon(
            Icons.error,
            color: Colors.red,
          ));
    }
    return false;
  }

  Future<String?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final DatabaseReference usersRef =
      FirebaseDatabase.instance.ref().child('users/${userCredential.user!.uid}');
      usersRef.update({
        'token' : token
      });

      return userCredential.user?.uid;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password';
      } else {
        return e.message;
      }
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(userId);

    DatabaseEvent dataSnapshot = await userRef.once();
    if (dataSnapshot.snapshot.value != null) {
      Map<String, dynamic>? user =
          (dataSnapshot.snapshot.value as Map<Object?, Object?>)
              .cast<String, dynamic>();
      return user;
    }
    return null;
  }
}
