import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

class CombinedLessonPage extends StatefulWidget {
  const CombinedLessonPage({super.key});

  @override
  State<CombinedLessonPage> createState() => _CombinedLessonPageState();
}

class _CombinedLessonPageState extends State<CombinedLessonPage> {
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

  void _onVolumeIconClick() {
    _showFeedback("Clicked", Colors.blueAccent.withOpacity(0.7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: LinearProgressIndicator(
              value: 0.4,
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: const Color(0xFFC7E8FF),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00598B)),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/wave.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Select the correct meaning",
                  style: TextStyle(fontSize: 25, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                // Bubble + Volume Icon Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChatBubble(
                      clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                      alignment: Alignment.topLeft,
                      backGroundColor: Colors.lightBlue[100]!,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                        child: Column(
                          children: [
                            Text(
                              "Hello",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "नमस्कार",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.volume_up_rounded, size: 90, color: Colors.blue[700]),
                      onPressed: _onVolumeIconClick,
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Answer Options
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    optionButton("Hello"),
                    optionButton("Hi"),
                    optionButton("Greetings"),
                    optionButton("Goodbye"),
                  ],
                ),

                const SizedBox(height: 40),
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
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget optionButton(String text) {
    return ElevatedButton(
      onPressed: () => setState(() => selectedAnswer = text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[100],
        fixedSize: const Size(140, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600),
      ),
    );
  }
}