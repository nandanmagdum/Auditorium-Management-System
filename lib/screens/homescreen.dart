import 'package:audi/backend/backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_api/backend.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();
    User? user = FirebaseAuth.instance.currentUser;
    String? usser = user?.email;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            FirebaseAuth.instance.signOut();
          },
          child: Text("Sign out of $usser"),
        ),
      ),
    );
  }
}
