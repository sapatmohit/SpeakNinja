import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Wave Image Background
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/wave.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),

          // Main Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row with Cross Icon, Progress Bar, and Avatar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: 0.4, // 40%
                          minHeight: 10,
                          backgroundColor: const Color(0xFFC7E8FF),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00598B)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // const CircleAvatar(
                    //   backgroundColor: Color(0xFF00598B),
                    //   child: Icon(Icons.person, color:Colors.white ),
                    // ),
                  ],
                ),

                const SizedBox(height: 40),

                const Center(
                  child: Text(
                    "Select what you hear",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: Icon(Icons.volume_up_rounded, size: 124, color: Colors.blue[700]),
                ),

                const SizedBox(height: 30),

                OptionButton(text: "Hello", onPressed: () => setState(() => selectedAnswer = "Hello")),
                const SizedBox(height: 16),
                OptionButton(text: "Hi", onPressed: () => setState(() => selectedAnswer = "Hi")),
                const SizedBox(height: 16),
                OptionButton(text: "Greetings", onPressed: () => setState(() => selectedAnswer = "Greetings")),
                const SizedBox(height: 16),
                OptionButton(text: "What's up", onPressed: () => setState(() => selectedAnswer = "What's up")),

                const SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
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
                ),
              ],
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
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600),
      ),
    );
  }
}
