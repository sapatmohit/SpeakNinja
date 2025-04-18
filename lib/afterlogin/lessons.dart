import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

class TextSelectionLesson extends StatefulWidget {
  const TextSelectionLesson({super.key});

  @override
  State<TextSelectionLesson> createState() => _TextSelectionLessonState();
}

class _TextSelectionLessonState extends State<TextSelectionLesson> {
  String? selectedAnswer;
  final correctAnswer = "Hello";

  void _showFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Lesson"),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue[800]),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(color: Colors.blue[100]),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Chat bubble centered
                      Center(
                        child: ChatBubble(
                          clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                          alignment: Alignment.topCenter, // Align bubble in the center
                          margin: const EdgeInsets.only(top: 20),
                          backGroundColor: Colors.lightBlue[100]!,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                            child: Column(
                              children: [
                                Text(
                                  "Hello",
                                  style: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize: 36, // Increased font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "नमस्कार",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 23, // Increased font size for the English translation
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("Select the correct meaning", style: TextStyle(fontSize: 18, color: Colors.black54)),
                      const SizedBox(height: 30),
                      OptionButton(text: "Hello", onPressed: () => setState(() => selectedAnswer = "Hello")),
                      const SizedBox(height: 16),
                      OptionButton(text: "Hi", onPressed: () => setState(() => selectedAnswer = "Hi")),
                      const SizedBox(height: 16),
                      OptionButton(text: "Greetings", onPressed: () => setState(() => selectedAnswer = "Greetings")),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: selectedAnswer == null
                            ? null
                            : () {
                          _showFeedback(
                            selectedAnswer == correctAnswer
                                ? "Correct! Well done."
                                : "Oops! Try again.",
                            selectedAnswer == correctAnswer
                                ? Colors.green.withOpacity(0.7)
                                : Colors.red.withOpacity(0.7),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OptionButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[100],
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600)),
    );
  }
}
class AudioRecognitionLesson extends StatefulWidget {
  const AudioRecognitionLesson({super.key});

  @override
  State<AudioRecognitionLesson> createState() => _AudioRecognitionLessonState();
}

class _AudioRecognitionLessonState extends State<AudioRecognitionLesson> {
  String? selectedAnswer;
  final correctAnswer = "Hello";

  void _showFeedback(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Lesson"),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue[800]),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(color: Colors.blue[100]),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Select what you hear", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      Icon(Icons.volume_up_rounded, size: 124, color: Colors.blue[700]),
                      const SizedBox(height: 30),
                      OptionButton(text: "Hello", onPressed: () => setState(() => selectedAnswer = "Hello")),
                      const SizedBox(height: 16),
                      OptionButton(text: "Hi", onPressed: () => setState(() => selectedAnswer = "Hi")),
                      const SizedBox(height: 16),
                      OptionButton(text: "Greetings", onPressed: () => setState(() => selectedAnswer = "Greetings")),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: selectedAnswer == null
                            ? null
                            : () {
                          _showFeedback(
                            selectedAnswer == correctAnswer
                                ? "Correct! Well done."
                                : "Oops! Try again.",
                            selectedAnswer == correctAnswer
                                ? Colors.green.withOpacity(0.7)
                                : Colors.red.withOpacity(0.7),
                          );

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width * 3 / 4, size.height * 0.7, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
