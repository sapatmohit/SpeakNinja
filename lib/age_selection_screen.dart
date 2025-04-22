// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'profile_screen.dart';
// import 'components/age_selection.dart';
// import 'username.dart';
//
// class AgeSelectionScreen extends StatefulWidget {
//   final String name;
//
//   AgeSelectionScreen({required this.name});
//
//   @override
//   _AgeSelectionScreenState createState() => _AgeSelectionScreenState();
// }
//
// class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
//   final List<String> ages = [
//     "Under 12",
//     "12 - 15",
//     "16 - 24",
//     "25 - 34",
//     "35 - 44",
//     "45 - 54",
//     "55 or older"
//   ];
//
//   void _handleAgeSelection(String age) async {
//     // Update the user's record with the selected age.
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DatabaseReference userRef =
//       FirebaseDatabase.instance.ref("users/${user.uid}");
//       await userRef.update({
//         'age': age,
//       }).catchError((error) {
//         print("Error updating age: $error");
//       });
//     } else {
//       print("No authenticated user found; cannot update age.");
//     }
//
//     // Navigate to the next screen (ProfilePictureScreen, for example)
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProfilePictureScreen(),
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
//           onPressed: () => Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => UsernameScreen()),
//           ),
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
//                 Text("Hi ${widget.name}!",
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFFE07C32))),
//                 Text("How old are you?",
//                     style: TextStyle(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFFE07C32))),
//               ],
//             ),
//           ),
//           SizedBox(height: 40),
//           AgeSelection(ages: ages, onAgeSelected: _handleAgeSelection),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'profile_screen.dart';
import 'username.dart';

class AgeSelectionScreen extends StatefulWidget {
  final String name;

  AgeSelectionScreen({required this.name});

  @override
  _AgeSelectionScreenState createState() => _AgeSelectionScreenState();
}

class _AgeSelectionScreenState extends State<AgeSelectionScreen> {
  final List<String> ages = [
    "Under 12",
    "12 - 15",
    "16 - 24",
    "25 - 34",
    "35 - 44",
    "45 - 54",
    "55 or older"
  ];

  void _handleAgeSelection(String age) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef =
      FirebaseDatabase.instance.ref("users/${user.uid}");
      await userRef.update({
        'age': age,
      }).catchError((error) {
        print("Error updating age: $error");
      });
    } else {
      print("No authenticated user found; cannot update age.");
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePictureScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5F4FD),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/wave2.png',
              fit: BoxFit.cover,
              height: 200,
            ),
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
                height: 180,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF004B73), size: 28),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UsernameScreen()),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Hi ${widget.name} !!!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "How old are you ?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004B73),
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: ListView.separated(
                      itemCount: ages.length,
                      separatorBuilder: (_, __) => SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _handleAgeSelection(ages[index]),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              ages[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF004B73),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}