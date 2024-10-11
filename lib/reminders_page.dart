import 'package:flutter/material.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Tutaj będą pojawiały się przypomnienia o zdrowych nawykach!',
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
