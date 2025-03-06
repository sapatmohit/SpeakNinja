import 'package:flutter/material.dart';
import 'components/level_selection.dart';
import 'reason.dart';

class LevelSelectionScreen extends StatefulWidget {
  @override
  _LevelSelectionScreenState createState() =>
      _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final List<String> levels = [
    "1 - Beginner",
    "2 - Intermediate",
    "3 - Advanced"
  ]; // Language options

  void _handleLevelSelection(String level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReasonSelectionScreen(), // Pass name
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
                Text("On the scale of 1-3",
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
