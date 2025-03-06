import 'package:flutter/material.dart';

class LanguageSelection extends StatelessWidget {
  final List<String> languages;
  final Function(String) onLanguageSelected;

  LanguageSelection(
      {required this.languages, required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          String age = languages[index];
          return GestureDetector(
            onTap: () => onLanguageSelected(age), // Calls function on tap
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