import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_leader/leaderboard_page.dart';
import 'package:flutter/material.dart';
import 'package:fit_leader/avatars_page.dart';
import 'package:fit_leader/dashboard.dart';
import 'package:fit_leader/new_home_page.dart';
import 'package:fit_leader/points_page.dart';
import 'package:fit_leader/reminders_page.dart';
import 'auth/auth_service.dart';
import 'weekly_summary.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  int? pointsValue;
  String? selectedAvatar;
  String? selectedSticker; // Add selectedSticker field
  Color? backgroundColor;
  bool isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        setState(() {
          userName = userDoc['displayName'];
          pointsValue = userDoc['points'];
          selectedAvatar = userDoc['avatar'];
          selectedSticker = userDoc['sticker']; // Retrieve sticker from Firestore
          backgroundColor = userDoc['backgroundColor'] != null
              ? Color(userDoc['backgroundColor'])
              : Colors.yellow; // Default to yellow if no color is saved
          isLoading = false; // Set loading to false once data is fetched
        });
      } catch (e) {
        // Handle error if needed
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          // First Container with greeting and score
          Container(
            width: double.infinity, // Take up the full width
            height: 280,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Show selected avatar if available, else show a default icon
                isLoading
                    ? const CircularProgressIndicator() // Show loading spinner
                    : Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor ?? Colors.yellow, // Set dynamic background color
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Sticker placed behind the avatar
                      if (selectedSticker != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(120), // Make sticker fit behind the avatar
                          child: Image.asset(
                            'lib/assets/stickers/$selectedSticker',
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      // Main Avatar
                      ClipOval(
                        child: selectedAvatar != null
                            ? Image.asset(
                          'lib/assets/avatars/$selectedAvatar',
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover, // Crop and scale the image
                        )
                            : const Icon(
                          Icons.account_box_rounded,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                  "Cześć, ${userName ?? 'Pomidor'}!", // Show current user name if available
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Liczba zdobytych punktów to ${pointsValue ?? 0}.",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Weekly summary widget
          Summary(),

          // Second Container with Fit Leader message
          Container(
            width: double.infinity, // Take up the full width
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Start from the left
              children: [
                const Text(
                  "Chcesz zostać Fit Liderem?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10), // Add spacing between the title and description
                const Text(
                  "Postaraj się zaliczyć jak najwięcej zadań! Ich harmonogram możesz ustawić według własnych potrzeb i możliwości. Pamiętaj o tym by robić to systematycznie - to klucz do sukcesu.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.justify, // Makes the text look cleaner
                  softWrap: true, // Allow text to wrap naturally
                ),
                TextButton(
                  onPressed: () async {
                    await _auth.signout();
                  },
                  child: const Text('Wyloguj'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AvatarSelectionPage()),
                    );
                  },
                  child: const Text('Wybierz awatar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeaderboardPage()),
                    );
                  },
                  child: const Text('Tabela wyników'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
