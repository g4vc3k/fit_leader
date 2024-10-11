import 'package:flutter/material.dart';
import 'notification_service.dart'; // Upewnij się, że importujesz swój serwis powiadomień
import 'home_page.dart';
import 'reminders_page.dart';
import 'points_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications(); // Inicjalizuj powiadomienia
  runApp(FitLeaderApp());
}

class FitLeaderApp extends StatefulWidget {
  @override
  _FitLeaderAppState createState() => _FitLeaderAppState();
}

class _FitLeaderAppState extends State<FitLeaderApp> {
  int _selectedIndex = 0;

  // Lista stron do nawigacji
  final List<Widget> _pages = [
    HomePage(),
    RemindersPage(),
    PointsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Ustaw wybraną stronę
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLeader',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FitLeader', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.lightGreen[800],
        ),
        body: _pages[_selectedIndex], // Wyświetl odpowiednią stronę
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightGreen[800],
          selectedItemColor: Colors.white,
          selectedFontSize: 15,
          unselectedItemColor: Colors.lightGreen[100],
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