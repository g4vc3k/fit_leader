import 'package:firebase_core/firebase_core.dart';
import 'package:fit_leader/auth/login_page.dart';
import 'package:fit_leader/wrapper.dart';
import 'package:flutter/material.dart';
import 'notification_service.dart'; // Ensure to import your notification service
import 'home_page.dart';
import 'reminders_page.dart';
import 'points_page.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications(); // Initialize notifications
  await Firebase.initializeApp();
  runApp(LoginScreen());
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.loginPage,
      home: Wrapper(
      ),

    );


  }
}


