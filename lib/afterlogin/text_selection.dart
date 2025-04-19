import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

class TextSelectionLesson extends StatefulWidget {
  const TextSelectionLesson({super.key});

  @override
  State<TextSelectionLesson> createState() => _TextSelectionLessonState();
}

class _TextSelectionLessonState extends State<TextSelectionLesson> with SingleTickerProviderStateMixin {
  String? selectedAnswer;
  final correctAnswer = "Hello";
  double progressValue = 0.4;
  bool showNext = false;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _progressAnimation = Tween<double>(begin: 0.4, end: 0.6).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ))..addListener(() {
      setState(() => progressValue = _progressAnimation.value);
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _showFeedback(String message, Color color, bool correct) {
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

    if (correct) {
      _progressController.forward();
      setState(() => showNext = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/wave.png', // Update this path to your image
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ),

          // Main content wrapped in SingleChildScrollView to avoid overflow
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top bar with close icon, progress bar, and profile
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
                          value: progressValue,
                          minHeight: 10,
                          backgroundColor: const Color(0xFFC7E8FF),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00598B)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // const CircleAvatar(
                    //   backgroundColor: Colors.white,
                    //   child: Icon(Icons.person, color: Color(0xFF00598B)),
                    // ),
                  ],
                ),

                const SizedBox(height: 50),

                // "Select the correct meaning" text above the chat bubble
                const Text(
                  "Select the correct meaning",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black54),
                ),

                const SizedBox(height: 30),

                // ChatBubble widget
                ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 10),
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

                const SizedBox(height: 30),

                // Row 1 for answer options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    optionButton("Hello"),
                    optionButton("Hi"),
                  ],
                ),
                const SizedBox(height: 20),
                // Row 2 for answer options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    optionButton("Greetings"),
                    optionButton("Goodbye"),
                  ],
                ),

                const SizedBox(height: 40),

                // Submit button
                ElevatedButton(
                  onPressed: selectedAnswer == null
                      ? null
                      : () {
                    final isCorrect = selectedAnswer == correctAnswer;
                    _showFeedback(
                      isCorrect ? "Correct! Well done." : "Oops! Try again.",
                      isCorrect ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7),
                      isCorrect,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Submit", style: TextStyle(fontSize: 20, color: Colors.white)),
                ),

                if (showNext) ...[
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to next screen or show next word
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget optionButton(String text) {
    final isSelected = selectedAnswer == text;
    return ElevatedButton(
      onPressed: () => setState(() => selectedAnswer = text),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[300] : Colors.blue[100],
        fixedSize: const Size(150, 60),
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          side: isSelected ? const BorderSide(color: Colors.blue, width: 2) : BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),
      ),
    );
  }
}

