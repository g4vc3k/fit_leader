import 'package:flutter/material.dart';
import 'auth/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PointsPage());
}

class PointsPage extends StatelessWidget {
  PointsPage({super.key});

  final displayNameController = TextEditingController();
  final levelController = TextEditingController();
  final pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: displayNameController,
              decoration: const InputDecoration(
                hintText:'Imię',
              ),
            ),
            TextFormField(
              controller: levelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText:'Poziom',
              ),
            ),
            TextFormField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText:'Punkty',
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final User? currentUser = auth.currentUser;

                  if (currentUser == null) {
                    print("No user is signed in");
                    return;  // Handle no user case (you might show an alert)
                  }

                  String userId = currentUser.uid;  // Use the current user's UID
                  DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

                  try {
                    await userRef.update({
                      'displayName': displayNameController.text,
                      'level': int.parse(levelController.text),
                      'points': int.parse(pointsController.text),
                    });
                  } catch (error) {
                    print("Error updating user data: $error");
                  }
                },
                child: const Text('Update')
            )
          ],
        ),
      ),
    );
  }
}
