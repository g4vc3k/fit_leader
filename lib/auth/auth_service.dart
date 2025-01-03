import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase.dart'; // Import userSetup

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      final userCredential = await _auth.signInWithCredential(cred);

      // Call userSetup after Google login
      await userSetup(userCredential.user?.displayName ?? 'New User');
      return userCredential;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password,
      {required String displayName}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Call userSetup after email registration
      await userSetup(displayName);

      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    } catch (e) {
      log("Błąd");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("wrong");
      Fluttertoast.showToast(
          msg: "Błędny email lub hasło.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("wrong");
      Fluttertoast.showToast(
          msg: "Wylogowano.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  exceptionHandler(String code) {
    switch (code) {
      case "invalid-credential":
        Fluttertoast.showToast(
            msg: "Błędny email lub hasło.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        break;
      case "weak-password":
        Fluttertoast.showToast(
            msg: "Hasło musi składać się z przynajmniej 6 znaków.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        break;
      case "email-already-in-use":
        Fluttertoast.showToast(
            msg: "Konto z podanym adresem email już istnieje.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        break;
      default:
        Fluttertoast.showToast(
            msg: "Coś poszło nie tak.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }
}
