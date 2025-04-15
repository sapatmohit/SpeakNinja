import 'package:flutter/material.dart';
import './time.dart';

import 'chatbot.dart';

class InterestSelectionPage extends StatefulWidget {
  @override
  _InterestSelectionPageState createState() => _InterestSelectionPageState();
}

class _InterestSelectionPageState extends State<InterestSelectionPage> {
  List<String> interests = [
    "Arts and Design",
    "Books",
    "Business",
    "Career",
    "Cooking",
    "Education",
    "News",
    "Movies",
    "Music",
    "Science",
    "Philosophy",
    "Nature"
  ];

  Set<String> selectedInterests = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E4C3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose 3 or more",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Text(
              "interests",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: interests.length,
                itemBuilder: (context, index) {
                  String interest = interests[index];
                  bool isSelected = selectedInterests.contains(interest);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedInterests.remove(interest);
                        } else {
                          selectedInterests.add(interest);
                        }
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.blue : Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          interest,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: selectedInterests.length >= 3
                    ? () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const Time()),
                        // );
                      }
                    : null,
                child: Text("Next", style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
