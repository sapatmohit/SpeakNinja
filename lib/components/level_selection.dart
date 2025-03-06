import 'package:flutter/material.dart';

class LevelSelection extends StatelessWidget {
  final List<String> levels;
  final Function(String) onLevelSelected;

  LevelSelection({required this.levels, required this.onLevelSelected});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter, // Ensures content is at the top
      child: ListView.builder(
        shrinkWrap: true,
        // Ensures the list takes only the required space
        physics: NeverScrollableScrollPhysics(),
        // Disables internal scrolling (optional)
        itemCount: levels.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Aligns items to the start
            children: [
              GestureDetector(
                onTap: () => onLevelSelected(levels[index]),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFE07C32),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    levels[index],
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between items
            ],
          );
        },
      ),
    );
  }
}
