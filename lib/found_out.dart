import 'package:flutter/material.dart';
import 'components/level_selection.dart';
import 'level.dart';
import 'interest.dart';
import 'components/found_out_selection.dart';

class FoundSelectionScreen extends StatefulWidget {
  @override
  _FoundSelectionScreenState createState() =>
      _FoundSelectionScreenState();
}

class _FoundSelectionScreenState extends State<FoundSelectionScreen> {
  final List<String> list = [
    "Family and friends",
    "Facebook/Instagram",
    "Google search",
    "YouTube",
    "Linkedin",
    "Another resources"
  ]; // Language options

  void _handleFoundSelection(String level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InterestSelectionPage(), // Pass name
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
                Text("How did you find out",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE07C32))),
                Text("about Speakninja ?",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE07C32))),
              ],
            ),
          ),
          SizedBox(height: 50),
          FoundSelection(
              list: list,
              onFoundSelected: _handleFoundSelection),
          SizedBox(height: 25),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LevelSelectionScreen(),
                  ),
                );
              },
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
