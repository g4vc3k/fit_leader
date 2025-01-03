import 'package:firebase_core/firebase_core.dart';
import 'package:fit_leader/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'notification_service.dart'; // Ensure to import your notification service
import 'home_page.dart';
import 'reminders_page.dart';
import 'points_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications(); // Initialize notifications
  await Firebase.initializeApp();
  runApp(FitLeaderApp());


}

class FitLeaderApp extends StatefulWidget {
  @override
  _FitLeaderAppState createState() => _FitLeaderAppState();
}

class _FitLeaderAppState extends State<FitLeaderApp> {
  int _selectedIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    HomePage(),
    RemindersPage(),
    PointsPage(),
    //PointsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Set selected page
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitLeader',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FitLeader', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 28)),
          backgroundColor: Colors.white, // Set AppBar color based on theme
          scrolledUnderElevation: 0,  // Remove shadow
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white, // Set BottomNavigationBar color based on theme
          selectedItemColor: Colors.green,
          selectedFontSize: 15,
          unselectedItemColor: Colors.grey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Strona Główna',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Przypomnienia',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Punkty',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
