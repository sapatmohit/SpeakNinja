import 'package:flutter/material.dart';

class FoundSelection extends StatelessWidget {
  final List<String> list;
  final Function(String) onFoundSelected;

  FoundSelection({required this.list, required this.onFoundSelected});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter, // Ensures content is at the top
      child: ListView.builder(
        shrinkWrap: true,
        // Ensures the list takes only the required space
        physics: NeverScrollableScrollPhysics(),
        // Disables internal scrolling (optional)
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Aligns items to the start
            children: [
              GestureDetector(
                onTap: () => onFoundSelected(list[index]),
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
                    list[index],
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
