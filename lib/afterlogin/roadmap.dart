import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'chat_bot_page.dart';
import 'profile_page.dart';
import 'text_selection.dart';
import 'audio_recognition.dart';
import 'managing.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFC7E8FF),
        primaryColor: const Color(0xFF00598B),
        hintColor: const Color(0xFF00598B).withOpacity(0.5),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF00598B), fontFamily: 'Roboto'),
          bodyMedium: TextStyle(color: Color(0xFF00598B), fontFamily: 'Roboto'),
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
          icon: icons[i % icons.length],
          lessonType: "Default",
        );
      }
    });
    _scrollController.addListener(() {
      double itemHeight = 88 + 28;
      int visibleIndex = (_scrollController.offset / itemHeight).floor();
      int newSection = (visibleIndex ~/ 6) + 1;

      if (_currentSection != newSection) {
        setState(() => _currentSection = newSection);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double circleRadius = 44;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFF00598B),
          // Optional: set exact toolbar height
          toolbarHeight: 70,

          // Everything lives in this Row:
          title: Row(
            children: [
              // 1) Welcome text
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Welcome, Rahul',
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto',
                    ),
                    speed: const Duration(milliseconds: 180),
                  ),
                ],
                isRepeatingAnimation: false,
              ),

              Spacer(), // pushes the dropdown+avatar to the right

              // 2) Flag dropdown
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: '🇺🇸',
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                  dropdownColor: const Color(0xFF00598B),
                  items: const [
                    DropdownMenuItem(value: '🇺🇸', child: Text('🇺🇸', style: TextStyle(fontSize: 18))),
                    DropdownMenuItem(value: '🇮🇳', child: Text('🇮🇳', style: TextStyle(fontSize: 18))),
                    DropdownMenuItem(value: '🇲🇾', child: Text('🇲🇾', style: TextStyle(fontSize: 18))),
                  ],
                  onChanged: (value) {
                    // handle language change
                  },
                ),
              ),
              const SizedBox(width: 12),

              // 3) Profile icon
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage()),
                ),
                child: const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFC7E8FF),
                  child: Icon(Icons.person, color: Color(0xFF00598B), size: 26),
                ),
              ),
            ],
          ),
        ),
      ),




      body: Stack(
        children: [
          Positioned.fill(
            left: 16 + circleRadius,
            child: IgnorePointer(
              child: CustomPaint(
                painter: _GlobalLinePainter(
                  circleRadius: circleRadius,
                  itemCount: allLevels.length,
                  itemHeight: 100,
                  lineColor: const Color(0xFF00598B).withOpacity(0.5),
                ),
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(top: 110, bottom: 60), // Adjusted for larger section header
            controller: _scrollController,
            itemCount: allLevels.length,
            itemBuilder: (context, index) {
              final level = allLevels[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
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
                      child: Container(
                        width: circleRadius * 2,
                        height: circleRadius * 2,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00598B),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(level.icon, color: Colors.white, size: 32),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8), // Reduced padding
                        decoration: BoxDecoration(
                          color:  Colors.white ,
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
                            Text(
                              level.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00598B),
                                fontFamily: 'Roboto',
                              ),
                            ),
                            Text(
                              level.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF00598B),
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
          Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Reduced padding
              decoration: BoxDecoration(
                  color:Color(0xFFC7E8FF),
                   // White background
                border: Border.all(color: const Color(0xFF00598B), width: 2), // Border with #00598B
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
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
                          style: const TextStyle(
                            fontSize: 18, // Slightly reduced font size
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00598B),
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          sectionDescriptions[_currentSection] ?? "Keep Exploring",
                          style: const TextStyle(
                            fontSize: 14, // Slightly reduced font size
                            color: Color(0xFF00598B),
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
                      padding: const EdgeInsets.all(8), // Slightly larger padding
                      decoration: BoxDecoration(
                        color: const Color(0xFF00598B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Color(0xFF00598B), size: 28), // Slightly larger icon
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SpeakNinjaScreen()),
              ),
              child: Image.asset(
                'assets/bot.png',
                width: 56,
                height: 56,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


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
      ..strokeWidth =  5;

    final double x = size.width * 0.001 ;
    final double startY = 140;
    final double endY = (itemCount - 1) * itemHeight + circleRadius;
    final double clampedEndY = endY.clamp(0.0, size.height);

    canvas.drawLine(Offset(x, startY), Offset(x, clampedEndY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DummyStartPage extends StatelessWidget {
  const DummyStartPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        "Level Started",
        style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      ),
      backgroundColor: const Color(0xFF00598B),
    ),
    body: const Center(child: Text("This is the level content page.")),
  );
}

class GuidancePage extends StatelessWidget {
  const GuidancePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        "Guidance",
        style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      ),
      backgroundColor: const Color(0xFF00598B),
    ),
    body: const Center(child: Text("This is the guidance page with resources.")),
  );
}