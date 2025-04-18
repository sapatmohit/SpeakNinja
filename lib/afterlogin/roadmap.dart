import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'chat_bot_page.dart';
import 'profile_page.dart';
import 'lessons.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[50],
        primaryColor: Colors.blue[700],
        hintColor: Colors.blue[300],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
          bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
        ),
      ),
      home: const RoadmapPage(),
      routes: {
        '/textSelection': (context) => const TextSelectionLesson(),
        '/audioRecognition': (context) => const AudioRecognitionLesson(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LevelItem {
  final String title;
  final String description;
  final IconData icon;
  final String lessonType;

  LevelItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.lessonType,
  });
}

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({super.key});
  @override
  State<RoadmapPage> createState() => _RoadmapPageState();
}

class _RoadmapPageState extends State<RoadmapPage> {
  final ScrollController _scrollController = ScrollController();
  late List<LevelItem> allLevels;
  int _currentSection = 1;

  final List<IconData> icons = [
    Icons.book,
    Icons.music_note,
    Icons.headphones,
    Icons.videogame_asset,
    Icons.code,
    Icons.explore,
  ];
  final List<IconData> textIcons = [Icons.book];
  final List<IconData> audioIcons = [Icons.music_note, Icons.headphones];
  final Map<int, String> sectionDescriptions = {
    1: "Basics and Foundation",
    2: "Practice with Examples",
    3: "Real World Applications",
    4: "Mini Projects & Use Cases",
    5: "Advanced Concepts",
    6: "Final Revision & Quiz",
  };

  @override
  void initState() {
    super.initState();
    final random = Random();
    allLevels = List.generate(100, (i) {
      if (i < 5) {
        final lessonType = random.nextBool() ? "TextSelection" : "AudioRecognition";
        return LevelItem(
          title: "Lesson ${i + 1}: ${lessonType == 'TextSelection' ? 'Text Selection' : 'Audio Recognition'} - Word ${i + 1}",
          description: lessonType == "TextSelection" ? "Select the correct meaning of the word" : "Identify the meaning from audio",
          icon: lessonType == "TextSelection" ? textIcons[0] : audioIcons[random.nextInt(audioIcons.length)],
          lessonType: lessonType,
        );
      } else {
        return LevelItem(
          title: "Level ${i + 1}",
          description: "Details for Level ${i + 1}.",
          icon: icons[i % icons.length], // Fixed: Use the icons list here
          lessonType: "Default",
        );
      }
    });
    _scrollController.addListener(() {
      double itemHeight = 88 + 28; // 88 is approx card+circle height, 28 padding
      int visibleIndex = (_scrollController.offset / itemHeight).floor();
      int newSection = (visibleIndex ~/ 6) + 1;

      if (_currentSection != newSection) {
        setState(() => _currentSection = newSection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double circleRadius = 34;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Welcome, Rahul!',
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                  speed: const Duration(milliseconds: 180),
                ),
              ],
              isRepeatingAnimation: false,
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProfilePage())),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[100],
                child: Icon(Icons.person, color: Colors.indigo[900]),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Vertical Line from first to last circle center
          Positioned.fill(
            left: 16 + circleRadius,
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GlobalLinePainter(
                  circleRadius: circleRadius,
                  itemCount: allLevels.length,
                  itemHeight: 100,
                  lineColor: Colors.blue[300]!,
                ),
              ),
            ),
          ),

          // List of levels
          ListView.builder(
            padding: const EdgeInsets.only(top: 90, bottom: 60),
            controller: _scrollController,
            itemCount: allLevels.length,
            itemBuilder: (context, index) {
              final level = allLevels[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Circle Icon
                    Container(
                      width: circleRadius * 2,
                      height: circleRadius * 2,
                      decoration: BoxDecoration(
                        color: Colors.indigo[400],
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(level.icon, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 12),
                    // Content Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.blue[700]!, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row with Title and Start button
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    level.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[600],
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    if (level.lessonType == "TextSelection") {
                                      Navigator.pushNamed(context, '/textSelection');
                                    } else if (level.lessonType == "AudioRecognition") {
                                      Navigator.pushNamed(context, '/audioRecognition');
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const DummyStartPage()),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "Start",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              level.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey,
                                fontFamily: 'Roboto',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Section Header at top
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Section $_currentSection",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sectionDescriptions[_currentSection] ?? "Keep Exploring",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GuidancePage()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.menu_book_rounded,
                          color: Colors.blue[700], size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ChatBot FAB
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.grey[100],
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SpeakNinjaScreen()),
              ),
              child: Icon(Icons.chat, color: Colors.blue[700]),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(color: Colors.blue[700]!, width: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws one long vertical line through the center of all circles
class _GlobalLinePainter extends CustomPainter {
  final double circleRadius;
  final int itemCount;
  final double itemHeight;
  final Color lineColor;

  _GlobalLinePainter({
    required this.circleRadius,
    required this.itemCount,
    required this.itemHeight,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2;

    final double x = 0;

    // Start below the first circle
    final double startY = (itemHeight / 2) + circleRadius;

    // End above the last circle
    final double endY = (itemHeight / 2) + itemHeight * (itemCount - 2) + (itemHeight - circleRadius);

    canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Dummy Start Page
class DummyStartPage extends StatelessWidget {
  const DummyStartPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        "Level Started",
        style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      ),
      backgroundColor: Colors.blue[700],
    ),
    body: const Center(child: Text("This is the level content page.")),
  );
}

// Guidance Page stub
class GuidancePage extends StatelessWidget {
  const GuidancePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        "Guidance",
        style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      ),
      backgroundColor: Colors.blue[700],
    ),
    body: const Center(child: Text("This is the guidance page with resources.")),
  );
}