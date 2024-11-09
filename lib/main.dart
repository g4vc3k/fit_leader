import 'package:flutter/material.dart';
import 'notification_service.dart'; // Ensure to import your notification service
import 'home_page.dart';
import 'reminders_page.dart';
import 'points_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications(); // Initialize notifications
  runApp(FitLeaderApp());
}

class FitLeaderApp extends StatefulWidget {
  @override
  _FitLeaderAppState createState() => _FitLeaderAppState();
}

class _FitLeaderAppState extends State<FitLeaderApp> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  // List of pages for navigation
  final List<Widget> _pages = [
    HomePage(),
    RemindersPage(),
    PointsPage(),
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
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green,
        appBarTheme: AppBarTheme(
          color: Colors.white, // Light theme AppBar color
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 28),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // Light theme BottomNavigationBar background
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white10, // Dark mode background color
        appBarTheme: AppBarTheme(
          color: Colors.white10, // Dark theme AppBar color
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 28),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white10, // Dark theme BottomNavigationBar background
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // Switch between light and dark theme
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FitLeader', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 28)),
          backgroundColor: _isDarkMode ? Colors.black12: Colors.white, // Set AppBar color based on theme
          elevation: 0,  // Remove shadow
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: _isDarkMode ? Colors.black12 : Colors.white, // Set BottomNavigationBar color based on theme
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isDarkMode = !_isDarkMode; // Toggle dark mode
            });
          },
          child: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nights_stay),
        ),
      ),
    );
  }
}
