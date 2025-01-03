import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_leader/auth/auth_service.dart';
import 'package:fit_leader/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../dashboard.dart';
import '../main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login & Registration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  static const loginPage = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();


}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();

  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose(); //usuwanie z pamieci
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Logowanie",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.green, // Adjust text color based on theme
              ),
            ),
            SizedBox(height: 64),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Hasło',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Zaloguj'),
            ),
            SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async{
                  setState(() {
                    isLoading = true;
                  });
                  await _auth.loginWithGoogle();
                  setState(() {
                    isLoading = false;
                  });
                },
                child: Text('Kontynuuj z użyciem konta Google')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text('Nie masz konta? Zarejestruj tutaj'),
            ),
          ],
        ),
      ),
    );
  }
  _login()async{
    await _auth.loginUserWithEmailAndPassword(_emailController.text, _passwordController.text);

    // if(user != null){
    //   log("Zalogowano");
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => FitLeaderApp()),
      // );
    }
  }


class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _auth = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose(); //usuwanie z pamieci
  }

  @override
  Widget build(BuildContext context) {

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.white12 : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Rejestracja",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.green, // Adjust text color based on theme
              ),
            ),
            SizedBox(height: 64),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Imię',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Hasło',
                border: OutlineInputBorder(),
              ),
            ),
            // SizedBox(height: 16),
            // TextField(
            //   controller: _confirmPasswordController,
            //   obscureText: true,
            //   decoration: InputDecoration(
            //     labelText: 'Powtórz hasło',
            //     border: OutlineInputBorder(),
            //   ),
            // ),                                        //dokonczyc sprawdzanie hasla
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signup,
              child: Text('Stwórz konto'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Masz już konto? Zaloguj się tutaj'),
            ),
          ],
        ),
      ),
    );
  }

  // goToHome(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),
  // );
  _signup() async{
    final user = await _auth.createUserWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
      displayName: _nameController.text, // Send the name for user setup
    );
    Navigator.pop(context);
    // if(user != null) {
    //   log("zarejestrowano");
    //   Fluttertoast.showToast(
    //       msg: "Zarejestrowano.",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.CENTER,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0
    //   );
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //   );
    // }
  }

}
