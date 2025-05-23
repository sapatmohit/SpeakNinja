import 'package:flutter/material.dart';
import 'afterlogin/roadmap.dart';
import 'login.dart';
// import 'home.dart';                    // <-- Create this file/screen
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'mistral_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mistralService = MistralService();
  await mistralService.saveApiKey("CoagecxPD3jLlYyOFT8qTN3KKbB9jOio");
  await Firebase.initializeApp();

  // Retrieve login state from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("test_data");

  MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('hi', 'IN'), // Hindi
      ],
      title: 'SpeakNinja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // If already logged in, go to Home, otherwise show Login
      home: isLoggedIn ? RoadmapPage() : LoginScreen(),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'login.dart';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final DatabaseReference dbRef = FirebaseDatabase.instance.ref("test_data");
//
// // class SpeakNinjaApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SpeakNinja',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginScreen(),
//     );
//   }
// }
