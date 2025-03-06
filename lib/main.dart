import 'package:flutter/material.dart';
import 'chatbot.dart';
import 'login.dart';

void main() {
  runApp(SpeakNinjaApp());
}

class SpeakNinjaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeakNinja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
