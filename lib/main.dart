import 'dart:isolate';
import 'dart:async';
import 'package:audi/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:audi/screens/homepage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
 // import 'package:android_alarm_manager/android_alarm_manager.dart';
 void printDateTime()
 {
   DateTime  date = DateTime.now();
   print("background running .... : ${date}");
 }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // fontFamily:
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
              if(snapshot.hasData){
                return const HomePage();
              } else {
                return const LoginScreen();
              }
            }
      ),
    );
  }
}
