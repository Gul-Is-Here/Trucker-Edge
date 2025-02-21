import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';

import '../constants/fonts_strings.dart';

class CustomeRowWidget extends StatelessWidget {
  final String textHeading;
  final String values;
  const CustomeRowWidget(
      {super.key, required this.textHeading, required this.values});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textHeading,
          style: const TextStyle(
            fontFamily: robotoRegular,
            fontSize: 13,
          ),
        ),
    SizedBox(width:10),
        Text(
          '\$$values',
          style: const TextStyle(
            fontFamily: robotoRegular,
            fontSize: 12,
          ),
        )
      ],
    );
  }
}
