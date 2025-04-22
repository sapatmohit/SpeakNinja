// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'components/language_selection.dart';
// import 'profile_screen.dart';
// import 'level.dart';
//
// class LanguageSelectionScreen extends StatefulWidget {
//   @override
//   _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
// }
//
// class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
//   final List<String> languages = [
//     "Hindi",
//     "Marathi",
//     "English"
//   ]; // Language options
//
//   // When a language is selected, update the corresponding user's record in Firebase Realtime Database
//   Future<void> _handleLanguageSelection(String language) async {
//     // Retrieve the currently authenticated user.
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         // Create a reference to the user's node in the Realtime Database.
//         DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
//         // Update the user's record with the selected language.
//         await userRef.update({
//           'language': language,
//         });
//       } catch (error) {
//         print("Error updating language: $error");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error updating language. Please try again.")),
//         );
//         return;
//       }
//     } else {
//       print("No authenticated user found.");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("User not authenticated.")),
//       );
//       return;
//     }
//
//     // After updating the language, navigate to the LevelSelectionScreen.
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LevelSelectionScreen(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFAF7),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Color(0xFFE07C32), size: 40),
//           onPressed: () => Navigator.pop(context), // Fixed back navigation
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Hello,",
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFFE07C32))),
//                 Text("Which language do you prefer?",
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFFE07C32))),
//               ],
//             ),
//           ),
//           SizedBox(height: 150),
//           LanguageSelection(
//               languages: languages,
//               onLanguageSelected: _handleLanguageSelection),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
    "English",
  ];

  Future<void> _handleLanguageSelection(String language) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
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
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[900], size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: "What’s your\n",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: "native language ?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () => _handleLanguageSelection(languages[index]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Text(
                            languages[index],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(3.1416),
              child: Image.asset(
                'assets/wave2.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}