// ui/lessons/sentence_builder_lesson.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../services/mistral_service.dart';
import '../../models/level_data.dart';

class SentenceBuilderLessonPage extends StatefulWidget {
  final int lessonNumber;
  const SentenceBuilderLessonPage({super.key, this.lessonNumber = 1});

  @override
  State<SentenceBuilderLessonPage> createState() =>
      _SentenceBuilderLessonPageState();
}

class _SentenceBuilderLessonPageState extends State<SentenceBuilderLessonPage> {
  final MistralService _service = MistralService();
  final FlutterTts _tts = FlutterTts();
  List<String> selectedWords = [];
  LevelData _levelData = LevelData();
  bool _isLoading = true;
  String? _error;
  double _progress = 0.4;
  final int _attemptCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLesson();
    _tts.setCompletionHandler(() => _tts.stop());
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _loadLesson() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.fetchLessonData('''
        Generate a $_difficultyLevel English sentence-building exercise with:
        - Correct sentence: 4-6 words, $_tenseType
        - 8-10 word options including distractors
        - Phonetically distinct words
        - Lesson ${widget.lessonNumber}
      ''');

      _validateLessonData(data);

      setState(() {
        _levelData = LevelData.fromJson(data);
        _levelData.wordOptions.shuffle();
        _isLoading = false;
        _progress += 0.2;
      });
    } catch (e) {
      setState(() => _error = 'Failed to load: ${e.toString()}');
    }
  }

  void _validateLessonData(Map<String, dynamic> data) {
    final correct = List<String>.from(data['correct_sentence']);
    final options = List<String>.from(data['word_options']);

    if (correct.any((word) => !options.contains(word))) {
      throw Exception('Missing correct words in options');
    }

    if (options.toSet().length != options.length) {
      throw Exception('Duplicate words in options');
    }
  }

  String get _difficultyLevel =>
      widget.lessonNumber > 3 ? 'intermediate' : 'beginner';
  String get _tenseType =>
      widget.lessonNumber > 2 ? 'past/present tense' : 'present tense';

  void _handleWordTap(String word) {
    setState(() => selectedWords.contains(word)
        ? selectedWords.remove(word)
        : selectedWords.add(word));
  }

  void _validateAnswer() {
    final correct =
        _levelData.correctSentence.join(' ') == selectedWords.join(' ');
    _showResult(correct);
    if (correct) _progress += 0.2;
  }

  void _showResult(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? 'Perfect! 🎉' : 'Try again! 💪'),
        backgroundColor: isCorrect ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _playSentence() async {
    try {
      await _tts.speak(_levelData.correctSentence.join(' '));
    } catch (e) {
      _showResult(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LinearProgressIndicator(
          value: _progress.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation(Colors.blue),
        ),
        actions: [
          IconButton(onPressed: _loadLesson, icon: const Icon(Icons.refresh))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorWidget(error: _error!, onRetry: _loadLesson)
              : Column(
                  children: [
                    _PronunciationHeader(onTap: _playSentence),
                    _SentenceBuilderArea(
                      selectedWords: selectedWords,
                      onWordTap: _handleWordTap,
                    ),
                    _WordOptionsGrid(
                      options: _levelData.wordOptions,
                      selected: selectedWords,
                      onTap: _handleWordTap,
                    ),
                    _ValidationButton(
                      isActive: selectedWords.isNotEmpty,
                      onPressed: _validateAnswer,
                    ),
                  ],
                ),
    );
  }
}

class _PronunciationHeader extends StatelessWidget {
  final VoidCallback onTap;
  const _PronunciationHeader({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child:
              const Icon(Icons.volume_up, size: 50, color: Colors.blueAccent),
        ),
      ),
    );
  }
}

class _SentenceBuilderArea extends StatelessWidget {
  final List<String> selectedWords;
  final Function(String) onWordTap;

  const _SentenceBuilderArea({
    required this.selectedWords,
    required this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
      backGroundColor: Colors.blue[100]!,
      child: Container(
        constraints: const BoxConstraints(minHeight: 100),
        padding: const EdgeInsets.all(15),
        child: Wrap(
          spacing: 10,
          children: selectedWords
              .map<Widget>((word) => InputChip(
                    label: Text(word),
                    onDeleted: () => onWordTap(word),
                    deleteIcon: const Icon(Icons.cancel),
                    backgroundColor: Colors.blue[200],
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _WordOptionsGrid extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final Function(String) onTap;

  const _WordOptionsGrid({
    required this.options,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.0,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) => ElevatedButton(
          onPressed: () => onTap(options[index]),
          style: ElevatedButton.styleFrom(
            backgroundColor: selected.contains(options[index])
                ? Colors.blue[300]
                : Colors.blue[100],
          ),
          child: Text(
            options[index],
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class _ValidationButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onPressed;

  const _ValidationButton({
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.check_circle),
        label: const Text('Check Answer'),
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
