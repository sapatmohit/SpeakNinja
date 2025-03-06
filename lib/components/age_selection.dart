import 'package:flutter/material.dart';

class AgeSelection extends StatelessWidget {
  final List<String> ages;
  final Function(String) onAgeSelected; // Callback function

  AgeSelection({required this.ages, required this.onAgeSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: ages.length,
        itemBuilder: (context, index) {
          String age = ages[index];
          return GestureDetector(
            onTap: () => onAgeSelected(age), // Calls function on tap
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFE07C32),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                age,
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
