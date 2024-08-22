import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custome_textFormField.dart';

Widget buildRowForMileage({
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
    ],
  );
}
