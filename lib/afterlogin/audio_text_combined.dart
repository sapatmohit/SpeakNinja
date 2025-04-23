import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import FlutterTts
import '../services/mistral_service.dart';
import '../models/level_data.dart';

class CombinedLessonPage extends StatefulWidget {
  final int lessonNumber;
  const CombinedLessonPage({super.key, this.lessonNumber = 1});

  @override
  State<CombinedLessonPage> createState() => _CombinedLessonPageState();
}

class _CombinedLessonPageState extends State<CombinedLessonPage>
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
  final FlutterTts _flutterTts = FlutterTts(); // Add FlutterTts instance

  @override
  void initState() {
    super.initState();
    _progressController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _progressAnimation = Tween<double>(begin: 0.4, end: 0.6).animate(
        CurvedAnimation(parent: _progressController, curve: Curves.easeInOut))
      ..addListener(
          () => setState(() => progressValue = _progressAnimation.value));
    _fetchLessonData();
  }

  @override
  void dispose() {
    _flutterTts.stop(); // Stop TTS when disposing
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _fetchLessonData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final mistralService = MistralService();

      // Combined audio + text prompt
      final prompt = """
    Generate a combined audio recognition and text translation exercise with these specifications:

    For Lesson ${widget.lessonNumber}, Question ${questionCount + 1}:

    1. TARGET WORD:
       - English word (3-12 letters)
       - Common vocabulary appropriate for language learners
       - Avoid these used words: ${_usedTargetWords.join(', ')}

    2. TRANSLATION:
       - Accurate Hindi translation in Devanagari script
       - Should match the difficulty level of the English word

    3. MULTIPLE CHOICE OPTIONS (for audio recognition):
       - 4 English words including the correct answer
       - All same part of speech
       - Similar length/difficulty
       - Phonetically distinct for clear audio recognition
       - Example: ["hello", "yellow", "fellow", "jello"]

    4. FORMAT REQUIREMENTS:
       - Return as JSON with these exact keys:
         {
           "target_word": "example",
           "hindi_translation": "उदाहरण",
           "options": ["sample", "instance", "example", "model"],
           "correct_answer": "example",
           "phonetic_hint": "ehg-ZAM-pul"  // IPA or simple phonetic spelling
         }

    5. AUDIO CONSIDERATIONS:
       - Words should be easily distinguishable when spoken
       - Avoid homophones or near-homophones
       - Include phonetic_hint for pronunciation guidance

    Current difficulty level: ${_getDifficultyLevel(widget.lessonNumber)}
    """;

      final data = await mistralService.fetchLessonData(prompt);

      // Validate response structure
      if (!_validateResponse(data)) {
        throw Exception('Invalid data format from AI');
      }

      // Check for duplicate words
      if (_usedTargetWords.contains(data['target_word'])) {
        throw Exception('Duplicate word generated: ${data['target_word']}');
      }

      setState(() {
        levelData = LevelData.fromJson(data);
        _usedTargetWords.add(levelData!.targetWord);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
      _showFeedback(errorMessage!, Colors.red);
    }
  }

  bool _validateResponse(Map<String, dynamic> data) {
    final requiredKeys = [
      'target_word',
      'hindi_translation',
      'options',
      'correct_answer',
      'phonetic_hint'
    ];

    if (!requiredKeys.every((key) => data.containsKey(key))) {
      return false;
    }

    if (data['options'] is! List || data['options'].length != 4) {
      return false;
    }

    if (!data['options'].contains(data['correct_answer'])) {
      return false;
    }

    return true;
  }

  String _getDifficultyLevel(int lessonNumber) {
    if (lessonNumber <= 3)
      return 'Beginner (simple words, clear pronunciation)';
    if (lessonNumber <= 6) return 'Intermediate (common phrases)';
    return 'Advanced (complex vocabulary)';
  }

  void _showFeedback(String message, Color color, [int duration = 3]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: duration),
      ),
    );
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
      _fetchLessonData();
    }
  }

  Future<void> _playAudio(String text) async {
    try {
      await _flutterTts.setLanguage("en-US"); // Set language
      await _flutterTts.setPitch(1.0); // Set pitch
      await _flutterTts.speak(text); // Speak the text
    } catch (e) {
      _showFeedback("Failed to play audio", Colors.red);
    }
  }

  void _onVolumeIconClick() {
    if (levelData != null) {
      _playAudio(levelData!.targetWord); // Play the target word audio
    }
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
              value: progressValue,
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
                Text(
                  "Lesson ${widget.lessonNumber}, Question ${questionCount + 1}",
                  style: const TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Select the correct English word",
                  style: TextStyle(fontSize: 25, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text("Error: $errorMessage",
                            style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: _fetchLessonData,
                            child: const Text("Retry")),
                      ],
                    ),
                  )
                else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChatBubble(
                        clipper:
                            ChatBubbleClipper1(type: BubbleType.receiverBubble),
                        alignment: Alignment.topLeft,
                        backGroundColor: Colors.lightBlue[100]!,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: Column(
                            children: [
                              Text(
                                levelData!.hindiTranslation,
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
                        icon: Icon(Icons.volume_up_rounded,
                            size: 90, color: Colors.blue[700]),
                        onPressed:
                            _onVolumeIconClick, // Updated to use _onVolumeIconClick
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: levelData!.options
                        .map((option) => optionButton(option))
                        .toList(),
                  ),
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
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Submit",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  if (showNext) ...[
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _handleNextQuestion,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Next"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ]
                ],
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
        backgroundColor:
            selectedAnswer == text ? Colors.blue[300] : Colors.blue[100],
        fixedSize: const Size(140, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: selectedAnswer == text
              ? const BorderSide(color: Colors.blue, width: 2)
              : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600),
      ),
    );
  }
}
