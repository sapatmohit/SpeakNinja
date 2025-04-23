import 'package:flutter/material.dart';
import '../mistral_service.dart';

class AudioRecognitionLesson extends StatefulWidget {
  final int lessonNumber;
  const AudioRecognitionLesson({super.key, this.lessonNumber = 1});

  @override
  State<AudioRecognitionLesson> createState() => _AudioRecognitionLessonState();
}

class LevelData {
  final String targetWord;
  final List<String> options;
  final String correctAnswer;

  LevelData({
    required this.targetWord,
    required this.options,
    required this.correctAnswer,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('target_word') ||
        !json.containsKey('options') ||
        !json.containsKey('correct_answer')) {
      throw Exception('Invalid level data: missing required fields');
    }
    if (json['options'] is! List || (json['options'] as List).length != 4) {
      throw Exception(
          'Invalid level data: options must be an array of 4 items');
    }
    return LevelData(
      targetWord: json['target_word'] as String,
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'] as String,
    );
  }
}

class _AudioRecognitionLessonState extends State<AudioRecognitionLesson>
    with SingleTickerProviderStateMixin {
  LevelData? levelData;
  String? selectedAnswer;
  double progressValue = 0.4;
  bool showNext = false;
  bool isLoading = true;
  String? errorMessage;
  int questionCount = 0;
  final Set<String> _usedTargetWords = {};
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _progressAnimation = Tween<double>(begin: 0.4, end: 0.6).animate(
        CurvedAnimation(parent: _progressController, curve: Curves.easeInOut))
      ..addListener(
          () => setState(() => progressValue = _progressAnimation.value));
    fetchLevelData();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Future<void> fetchLevelData() async {
    setState(() => isLoading = true);
    try {
      final mistralService = MistralService();
      final isHindiToEnglish = questionCount % 2 == 0;
      final prompt = isHindiToEnglish
          ? "Generate a Hindi listening comprehension question. Respond with a JSON object containing: "
              "target_word (a Hindi word in Devanagari script), "
              "options (4 English translations), "
              "correct_answer (correct English translation). "
              "Avoid these words: ${_usedTargetWords.join(', ')}. "
              "Lesson ${widget.lessonNumber}, Question ${questionCount + 1}"
          : "Generate an English listening comprehension question. Respond with a JSON object containing: "
              "target_word (an English word), "
              "options (4 Hindi translations in Devanagari), "
              "correct_answer (correct Hindi translation). "
              "Avoid these words: ${_usedTargetWords.join(', ')}. "
              "Lesson ${widget.lessonNumber}, Question ${questionCount + 1}";

      Map<String, dynamic>? data;
      int attempt = 0;
      const maxAttempts = 3;

      do {
        data = await mistralService.fetchLevelData(prompt);
        attempt++;
      } while (attempt < maxAttempts &&
          (_usedTargetWords.contains(data['target_word'])));

      if (_usedTargetWords.contains(data['target_word'])) {
        throw Exception(
            'Unable to generate unique question after $maxAttempts attempts');
      }

      setState(() {
        levelData = LevelData.fromJson(data!);
        _usedTargetWords.add(levelData!.targetWord);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _showFeedback(String message, Color color, bool correct) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
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

  void _handleNextQuestion() {
    if (questionCount >= 4) {
      Navigator.pop(context);
    } else {
      setState(() {
        questionCount++;
        selectedAnswer = null;
        showNext = false;
        isLoading = true;
        progressValue = 0.4;
      });
      _progressController.reset();
      fetchLevelData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/wave.png',
                width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                                value: progressValue,
                                minHeight: 10,
                                backgroundColor: const Color(0xFFC7E8FF),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF00598B))))),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 40),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text("Error: $errorMessage",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: fetchLevelData,
                            child: const Text("Retry")),
                      ],
                    ),
                  )
                else
                  Column(
                    children: [
                      Center(
                        child: Text(
                            "Lesson ${widget.lessonNumber}, Question ${questionCount + 1}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54)),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Icon(Icons.volume_up_rounded,
                            size: 124, color: Colors.blue[700]),
                      ),
                      const SizedBox(height: 30),
                      ...levelData!.options.map((option) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: OptionButton(
                              text: option,
                              onPressed: () =>
                                  setState(() => selectedAnswer = option),
                              isSelected: selectedAnswer == option,
                            ),
                          )),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: selectedAnswer == null
                              ? null
                              : () {
                                  final isCorrect = selectedAnswer ==
                                      levelData!.correctAnswer;
                                  _showFeedback(
                                      isCorrect
                                          ? "Correct! Well done."
                                          : "Oops! Try again.",
                                      isCorrect
                                          ? Colors.green.withOpacity(0.7)
                                          : Colors.red.withOpacity(0.7),
                                      isCorrect);
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text("Submit",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                      if (showNext) ...[
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _handleNextQuestion,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text("Next",
                              style: TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ]
                    ],
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
  final bool isSelected;

  const OptionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[300] : Colors.blue[100],
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? const BorderSide(color: Colors.blue, width: 2)
              : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          fontFamily: text.contains(String.fromCharCode(0x0900))
              ? 'NotoSansDevanagari'
              : null,
        ),
      ),
    );
  }
}
