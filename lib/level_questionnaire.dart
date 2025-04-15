// import 'package:flutter/material.dart';
// import 'result_level.dart';  // Import the separate file
//
// class KnowYourLevelScreen extends StatefulWidget {
//   @override
//   _KnowYourLevelScreenState createState() => _KnowYourLevelScreenState();
// }
//
// class _KnowYourLevelScreenState extends State<KnowYourLevelScreen> {
//   final List<String> questions = [
//     "Introduce yourself (Mention your name, age, and hometown)",
//     "Describe a memorable Indian festival or celebration you recently attended",
//     "Talk about your daily routine, including any typical Indian habits or customs.",
//     "What would you do if you suddenly received one crore rupees?",
//     "Share an experience you had while travelling in India",
//     "What is your favorite Indian dish and why?",
//     "Describe a challenging situation you faced and how you overcame it.",
//     "If you could visit any place in India, where would it be and why?",
//     "What is the most inspiring story you have heard about an Indian personality?",
//     "What are your future goals and how do you plan to achieve them?"
//   ];
//
//   List<TextEditingController> controllers = [];
//   bool allAnswered = false;
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     controllers =
//         List.generate(questions.length, (_) => TextEditingController());
//     for (var controller in controllers) {
//       controller.addListener(_checkAllAnswersFilled);
//     }
//   }
//
//   void _checkAllAnswersFilled() {
//     setState(() {
//       allAnswered =
//           controllers.every((controller) => controller.text.trim().isNotEmpty);
//     });
//   }
//
//   @override
//   void dispose() {
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   void _navigateToResult() {
//     if (allAnswered) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ResultLevelScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFAF7),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Color(0xFFE07C32), size: 40),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Know",
//               style: TextStyle(fontSize: 22, color: Color(0xFFE07C32)),
//             ),
//             Text(
//               " Your Level?",
//               style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFE07C32)),
//             ),
//             SizedBox(height: 40),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(right: 1), // Adjust padding to prevent overlap
//                 child: Scrollbar(
//                   thickness: 6, // Adjust scrollbar thickness
//                   radius: Radius.circular(10),
//                   thumbVisibility: true, // Always show scrollbar
//                   controller: _scrollController,
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     itemCount: questions.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.only(bottom: 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.85,
//                               child: Text(
//                                 "${index + 1}. ${questions[index]}",
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xFFE07C32)),
//                               ),
//                             ),
//
//                             SizedBox(height: 10),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width * 0.85, // Adjust width as needed
//                               child: TextField(
//                                 controller: controllers[index],
//                                 maxLines: null,
//                                 keyboardType: TextInputType.multiline,
//                                 decoration: InputDecoration(
//                                   hintText: "Enter Answer",
//                                   hintStyle: TextStyle(color: Colors.grey),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                     borderSide: BorderSide(color: Colors.grey),
//                                   ),
//                                   contentPadding:
//                                   EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 30)
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Center(
//               child: ElevatedButton(
//                 onPressed: allAnswered ? _navigateToResult : null, // Disable button if not all answered
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: allAnswered ? Color(0xFFE07C32) : Colors.grey,
//                   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: Text(
//                   "Next",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'result_level.dart';  // Import the separate file

class KnowYourLevelScreen extends StatefulWidget {
  @override
  _KnowYourLevelScreenState createState() => _KnowYourLevelScreenState();
}

class _KnowYourLevelScreenState extends State<KnowYourLevelScreen> {
  final List<String> questions = [
    "Introduce yourself (Mention your name, age, and hometown)",
    "Describe a memorable Indian festival or celebration you recently attended",
    "Talk about your daily routine, including any typical Indian habits or customs.",
    "What would you do if you suddenly received one crore rupees?",
    "Share an experience you had while travelling in India",
    "What is your favorite Indian dish and why?",
    "Describe a challenging situation you faced and how you overcame it.",
    "If you could visit any place in India, where would it be and why?",
    "What is the most inspiring story you have heard about an Indian personality?",
    "What are your future goals and how do you plan to achieve them?"
  ];

  List<TextEditingController> controllers = [];
  bool allAnswered = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controllers = List.generate(questions.length, (_) => TextEditingController());
    for (var controller in controllers) {
      controller.addListener(_checkAllAnswersFilled);
    }
  }

  void _checkAllAnswersFilled() {
    setState(() {
      allAnswered = controllers.every((controller) => controller.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  /// This function writes or updates the user's responses in the Firebase Realtime Database.
  Future<void> _saveResponses() async {
    // Get the current user from FirebaseAuth.
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not authenticated; log error.
      print("User is not authenticated.");
      return;
    }

    // Create a reference to the user's node using their UID.
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${user.uid}");

    // Build the answers map with all the responses.
    Map<String, dynamic> answersData = controllers.asMap().map(
            (index, controller) {
          String answer = controller.text.trim();
          print("Question ${index + 1} answer: $answer"); // Debug log for each answer.
          return MapEntry('question${index + 1}', answer);
        }
    );

    // Debug log: Print the whole map.
    print("Answers data to be saved: $answersData");

    // Attempt to update the user node with answers and a new timestamp.
    try {
      await ref.update({
        'answers': answersData,
        'timestamp': DateTime.now().toIso8601String(),
      });
      print("User responses updated successfully for user: ${user.uid}");
    } catch (e) {
      // Log any errors during update.
      print("Error updating responses: $e");
    }
  }

  void _navigateToResult() async {
    if (allAnswered) {
      await _saveResponses(); // Save responses first.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultLevelScreen()),
      );
    } else {
      print("Not all questions are answered!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFE07C32), size: 40),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Know",
              style: TextStyle(fontSize: 22, color: Color(0xFFE07C32)),
            ),
            Text(
              " Your Level?",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE07C32)),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 1),
                child: Scrollbar(
                  thickness: 6,
                  radius: Radius.circular(10),
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Text(
                                "${index + 1}. ${questions[index]}",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFFE07C32)),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: TextField(
                                controller: controllers[index],
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: "Enter Answer",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ),
                            SizedBox(height: 30)
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: allAnswered ? _navigateToResult : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: allAnswered ? Color(0xFFE07C32) : Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
