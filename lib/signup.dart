import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login.dart'; // Assuming this is your login screen
import 'login.dart';
import 'username.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Asynchronous signup function with Firebase Authentication and Realtime Database update
  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new user with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Get the newly created user
        User? user = userCredential.user;
        if (user != null) {
          // Update the user's display name with the provided name
          await user.updateProfile(displayName: _nameController.text);
          await user.reload(); // Ensure the local user object is updated

          // Write the user's data to the Realtime Database under a node with the user's UID
          DatabaseReference userRef =
          FirebaseDatabase.instance.ref("users/${user.uid}");
          await userRef.set({
            'name': _nameController.text,
            'email': _emailController.text,
            // Additional user data can be added here as needed.
          });
        }

        // Navigate to the temporary profile screen after successful sign-up
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Handle specific Firebase Authentication errors
        String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'An account already exists for that email.';
        } else {
          message = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        // Handle any other unexpected errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UsernameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAF7),
      appBar: AppBar(
        title: Text("Sign Up", style: TextStyle(color: Color(0xFFf49549))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFf49549)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00598B),
                ),
              ),
              Text("Create an Account",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFf49549))),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  filled: true,
                  // fillColor: Color(0xFFf49549),
                  fillColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? "Please enter your name" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  // fillColor: Color(0xFFf49549),
                  fillColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Color(0xFFf49549), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xFFf49549),
                      // Ensure focused color matches
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
                validator: (value) =>
                value!.contains('@') ? null : "Enter a valid email",
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  // fillColor: Color(0xFFf49549),
                  fillColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Color(0xFFf49549), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xFFf49549),
                      // Ensure focused color matches
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                ),
                validator: (value) => value!.length >= 6
                    ? null
                    : "Password must be at least 6 characters",
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFf49549),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Or",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFf49549), width: 2.5),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(color: Color(0xFFf49549), fontSize: 20),
                    )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black, width: 2.5),
                    padding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class TempProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Get the current authenticated user
//     User? user = FirebaseAuth.instance.currentUser;
//     // Use the display name from Firebase, default to "User" if null
//     String displayName = user?.displayName ?? 'User';
//     return Scaffold(
//       body: Center(
//         child: Text("Welcome, $displayName!"),
//       ),
//     );
//   }
// }
