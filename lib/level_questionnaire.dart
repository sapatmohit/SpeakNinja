import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'result_level.dart';

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
  int? _focusedIndex;
  bool allAnswered = false;
  final ScrollController _scrollController = ScrollController();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

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
    _focusScopeNode.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> _callPredictionApi() async {
    final uri = Uri.parse('http://127.0.0.1:5000/predict');
    final payload = <String, dynamic>{};
    for (var i = 0; i < controllers.length; i++) {
      payload['Q${i + 1}_Response'] = controllers[i].text.trim();
    }

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('API error: \${response.statusCode} - \${response.body}');
      }
    } catch (e) {
      print('Failed to call API: \$e');
    }
    return null;
  }

  Future<void> _saveResponses() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not authenticated.");
      return;
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${user.uid}");
    Map<String, dynamic> answersData = controllers.asMap().map(
          (index, controller) => MapEntry('Q${index + 1}_Response', controller.text.trim()),
    );

    try {
      await ref.update({
        'answers': answersData,
        'timestamp': DateTime.now().toIso8601String(),
      });
      print("User responses updated successfully for user: ${user.uid}");
    } catch (e) {
      print("Error updating responses: \$e");
    }
  }

  void _navigateToResult() async {
    if (!allAnswered) return;

    await _saveResponses();
    final prediction = await _callPredictionApi();
    if (prediction != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultLevelScreen(prediction),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get prediction. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color headingColor = Color(0xFF00598B);
    final Color fieldBackground = Color(0xFFF7F7F8);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => _focusedIndex = null);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: headingColor, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Know Your",
                style: TextStyle(fontSize: 22, color: headingColor),
              ),
              Text(
                "Level",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: headingColor,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Scrollbar(
                  thickness: 6,
                  radius: Radius.circular(10),
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      bool isFocused = _focusedIndex == index;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}. ${questions[index]}",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: headingColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: fieldBackground,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: controllers[index],
                                maxLines: isFocused ? 6 : 1,
                                onTap: () {
                                  setState(() => _focusedIndex = index);
                                },
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  hintText: "Enter answer here",
                                  hintStyle: TextStyle(color: Color(0x4D00598B)),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: allAnswered ? _navigateToResult : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allAnswered ? headingColor : Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'result_level.dart';
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
//   int? _focusedIndex;
//   bool allAnswered = false;
//   final ScrollController _scrollController = ScrollController();
//   final FocusScopeNode _focusScopeNode = FocusScopeNode();
//
//   @override
//   void initState() {
//     super.initState();
//     controllers = List.generate(questions.length, (_) => TextEditingController());
//     for (var controller in controllers) {
//       controller.addListener(_checkAllAnswersFilled);
//     }
//   }
//
//   void _checkAllAnswersFilled() {
//     setState(() {
//       allAnswered = controllers.every((controller) => controller.text.trim().isNotEmpty);
//     });
//   }
//
//   @override
//   void dispose() {
//     for (var controller in controllers) {
//       controller.dispose();
//     }
//     _scrollController.dispose();
//     _focusScopeNode.dispose();
//     super.dispose();
//   }
//
//   Future<void> _saveResponses() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print("User is not authenticated.");
//       return;
//     }
//
//     DatabaseReference ref = FirebaseDatabase.instance.ref("users/${user.uid}");
//     Map<String, dynamic> answersData = controllers.asMap().map(
//           (index, controller) => MapEntry('question${index + 1}', controller.text.trim()),
//     );
//
//     try {
//       await ref.update({
//         'answers': answersData,
//         'timestamp': DateTime.now().toIso8601String(),
//       });
//       print("User responses updated successfully for user: ${user.uid}");
//     } catch (e) {
//       print("Error updating responses: $e");
//     }
//   }
//
//   void _navigateToResult() async {
//     if (allAnswered) {
//       await _saveResponses();
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => ResultLevelScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Color headingColor = Color(0xFF00598B);
//     final Color fieldBackground = Color(0xFFF7F7F8);
//
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//         setState(() => _focusedIndex = null);
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: headingColor, size: 30),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Know Your",
//                 style: TextStyle(fontSize: 22, color: headingColor),
//               ),
//               Text(
//                 "Level",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: headingColor,
//                 ),
//               ),
//               SizedBox(height: 30),
//               Expanded(
//                 child: Scrollbar(
//                   thickness: 6,
//                   radius: Radius.circular(10),
//                   thumbVisibility: true,
//                   controller: _scrollController,
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     itemCount: questions.length,
//                     itemBuilder: (context, index) {
//                       bool isFocused = _focusedIndex == index;
//
//                       return Padding(
//                         padding: EdgeInsets.only(bottom: 25),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "${index + 1}. ${questions[index]}",
//                               style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w600,
//                                 color: headingColor,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: fieldBackground,
//                                 borderRadius: BorderRadius.circular(10),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.3),
//                                     spreadRadius: 1,
//                                     blurRadius: 4,
//                                     offset: Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: TextField(
//                                 controller: controllers[index],
//                                 maxLines: isFocused ? 6 : 1,
//                                 onTap: () {
//                                   setState(() => _focusedIndex = index);
//                                 },
//                                 keyboardType: TextInputType.multiline,
//                                 decoration: InputDecoration(
//                                   hintText: "Enter answer here",
//                                   hintStyle: TextStyle(color: Color(0x4D00598B)),
//                                   contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                                   border: InputBorder.none,
//                                 ),
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: allAnswered ? _navigateToResult : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: allAnswered ? headingColor : Colors.grey,
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Text(
//                     "Next",
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }