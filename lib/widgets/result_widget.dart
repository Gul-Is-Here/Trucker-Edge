import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color cardColor;
  final Color textColor;
  final Color headingTextColor;
  const ResultWidget(
      {super.key,
      required this.headingTextColor,
      required this.textColor,
      required this.title,
      required this.value,
      required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Card(
          color: cardColor,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: headingTextColor
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 24,
                      fontFamily: robotoRegular,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
