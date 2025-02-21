import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';

Widget buildTextFormField({
  bool? isEnable,
  required RxDouble? intialValue,
  required TextEditingController controller,
  required String label,
  required String hint,
  String? Function(String?)? validator,
  String? initialValue,
}) {
  // Set initial value to controller if provided
  if (initialValue != null && controller.text.isEmpty) {
    controller.text = initialValue;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              letterSpacing: 1.5,
              fontFamily: robotoRegular,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
       SizedBox(height:5),
        SizedBox(
          // height: 70,
          child: TextFormField(
            initialValue: initialValue,
            enabled: isEnable,
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                filled: true,
                fillColor: AppColor().secondaryAppColor.withOpacity(.08),
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontFamily: robotoRegular,
                    color: Colors.grey.shade400),
                errorStyle: const TextStyle(fontSize: 12, fontFamily: robotoRegular),
                // isDense: true,
                alignLabelWithHint: true,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().primaryAppColor,
                    width: 2,
                  ),
                ),
                labelStyle: const TextStyle(
                  fontFamily:
                      robotoRegular, // Apply fontFamily to the text input
                  fontSize: 14,
                )),
            validator: validator,
          ),
        ),
      ],
    ),
  );
}
