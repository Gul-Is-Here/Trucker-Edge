import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custome_textFormField.dart';

Widget buildRowWithLabel({
  bool? isEnable,
  String? intialValue,
  required String label,
  required String hint,
  required TextEditingController controller,
  required RxDouble value,
  String? Function(String?)? validator,
}) {
  return Row(
    crossAxisAlignment:
        CrossAxisAlignment.start, // Align start to keep consistent height
    children: [
      Expanded(
        flex: 3,
        child: buildTextFormField(
            controller: controller,
            label: label,
            hint: hint,
            validator: validator,
            isEnable: isEnable,
            intialValue: value),
      ),
      const SizedBox(
          width: 10), // Adjust spacing between TextFormField and Container
      Expanded(
        child: Column(
          children: [
            const Text(
              '\$/week',
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  letterSpacing: 1.5,
                  fontFamily: robotoRegular,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                width: 70,
                height:
                    50, // Ensure the height matches the TextFormField's height
                decoration: BoxDecoration(
                  color: AppColor().secondaryAppColor.withOpacity(.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Obx(() => Text(
                        '\$${value.value.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: robotoRegular,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
