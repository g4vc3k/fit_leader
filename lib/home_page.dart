import 'package:flutter/material.dart';
import 'notification_service.dart'; // Plik z logiką powiadomień

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Stań się nowym Fit Liderem!',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showNotification(); // Wywołanie funkcji z logiki powiadomień
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen[600]
            ),
            child: const Text('Test Powiadomienia',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
