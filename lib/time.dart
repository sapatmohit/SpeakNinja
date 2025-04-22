// import 'package:flutter/material.dart';
//
// class Time extends StatefulWidget {
//   const Time({super.key});
//
//   @override
//   State<Time> createState() => _TimeState();
// }
//
// class _TimeState extends State<Time> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center( // Wrap in Center to align properly
//         child: ListWheelScrollView(
//           itemExtent: 50,
//           physics: FixedExtentScrollPhysics(), // Ensures smooth scrolling
//           children: List.generate(10, (index) =>
//               Center(child: Text("Item $index", style: TextStyle(fontSize: 18))),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'afterlogin/roadmap.dart';

class Time extends StatefulWidget {
  const Time({super.key});

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  int selectedHourIndex = 6; // 7th item (6 index) => 7
  int selectedMinuteIndex = 3; // 30 minutes
  int selectedAmPmIndex = 0; // 0 = AM, 1 = PM

  final FixedExtentScrollController _hourController =
      FixedExtentScrollController(initialItem: 6);
  final FixedExtentScrollController _minuteController =
      FixedExtentScrollController(initialItem: 3);
  final FixedExtentScrollController _amPmController =
      FixedExtentScrollController(initialItem: 0);

  final Color primaryColor = Color(0xFF0F3C64); // Your theme color

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _amPmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Waves at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(3.1416),
                child: Image.asset(
                  'assets/wave2.png',
                  fit: BoxFit.cover,
                  height: 180,
                ),
              ),
            ),

            // Main content
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: primaryColor, size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),

                // Title
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft, // 👈 important
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Practice makes ",
                            style: TextStyle(
                                fontSize: 22,
                                color: primaryColor,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: "perfect",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),

                // Subtext
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft, // 👈 important
                    child: Text(
                      "Set up your 5 min practise remainder",
                      style: TextStyle(
                          fontSize: 14, color: primaryColor.withOpacity(0.7)),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Sun / Moon Transition
                // Sun / Moon Transition
                // Fixed height container for Sun/Moon so content below doesn't move
                SizedBox(
                  height: 120, // Fixed height so nothing shifts
                  child: AnimatedAlign(
                    duration: Duration(milliseconds: 500),
                    alignment: selectedAmPmIndex == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Image.asset(
                        selectedAmPmIndex == 0
                            ? 'assets/sun.png'
                            : 'assets/moon.png',
                        width: selectedAmPmIndex == 0 ? 70 : 100,
                        height: selectedAmPmIndex == 0 ? 70 : 100,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Time Picker
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildTimePicker(
                        controller: _hourController,
                        selectedIndex: selectedHourIndex,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            int oldHour = (selectedHourIndex % 12) + 1;
                            selectedHourIndex = index;
                            int newHour = (selectedHourIndex % 12) + 1;

                            if ((oldHour == 11 && newHour == 12) ||
                                (oldHour == 12 && newHour == 11)) {
                              selectedAmPmIndex = 1 - selectedAmPmIndex;
                              _amPmController.jumpToItem(selectedAmPmIndex);
                            }
                          });
                        },
                        itemBuilder: (context, index, isSelected) {
                          return Text(
                            "${(index % 12) + 1}",
                            style: TextStyle(
                              fontSize: isSelected ? 26 : 18,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                              color: primaryColor,
                            ),
                          );
                        },
                        itemCount: 1000,
                      ),
                      Text(
                        ":",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      buildTimePicker(
                        controller: _minuteController,
                        selectedIndex: selectedMinuteIndex,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedMinuteIndex = index;
                          });
                        },
                        itemBuilder: (context, index, isSelected) {
                          int displayMinute = (index * 10) % 60;
                          return Text(
                            displayMinute.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: isSelected ? 26 : 18,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                              color: primaryColor,
                            ),
                          );
                        },
                        itemCount: 6,
                      ),
                      SizedBox(width: 8),
                      buildTimePicker(
                        controller: _amPmController,
                        selectedIndex: selectedAmPmIndex,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedAmPmIndex = index;
                          });
                        },
                        itemBuilder: (context, index, isSelected) {
                          return Text(
                            index == 0 ? "AM" : "PM",
                            style: TextStyle(
                              fontSize: isSelected ? 24 : 18,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w400,
                              color: primaryColor,
                            ),
                          );
                        },
                        itemCount: 2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoadmapPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Set up reminder",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoadmapPage()),
                    );
                  },
                  child: Text(
                    "Maybe later",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTimePicker({
    required FixedExtentScrollController controller,
    required int selectedIndex,
    required ValueChanged<int> onSelectedItemChanged,
    required Widget Function(BuildContext, int, bool) itemBuilder,
    required int itemCount,
  }) {
    return SizedBox(
      width: 60,
      height: 150,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 40,
        physics: FixedExtentScrollPhysics(),
        perspective: 0.002,
        onSelectedItemChanged: onSelectedItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final isSelected = index == controller.selectedItem;
            return itemBuilder(context, index, isSelected);
          },
          childCount: itemCount,
        ),
      ),
    );
  }
}
