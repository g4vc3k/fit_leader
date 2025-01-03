import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> userSetup(String displayName) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = auth.currentUser;

  if (currentUser == null) {
    throw Exception("No user is signed in");
  }

  final String uid = currentUser.uid;
  final int points = 0;

  final DocumentReference userDoc = FirebaseFirestore.instance.collection("users").doc(uid);

  try {
    final DocumentSnapshot docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      // Document exists, update only the necessary fields
      Fluttertoast.showToast(
          msg: "Zalogowano",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      // Document does not exist, create a new one
      await userDoc.set(
        {'displayName': displayName, 'uid': uid, 'points': points},
        SetOptions(merge: true),
      );
    }
  } catch (e) {
    throw Exception("Failed to set up user: $e");
  }
}
