import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'reason.dart';
import 'level_questionnaire.dart';

class LevelSelectionScreen extends StatefulWidget {
  @override
  _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final List<String> levels = [
    "Beginner",
    "Intermediate",
    "Advanced",
  ];

  Future<void> _handleLevelSelection(String level) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
        await userRef.update({
          'level': level,
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating level.")),
        );
        return;
      }
    }

    Widget nextScreen = (level == "Know your Level")
        ? KnowYourLevelScreen()
        : ReasonSelectionScreen();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAF7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF013668), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(3.14159),
              child: Image.asset(
                'assets/wave2.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  "On scale of 1–3",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  "How’s your English?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF013668)),
                ),
                const SizedBox(height: 30),
                ...levels.map((level) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () => _handleLevelSelection(level),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                      ),
                      child: Text(
                        level,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF013668)),
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF005292),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      shadowColor: Colors.black26,
                    ),
                    onPressed: () => _handleLevelSelection("Know your Level"),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Know your Level",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}