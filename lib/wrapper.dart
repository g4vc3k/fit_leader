import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_leader/auth/login_page.dart';
import 'package:fit_leader/dashboard.dart';
import 'package:fit_leader/home_page.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget{
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:(context, snapshot)
    {
     if(snapshot.connectionState == ConnectionState.waiting){
       return const Center(
       child: CircularProgressIndicator(),
    );
    }else if(snapshot.hasError){
       return Center(child: Text("Error")
       );
     }else{
       if(snapshot.data == null){
         return LoginPage();
       }else{
         return FitLeaderApp();
       }
     }
     },
    ),
    );
  }
}