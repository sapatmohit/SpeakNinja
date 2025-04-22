// import 'package:chatbot_final/username.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:shared_preferences/shared_preferences.dart';   // ← Add this
// import 'login.dart'; // Import your login screen file
//
// // This screen performs sign up, pushes data to the Realtime Database and then navigates to a temporary profile screen.
// class SignupScreen extends StatefulWidget {
//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController     = TextEditingController();
//   final TextEditingController _emailController    = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   // Asynchronous signup function
//   Future<void> _signup() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Create a new user with email and password
//         UserCredential userCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//
//         // Get the newly created user
//         User? user = userCredential.user;
//         if (user != null) {
//           // Update the user's display name
//           await user.updateDisplayName(_nameController.text.trim());
//
//           // Write the user's basic data to the Realtime Database under /users/<uid>
//           DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
//           await userRef.set({
//             'name':  _nameController.text.trim(),
//             'email': _emailController.text.trim(),
//             // You can add additional fields as needed here.
//           });
//
//           // --- NEW: Save login state & username to SharedPreferences ---
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setBool('isLoggedIn', true);
//           await prefs.setString('username', _nameController.text.trim());
//           // -------------------------------------------------------------
//
//           // Navigate to a temporary profile screen
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => UsernameScreen(),
//             ),
//           );
//         }
//       } on FirebaseAuthException catch (e) {
//         String message = '';
//         if (e.code == 'weak-password') {
//           message = 'The password provided is too weak.';
//         } else if (e.code == 'email-already-in-use') {
//           message = 'An account already exists for that email.';
//         } else {
//           message = 'An error occurred. Please try again.';
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message)),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('An error occurred. Please try again.')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFAF7),
//       appBar: AppBar(
//         title: Text("Sign Up", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("Create an Account",
//                   style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF00598B))),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   hintText: "Full Name",
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 validator: (value) =>
//                 value!.isEmpty ? "Please enter your name" : null,
//               ),
//               SizedBox(height: 15),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   hintText: "Email",
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 validator: (value) =>
//                 value!.contains('@') ? null : "Enter a valid email",
//               ),
//               SizedBox(height: 15),
//               TextFormField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 validator: (value) => value!.length >= 6
//                     ? null
//                     : "Password must be at least 6 characters",
//               ),
//               SizedBox(height: 30),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _signup,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                   child: Text("Sign Up",
//                       style: TextStyle(color: Colors.white, fontSize: 18)),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Text(
//                   "Or",
//                   style: TextStyle(fontSize: 20, color: Colors.grey),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Center(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => LoginScreen(),
//                         ),
//                       );
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: Colors.black, width: 2.5),
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     ),
//                     child: Text(
//                       "Login",
//                       style: TextStyle(color: Colors.black, fontSize: 20),
//                     ),
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          await user.updateDisplayName(_nameController.text.trim());

          DatabaseReference userRef = FirebaseDatabase.instance.ref("users/${user.uid}");
          await userRef.set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
          });

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('username', _nameController.text.trim());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UsernameScreen(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = '';
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00598B),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "SpeakNinja",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00598B),
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildTextField(
                      controller: _nameController,
                      label: "Enter your Name",
                      hint: "Type your Name",
                      validator: (value) =>
                      value!.isEmpty ? "Please enter your name" : null,
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                      controller: _emailController,
                      label: "Enter your Email",
                      hint: "Type your Email",
                      validator: (value) =>
                      value!.contains('@') ? null : "Enter a valid email",
                    ),
                    SizedBox(height: 15),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Enter a Password",
                      hint: "Type a password",
                      obscure: true,
                      validator: (value) => value!.length >= 6
                          ? null
                          : "Password must be at least 6 characters",
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00598B),
                        padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(height: 30),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side:
                        BorderSide(color: Color(0xFF00598B), width: 2.5),
                        padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Color(0xFF00598B),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00598B),
          ),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Color(0xFF00598B), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}