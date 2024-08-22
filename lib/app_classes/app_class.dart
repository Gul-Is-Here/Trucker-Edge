import 'package:trucker_edge/controllers/bar_chart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppClass {
  var controller = Get.put(BarChartController());
  final GlobalKey mileageButtonKey = GlobalKey();
  final GlobalKey truckPaymentButtonKey = GlobalKey();
  final GlobalKey calculatorCardKey = GlobalKey();
  // Greeting Method
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 17) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  String formatDateTimeFriendly(DateTime dateTime) {
    final DateFormat formatter = DateFormat('EEEE, MMM d, yyyy h:mm a');
    return formatter.format(dateTime);
  }

  String formatDateSpecific(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMM');
    return formatter.format(dateTime);
  }

  Future<void> selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      // anchorPoint: const Offset(0, 0),
      barrierColor: Colors.red,
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: controller.selectedDateRange.value,
    );
    if (picked != null && picked != controller.selectedDateRange.value) {
      controller.setSelectedDateRange(picked);
    }
  }
}
