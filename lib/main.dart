import 'package:flutter/material.dart';
import 'Event_screen.dart';

void main() {
  runApp(Event());
}

class Event extends StatelessWidget {
  const Event({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: EventPage(),
    );
  }
}
