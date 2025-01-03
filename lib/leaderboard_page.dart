import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool isFetchingData = true;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  Future<void> _fetchLeaderboardData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('points', descending: true)  // Sort by points in descending order
          .get();

      List<Map<String, dynamic>> fetchedUsers = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final displayName = data['displayName'] ?? 'Unknown';
        final avatar = data['avatar'] ?? '';
        final backgroundColor = data['backgroundColor'] ?? 0;
        final sticker = data['sticker'] ?? '';
        final points = data['points'] ?? 0;
        final level = points ~/ 10;

        fetchedUsers.add({
          'displayName': displayName,
          'avatar': avatar,
          'backgroundColor': Color(backgroundColor),
          'sticker': sticker,
          'points': points,
          'level': level,
        });
      }

      setState(() {
        users = fetchedUsers;
        isFetchingData = false;
      });
    } catch (e) {
      print("Error fetching leaderboard data: $e");
      setState(() {
        isFetchingData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isFetchingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Leaderboard')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Avatar')),
              DataColumn(label: Text('Display Name')),
              DataColumn(label: Text('Level')),
              DataColumn(label: Text('Points')),
            ],
            rows: users.map((user) {
              return DataRow(cells: [
                DataCell(
                  SizedBox(
                    width: 40, // Avatar size
                    height: 40, // Avatar size
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background color
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: user['backgroundColor'],
                        ),
                        // Sticker
                        ClipOval(
                          child: Image.asset(
                            'lib/assets/stickers/${user['sticker']}',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Avatar image
                        ClipOval(
                          child: Image.asset(
                            'lib/assets/avatars/${user['avatar']}',
                            width: 35, // Slightly smaller to keep the sticker visible
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                DataCell(Text(user['displayName'])),
                DataCell(Text(user['level'].toString())),
                DataCell(Text(user['points'].toString())),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}