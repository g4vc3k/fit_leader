import 'package:flutter/material.dart';

class PointsPage extends StatelessWidget {
  const PointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Tutaj zobaczysz swoje zdobyte punkty!',
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
