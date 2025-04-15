// import 'package:flutter/material.dart';
// import 'components/level_selection.dart';
// import 'found_out.dart';
//
// class ReasonSelectionScreen extends StatefulWidget {
//   @override
//   _ReasonSelectionScreenState createState() =>
//       _ReasonSelectionScreenState();
// }
//
// class _ReasonSelectionScreenState extends State<ReasonSelectionScreen> {
//   final List<String> levels = [
//     "Family and friends",
//     "Culture",
//     "Education",
//     "Self improvement",
//     "Travel",
//     "Work"
//   ]; // Language options
//
//   void _handleLevelSelection(String level) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FoundSelectionScreen(), // Pass name
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
//                 Text("Why do you want to",
//                     style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFFE07C32))),
//                 Text("improve your English ?",
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
//           SizedBox(height: 50),
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FoundSelectionScreen(),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFE07C32),
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//               ),
//               child: Text(
//                 "Next",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'components/level_selection.dart';
import 'found_out.dart';

class ReasonSelectionScreen extends StatefulWidget {
  @override
  _ReasonSelectionScreenState createState() => _ReasonSelectionScreenState();
}

class _ReasonSelectionScreenState extends State<ReasonSelectionScreen> {
  final List<String> levels = [
    "Family and friends",
    "Culture",
    "Education",
    "Self improvement",
    "Travel",
    "Work"
  ];

  String? selectedReason;

  /// Save the selected reason into the Firebase Realtime Database.
  Future<void> _saveSelectedReason() async {
    // Reference the "reasons" node in your database (adjust the path as needed)
    DatabaseReference ref = FirebaseDatabase.instance.ref("reasons");

    // Create a map of the selected data.
    Map<String, dynamic> data = {
      'selectedReason': selectedReason,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Debug log: Print the data before pushing.
    print("Saving reason selection: $data");

    // Push the new selection entry to the database with error handling.
    try {
      await ref.push().set(data);
      print("Reason selection saved successfully.");
    } catch (e) {
      print("Error saving reason selection: $e");
    }
  }

  void _handleLevelSelection(String level) {
    setState(() {
      selectedReason = level;
      print("Level selected: $selectedReason"); // Debug log.
    });
  }

  void _navigateToNext() async {
    // Ensure a reason has been selected.
    if (selectedReason != null) {
      // Save the selected reason to the database.
      await _saveSelectedReason();

      // Navigate to the next screen.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FoundSelectionScreen()),
      );
    } else {
      // If no selection is made, show a message to the user.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a reason before proceeding.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAF7),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFE07C32), size: 40),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Why do you want to",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE07C32)),
                ),
                Text(
                  "improve your English?",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE07C32)),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          // LevelSelection Widget.
          LevelSelection(
            levels: levels,
            onLevelSelected: _handleLevelSelection,
          ),
          SizedBox(height: 50),
          // Next Button.
          Center(
            child: ElevatedButton(
              onPressed: _navigateToNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE07C32),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
