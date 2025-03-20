import 'package:flutter/material.dart';

class Time extends StatefulWidget {
  const Time({super.key});

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Wrap in Center to align properly
        child: ListWheelScrollView(
          itemExtent: 50,
          physics: FixedExtentScrollPhysics(), // Ensures smooth scrolling
          children: List.generate(10, (index) =>
              Center(child: Text("Item $index", style: TextStyle(fontSize: 18))),
          ),
        ),
      ),
    );
  }
}
