import 'package:flutter/material.dart';
import 'weekly_summary.dart';
import 'confirm_action_page.dart'; // Import strony ConfirmActionPage
import 'notification_service.dart'; // Plik z logiką powiadomień

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            // First Container with greeting and score
            Container(
              width: 200,
              height: 230,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_box_rounded,
                    size: 128,
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      Text(
                        "Cześć, GracKe!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Udało Ci się zdobyć 440 punktów!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Summary widget
            Summary(),

            // Second Container with Fit Leader message
            Container(
              width: 200,
              height: 230,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start, // Start from the left
                children: [
                  Text(
                    "Chcesz zostać Fit Liderem?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10), // Add spacing between the title and description
                  // Replaced Row with Column to allow text to wrap
                  Text(
                    "Postaraj się zaliczyć jak najwięcej zadań! Ich harmonogram możesz ustawić według własnych potrzeb i możliwości. Pamiętaj o tym by robić to systematycznie - to klucz do sukcesu.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.justify, // Makes the text look cleaner
                    softWrap: true, // Allow text to wrap naturally
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
