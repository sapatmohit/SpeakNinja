import 'package:flutter/material.dart';
import 'login.dart'; // Import your login screen file
import 'profile_screen.dart';
import 'components/age_selection.dart'; // Import the AgeSelection widget

class UsernameScreen extends StatefulWidget {
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _goToNextScreen() {
    if (_nameController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgeSelectionScreen(name: _nameController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your name")),
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
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 200),
            Text("So nice to meet you.",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFE07C32))),
            Text("What's your name?",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE07C32))),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "Enter your name",
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFf49549), width: 3)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFf49549), width: 3)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                onPressed: _goToNextScreen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFf49549),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text("Next",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  ]; // Age ranges

  void _handleAgeSelection(String age) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePictureScreen(), // Pass name
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
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UsernameScreen()),
          ), // Fixed back navigation
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
                Text("Hi ${widget.name}!",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE07C32))),
                Text("How old are you?",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE07C32))),
              ],
            ),
          ),
          SizedBox(height: 40),
          AgeSelection(ages: ages, onAgeSelected: _handleAgeSelection),
        ],
      ),
    );
  }
}
