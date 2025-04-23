// import 'package:flutter/material.dart';
// import 'reason.dart';
//
// class ResultLevelScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFAF7), // Background color
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
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               "Your Level is",
//               style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFFE07C32),
//               ),
//             ),
//             SizedBox(height: 20),
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color(0xFFE07C32),
//                     blurRadius: 6,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Text(
//                 "2 - Intermediate", // You can replace this dynamically
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFE07C32),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Image.asset(
//               'assets/trophy.png', // Path to the image
//               height: 500,
//               width: 500, // Adjust size as needed
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ReasonSelectionScreen(),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFFE07C32),
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 "Let's Begin",
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'reason.dart';
//
// class ResultLevelScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Color(0xFF00598B), size: 30),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.rotationX(3.1416),
//               child: Image.asset(
//                 'assets/wave2.png',
//                 fit: BoxFit.cover,
//                 height: 180,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 10),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Your Level is....",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF00598B),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           blurRadius: 10,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       "2 - Intermediate",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF00598B),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Image.asset(
//                   'assets/trophy.png',
//                   height: 320,
//                   fit: BoxFit.contain,
//                 ),
//                 SizedBox(height: 60),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ReasonSelectionScreen(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF00598B),
//                       padding: EdgeInsets.symmetric(vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: Text(
//                       "Let’s Begin",
//                       style: TextStyle(fontSize: 18, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'reason.dart';

class ResultLevelScreen extends StatelessWidget {
  final Map<String, dynamic> results;
  const ResultLevelScreen(this.results, {Key? key}) : super(key: key);

  String _levelLabel(double score) {
    if (score < 2.5) return 'Beginner';
    if (score < 4.0) return 'Intermediate';
    return 'Advanced';
  }

  @override
  Widget build(BuildContext context) {
    final double overall = (results['Overall_Score'] as num).toDouble();
    final double grammar = (results['Grammar_Score'] as num).toDouble();
    final double vocab = (results['Vocabulary_Score'] as num).toDouble();
    final double fluency = (results['Fluency_Score'] as num).toDouble();
    final int spelling = results['Spelling_Errors'] as int;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF00598B), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Level is...",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00598B),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      "${overall.toStringAsFixed(1)} - ${_levelLabel(overall)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00598B),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Detailed Scores
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _scoreRow('Grammar', grammar),
                        _scoreRow('Vocabulary', vocab),
                        _scoreRow('Fluency', fluency),
                        _scoreRow('Spelling Errors', spelling.toDouble()),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Image.asset(
                  'assets/trophy.png',
                  height: 320,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReasonSelectionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00598B),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Let’s Begin",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreRow(String label, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            value.toStringAsFixed(label=='Spelling Errors'?0:1),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
