import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ← Add this
import 'afterlogin/roadmap.dart';
import 'signup.dart';
import 'chatbot.dart';
import 'username.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey             = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Here you’d normally call FirebaseAuth.signInWithEmailAndPassword(...)
      // On success, persist login state:
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', _emailController.text.trim());

      // Navigate into the app
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RoadmapPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFAF7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xFF041B1B),
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 45),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Enter your Email",
                            filled: true,
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
                                  color: Color(0xFFf49549), width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40),

                        // Password field
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Enter your Password",
                            filled: true,
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
                                  color: Color(0xFFf49549), width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(height: 50),

                        // Login button
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFf49549),
                            padding: EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white, fontSize: 22),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Or Signup text
                        Text(
                          "Or Signup",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 30),

                        // Social buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () => print("Google Button Clicked"),
                              style: OutlinedButton.styleFrom(
                                shape: CircleBorder(),
                                side: BorderSide(
                                    color: Color(0xFFf49549), width: 2.5),
                                padding: EdgeInsets.all(20),
                              ),
                              child: Icon(
                                FontAwesomeIcons.google,
                                size: 24,
                                color: Color(0xFFf49549),
                              ),
                            ),
                            SizedBox(width: 30),
                            OutlinedButton(
                              onPressed: () => print("facebook Button Clicked"),
                              style: OutlinedButton.styleFrom(
                                shape: CircleBorder(),
                                side: BorderSide(
                                    color: Color(0xFFf49549), width: 2.5),
                                padding: EdgeInsets.all(20),
                              ),
                              child: Icon(
                                FontAwesomeIcons.facebookF,
                                size: 24,
                                color: Color(0xFFf49549),
                              ),
                            ),
                            SizedBox(width: 30),
                            OutlinedButton(
                              onPressed: () => print("email Button Clicked"),
                              style: OutlinedButton.styleFrom(
                                shape: CircleBorder(),
                                side: BorderSide(
                                    color: Color(0xFFf49549), width: 2.5),
                                padding: EdgeInsets.all(20),
                              ),
                              child: Icon(
                                FontAwesomeIcons.envelope,
                                size: 24,
                                color: Color(0xFFf49549),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),

                        // Navigate to Sign Up
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Color(0xFFf49549), width: 2.5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Color(0xFFf49549),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'afterlogin/roadmap.dart';
// import 'signup.dart';
// import 'chatbot.dart';
// import 'username.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => RoadmapPage()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Color(0xFF041B1B),
//       backgroundColor: Color(0xFFFFFAF7), // color for background
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 // Aligns to the top
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 // Centers horizontally
//                 children: [
//                   Text(
//                     "Login",
//                     style: TextStyle(
//                       // color: Color(0xFFefefef),
//                       color: Color(0xFF041B1B),
//                       fontSize: 45,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 45),
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Email",
//                             style: TextStyle(
//                                 color: Color(0xFF000000),
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         TextFormField(
//                           cursorColor: Colors.white,
//                           controller: _emailController,
//                           style: TextStyle(
//                             color: Colors.black,
//                           ),
//                           decoration: InputDecoration(
//                             hintText: "Enter your Email",
//                             filled: true,
//                             // fillColor: Color(0xFFf49549),
//                             fillColor: Colors.white,
//                             hintStyle: TextStyle(color: Colors.black),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                   color: Color(0xFFf49549), width: 2),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFf49549),
//                                 // Ensure focused color matches
//                                 width: 2,
//                               ),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter your email";
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 40),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Password",
//                             style: TextStyle(
//                                 color: Color(0xFF000000),
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         TextFormField(
//                           cursorColor: Colors.white,
//                           controller: _passwordController,
//                           obscureText: true,
//                           style: TextStyle(color: Colors.black),
//                           decoration: InputDecoration(
//                             hintText: "Enter your Password",
//                             filled: true,
//                             // fillColor: Color(0xFFf49549),
//                             fillColor: Colors.white,
//                             hintStyle: TextStyle(color: Colors.black),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                   color: Color(0xFFf49549), width: 2),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide(
//                                 color: Color(0xFFf49549),
//                                 // Ensure focused color matches
//                                 width: 2,
//                               ),
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 16),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter your password";
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: 30),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: Text(
//                             "Forgot Password?",
//                             style: TextStyle(
//                                 color: Color(0xFF000000),
//                                 fontSize: 16,
//                                 decoration: TextDecoration.underline,
//                                 decorationColor: Color(0xFF000000)),
//                           ),
//                         ),
//                         SizedBox(height: 50),
//                         ElevatedButton(
//                           onPressed: _login,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFFf49549),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 60, vertical: 15),
//                             textStyle: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                           ),
//                           child: Text(
//                             "LOGIN",
//                             style: TextStyle(color: Colors.white, fontSize: 22),
//                           ),
//                         ),
//                         SizedBox(height: 30),
//                         Text("Or Signup",
//                             style: TextStyle(
//                               color: Colors.black45,
//                               fontSize: 20,
//                             )),
//                         SizedBox(height: 30),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             OutlinedButton(
//                               onPressed: () {
//                                 print("Google Button Clicked");
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 shape: CircleBorder(),
//                                 side: BorderSide(
//                                     color: Color(0xFFf49549), width: 2.5),
//                                 padding: EdgeInsets.all(20),
//                               ),
//                               child: Icon(
//                                 FontAwesomeIcons.google,
//                                 size: 24,
//                                 color: Color(0xFFf49549),
//                               ),
//                             ),
//                             SizedBox(width: 30),
//                             OutlinedButton(
//                               onPressed: () {
//                                 print("facebook Button Clicked");
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 shape: CircleBorder(),
//                                 side: BorderSide(
//                                     color: Color(0xFFf49549), width: 2.5),
//                                 padding: EdgeInsets.all(20),
//                               ),
//                               child: Icon(
//                                 FontAwesomeIcons.facebookF,
//                                 size: 24,
//                                 color: Color(0xFFf49549),
//                               ),
//                             ),
//                             SizedBox(width: 30),
//                             OutlinedButton(
//                               onPressed: () {
//                                 print("email Button Clicked");
//                               },
//                               style: OutlinedButton.styleFrom(
//                                 shape: CircleBorder(),
//                                 side: BorderSide(
//                                     color: Color(0xFFf49549), width: 2.5),
//                                 padding: EdgeInsets.all(20),
//                               ),
//                               child: Icon(
//                                 FontAwesomeIcons.envelope,
//                                 size: 24,
//                                 color: Color(0xFFf49549),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 30),
//                         OutlinedButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => SignupScreen(),
//                                 ),
//                               );
//                             },
//                             style: OutlinedButton.styleFrom(
//                               side: BorderSide(color: Color(0xFFf49549), width: 2.5),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 30, vertical: 15),
//                             ),
//                             child: Text(
//                               "SIGN UP",
//                               style:
//                                   TextStyle(color: Color(0xFFf49549), fontSize: 15),
//                             )),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
