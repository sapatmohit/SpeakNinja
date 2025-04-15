import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'components/language_selection.dart';
import 'profile_screen.dart';
import 'level.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final List<String> languages = [
    "Hindi",
    "Marathi",
    "English"
  ]; // Language options

  // When a language is selected, update the corresponding user's record in Firebase Realtime Database
  Future<void> _handleLanguageSelection(String language) async {
    // Retrieve the currently authenticated user.
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Create a reference to the user's node in the Realtime Database.
        DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
        // Update the user's record with the selected language.
        await userRef.update({
          'language': language,
        });
      } catch (error) {
        print("Error updating language: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating language. Please try again.")),
        );
        return;
      }
    } else {
      print("No authenticated user found.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not authenticated.")),
      );
      return;
    }

    // After updating the language, navigate to the LevelSelectionScreen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelSelectionScreen(),
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
                Text("Hello,",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE07C32))),
                Text("Which language do you prefer?",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE07C32))),
              ],
            ),
          ),
          SizedBox(height: 150),
          LanguageSelection(
              languages: languages,
              onLanguageSelected: _handleLanguageSelection),
        ],
      ),
    );
  }
}
