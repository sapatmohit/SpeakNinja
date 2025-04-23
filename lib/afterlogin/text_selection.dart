import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import '../mistral_service.dart';

class TextSelectionLesson extends StatefulWidget {
  final int lessonNumber;
  const TextSelectionLesson({super.key, this.lessonNumber = 1});

  @override
  State<TextSelectionLesson> createState() => _TextSelectionLessonState();
}

class _TextSelectionLessonState extends State<TextSelectionLesson>
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
      final isEnglishToHindi = questionCount % 2 == 0;
      final prompt = isEnglishToHindi
          ? "Generate an English-to-Hindi translation question. "
              "Respond with a JSON object containing exactly these keys: "
              "target_word (an English word), "
              "options (an array of 4 Hindi words), "
              "correct_answer (the correct Hindi translation). "
          : "Generate a Hindi-to-English translation question. "
              "Respond with a JSON object containing exactly these keys: "
              "target_word (a Hindi word), "
              "options (an array of 4 English words), "
              "correct_answer (the correct English translation). "
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
            'Unable to generate a unique lesson for Lesson ${widget.lessonNumber}, Question ${questionCount + 1} after $maxAttempts attempts');
      }

      setState(() {
        if (data != null) {
          levelData = LevelData.fromJson(data);
        } else {
          throw Exception('Failed to fetch level data');
        }
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
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth)),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(height: 50),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "Error: $errorMessage",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: fetchLevelData,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  )
                else
                  Column(children: [
                    Text(
                        "Lesson ${widget.lessonNumber}, Question ${questionCount + 1}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54)),
                    const SizedBox(height: 30),
                    ChatBubble(
                        clipper:
                            ChatBubbleClipper1(type: BubbleType.receiverBubble),
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.only(top: 10),
                        backGroundColor: Colors.lightBlue[100]!,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Text(levelData!.targetWord,
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1))),
                    const SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(child: optionButton(levelData!.options[0])),
                          Flexible(child: optionButton(levelData!.options[1]))
                        ]),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(child: optionButton(levelData!.options[2])),
                          Flexible(child: optionButton(levelData!.options[3]))
                        ]),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: selectedAnswer == null
                          ? null
                          : () {
                              final isCorrect =
                                  selectedAnswer == levelData!.correctAnswer;
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
                              horizontal: 50, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text("Submit",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                    if (showNext) ...[
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _handleNextQuestion,
                        icon: const Icon(Icons.arrow_forward),
                        label:
                            const Text("Next", style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                      ),
                    ]
                  ]),
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
      onPressed: selectedAnswer != null && !showNext
          ? null
          : () => setState(() => selectedAnswer = text),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue[300] : Colors.blue[100],
        minimumSize: const Size(150, 60),
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          side: isSelected
              ? const BorderSide(color: Colors.blue, width: 2)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: SizedBox(
        width: 140,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: 'NotoSansDevanagari',
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class LevelData {
  final String targetWord;
  final List<String> options;
  final String correctAnswer;

  LevelData(
      {required this.targetWord,
      required this.options,
      required this.correctAnswer});

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
