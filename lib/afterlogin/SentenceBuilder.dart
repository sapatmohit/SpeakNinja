import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:audioplayers/audioplayers.dart';

class SentenceBuilderLessonPage extends StatefulWidget {
  const SentenceBuilderLessonPage({super.key});

  @override
  State<SentenceBuilderLessonPage> createState() =>
      _SentenceBuilderLessonPageState();
}

class _SentenceBuilderLessonPageState extends State<SentenceBuilderLessonPage> {
  List<String> selectedWords = [];
  final correctSentence = ["Hello", "how", "are", "you"];
  List<String> wordOptions = ["Hello", "how", "are", "you", "good", "bye"];
  bool isCorrect = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playAudio() async {
    const audioUrl =
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
    await _audioPlayer.play(UrlSource(audioUrl));
  }

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

  void _addWordToSentence(String word) {
    setState(() {
      if (!selectedWords.contains(word)) {
        selectedWords.add(word);
      }
    });
  }

  void _removeWordFromSentence(String word) {
    setState(() {
      selectedWords.remove(word);
    });
  }

  void _checkAnswer() {
    if (selectedWords.length == correctSentence.length &&
        selectedWords
            .asMap()
            .entries
            .every((entry) => entry.value == correctSentence[entry.key])) {
      setState(() => isCorrect = true);
      _showFeedback("Correct! Well done.", Colors.green.withOpacity(0.7));
    } else {
      setState(() => isCorrect = false);
      _showFeedback("Oops! Try again.", Colors.red.withOpacity(0.7));
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 👂 "Select what you hear" Text
                const Text(
                  "Select what you hear",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                /// Speaker Icon Button
                GestureDetector(
                  onTap: _playAudio,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: Colors.indigo[800],
                      size: 88,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                  alignment: Alignment.topLeft,
                  backGroundColor: Colors.lightBlue[100]!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: Wrap(
                      spacing: 8,
                      children: selectedWords.isEmpty
                          ? [
                              const Text(
                                "Tap words to build the sentence",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            ]
                          : selectedWords.map((word) {
                              return GestureDetector(
                                onTap: () => _removeWordFromSentence(word),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    word,
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: wordOptions.map((word) {
                    return ElevatedButton(
                      onPressed: selectedWords.contains(word)
                          ? null
                          : () => _addWordToSentence(word),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        fixedSize: const Size(120, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        word,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: selectedWords.isEmpty ? null : _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
