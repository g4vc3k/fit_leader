import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cześć, GracKE!",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "Masz 17 poziom",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Do kolejnego poziomu pozostało: 3★",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  "127",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 16),
                Icon(Icons.menu, size: 30),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(height: 30),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: EdgeInsets.all(16),
            children: [
              _buildGridButton(context, "Twój profil"),
              _buildGridButton(context, "Cele"),
              _buildGridButton(context, "Ranking"),
              _buildGridButton(context, "Znajomi"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, String title) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
