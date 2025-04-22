import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'age_selection_screen.dart';
import 'login.dart';
import 'profile_screen.dart';
import 'components/age_selection.dart';

class UsernameScreen extends StatefulWidget {
  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _goToNextScreen() async {
    if (_nameController.text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DatabaseReference userRef =
        FirebaseDatabase.instance.ref("users/${user.uid}");
        await userRef.update({
          'name': _nameController.text,
        }).catchError((error) {
          print("Error updating name: $error");
        });
      }

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/wave2.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform.rotate(
              angle: 3.1416,
              child: Image.asset(
                'assets/wave2.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xFF00598B), size: 28),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                SizedBox(height: 200),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "So nice to meet you.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "What's your name ?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00598B),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _nameController,
                  cursorColor: Color(0xFF00598B),
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: "Enter your name (In English)",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xFF00598B), width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Color(0xFF00598B), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _goToNextScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00598B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1,
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