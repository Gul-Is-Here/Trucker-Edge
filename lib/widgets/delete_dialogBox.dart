import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(BuildContext context, int index,var controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Load'),
          content: const Text('Are you sure you want to delete this load?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                controller.removeLoad(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }