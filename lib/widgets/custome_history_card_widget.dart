import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';

import '../constants/fonts_strings.dart';

class CustomeHistoryCardWidget extends StatelessWidget {
  final String textHeading;
  final String values;
  const CustomeHistoryCardWidget(
      {super.key, required this.textHeading, required this.values});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                textHeading,
                style: const TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 13,
                ),
              ),
             SizedBox(width:10),
              Column(
                children: [
                  Text(
                    '\$$values',
                    style: const TextStyle(
                      fontFamily: robotoRegular,
                      fontSize: 13,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
