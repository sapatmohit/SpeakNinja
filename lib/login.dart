import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'username.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UsernameScreen()),
        );
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        } else {
          message = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextFormField(
                          cursorColor: Color(0xFFf49549),
                          controller: _emailController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Enter your Email",
                            filled: true,
                            // fillColor: Color(0xFFf49549),
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFf49549), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFf49549), width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextFormField(
                          cursorColor: Color(0xFFf49549),
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Enter your Password",
                            filled: true,
                            // fillColor: Color(0xFFf49549),
                            fillColor: Colors.white,
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFf49549), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFf49549), width: 2),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF000000)),
                          ),
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFf49549),
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Or Signup",
                          style: TextStyle(color: Colors.black45, fontSize: 20),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                print("Google Button Clicked");
                              },
                              style: OutlinedButton.styleFrom(
                                shape: CircleBorder(),
                                side: BorderSide(color: Color(0xFFf49549), width: 2.5),
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
                              onPressed: () {
                                print("Facebook Button Clicked");
                              },
                              style: OutlinedButton.styleFrom(
                                shape: CircleBorder(),
                                side: BorderSide(color: Color(0xFFf49549), width: 2.5),
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
                              onPressed: () {
                                print("Email Button Clicked");
                              },
                              style: OutlinedButton.styleFrom(
                                shape: CircleBorder(),
                                side: BorderSide(color: Color(0xFFf49549), width: 2.5),
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
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xFFf49549), width: 2.5),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(color: Color(0xFFf49549), fontSize: 15),
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
