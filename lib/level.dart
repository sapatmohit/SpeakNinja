import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'components/level_selection.dart';
import 'reason.dart';
import 'level_questionnaire.dart'; // Import the new screen

class LevelSelectionScreen extends StatefulWidget {
  @override
  _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final List<String> levels = [
    "Beginner",
    "Intermediate",
    "Advanced",
    "Know your Level"
  ]; // Level options

  Future<void> _handleLevelSelection(String level) async {
    // Retrieve the currently authenticated user
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Create a reference to the user's node in the Realtime Database
        DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
        // Update the user's record with the selected level
        await userRef.update({
          'level': level,
        });
      } catch (error) {
        print("Error updating level: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating level. Please try again.")),
        );
      }
    } else {
      print("No authenticated user found.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not authenticated.")),
      );
      return;
    }

    // Determine the next screen based on the selected level
    Widget nextScreen;
    if (level == "Know your Level") {
      nextScreen = KnowYourLevelScreen(); // Navigate to a different page
    } else {
      nextScreen = ReasonSelectionScreen(); // Default page
    }

    // Navigate to the next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAF7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFE07C32), size: 40),
          onPressed: () => Navigator.pop(context), // Fixed back navigation
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("So your level based on",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE07C32))),
                Text("How’s your English?",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE07C32))),
              ],
            ),
          ),
          SizedBox(height: 50),
          LevelSelection(
              levels: levels,
              onLevelSelected: _handleLevelSelection),
        ],
      ),
    );
  }
}
