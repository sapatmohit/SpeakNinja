// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'components/level_selection.dart';
// import 'reason.dart';
// import 'level_questionnaire.dart'; // Import the new screen
//
// class LevelSelectionScreen extends StatefulWidget {
//   @override
//   _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
// }
//
// class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
//   final List<String> levels = [
//     "Beginner",
//     "Intermediate",
//     "Advanced",
//     "Know your Level"
//   ]; // Level options
//
//   Future<void> _handleLevelSelection(String level) async {
//     // Retrieve the currently authenticated user
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         // Create a reference to the user's node in the Realtime Database
//         DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
//         // Update the user's record with the selected level
//         await userRef.update({
//           'level': level,
//         });
//       } catch (error) {
//         print("Error updating level: $error");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error updating level. Please try again.")),
//         );
//       }
//     } else {
//       print("No authenticated user found.");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("User not authenticated.")),
//       );
//       return;
//     }
//
//     // Determine the next screen based on the selected level
//     Widget nextScreen;
//     if (level == "Know your Level") {
//       nextScreen = KnowYourLevelScreen(); // Navigate to a different page
//     } else {
//       nextScreen = ReasonSelectionScreen(); // Default page
//     }
//
//     // Navigate to the next screen
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => nextScreen,
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
//                 Text("So your level based on",
//                     style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFFE07C32))),
//                 Text("How’s your English?",
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFFE07C32))),
//               ],
//             ),
//           ),
//           SizedBox(height: 50),
//           LevelSelection(
//               levels: levels,
//               onLevelSelected: _handleLevelSelection),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'reason.dart';
// import 'level_questionnaire.dart';
//
// class LevelSelectionScreen extends StatefulWidget {
//   @override
//   _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
// }
//
// class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
//   final List<String> levels = [
//     "Beginner",
//     "Intermediate",
//     "Advanced",
//   ];
//
//   Future<void> _handleLevelSelection(String level) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
//         await userRef.update({
//           'level': level,
//         });
//       } catch (error) {
//         print("Error updating level: $error");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error updating level. Please try again.")),
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
//     Widget nextScreen;
//     if (level == "Know your Level") {
//       nextScreen = KnowYourLevelScreen();
//     } else {
//       nextScreen = ReasonSelectionScreen();
//     }
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => nextScreen),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFAF7),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Color(0xFF013668), size: 30),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.rotationX(3.14159),
//               child: Image.asset(
//                 'assets/wave2.png',
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 8),
//                 Text(
//                   "On scale of 1–3",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black.withOpacity(0.6),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   "How’s your English?",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF013668),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 ...levels.map((level) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: GestureDetector(
//                       onTap: () => _handleLevelSelection(level),
//                       child: Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 24, vertical: 14),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 10,
//                               offset: Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Text(
//                           level,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF013668),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 const SizedBox(height: 20),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF005292),
//                       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       elevation: 6,
//                       shadowColor: Colors.black26,
//                     ),
//                     onPressed: () => _handleLevelSelection("Know your Level"),
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Know your Level",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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