import 'package:trucker_edge/constants/colors.dart';
import 'package:flutter/material.dart';

void showAddLoadDialog(BuildContext context, var controller) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Another Load'),
        content: const Text('Do you want to add another load?'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Add',
              style: TextStyle(color: AppColor().secondaryAppColor),
            ),
            onPressed: () {
              controller.addNewLoad();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
