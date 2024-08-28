import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CardWidget extends StatelessWidget {
  final String butonText;
  final String cardText;
  final Color cardColor;
  final void Function() onTap;
  const CardWidget(
      {super.key,
      required this.cardColor,
      required this.butonText,
      required this.cardText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColor().appTextColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor().secondaryAppColor),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        elevation: 10,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .18,
          width: MediaQuery.of(context).size.width * .8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.heightBox,
              TextButton(
                onPressed: onTap,
                child: Text(
                  butonText,
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: robotoRegular,
                      color: cardColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  textAlign: TextAlign.center,
                  cardText,
                  style: TextStyle(fontSize: 12, color: cardColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
