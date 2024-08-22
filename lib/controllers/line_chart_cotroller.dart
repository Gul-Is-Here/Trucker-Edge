import 'package:trucker_edge/services/firebase_bar_chart_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/line_graph_model.dart';

class LineCartController extends GetxController {
  var myLineChart = <MyLineChart2>[].obs;
  var selectedDateRange = Rx<DateTimeRange?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLineChart();
  }

  Future<void> fetchLineChart({DateTime? startDate, DateTime? endDate}) async {
    isLoading.value = true;

    try {
      final List<Map<String, dynamic>> rawData =
          await FirebaseBarChartServices()
              .fetchBarData(startDate: startDate, endDate: endDate);
      // Clear the existing data
      myLineChart.clear();

      for (var data in rawData) {
        if (data.containsKey('calculatedValues')) {
          List<dynamic> calculatedValues =
              data['calculatedValues'] as List<dynamic>;

          double totalDispatchedMiles = 0.0;

          for (var value in calculatedValues) {
            if (value is Map<String, dynamic> &&
                value.containsKey('totalDispatchedMiles')) {
              totalDispatchedMiles += value['totalDispatchedMiles'];
            } else {
              print('Invalid entry or missing totalDispatchedMiles in: $value');
            }
          }

          String timestamp2 = data.containsKey('transferTimestamp')
              ? data['transferTimestamp']
              : 'Unknown Date';

          print('timestamp line Chart $timestamp2');
          myLineChart.add(
            MyLineChart2(
              timestamp2,
              totalDispatchedMiles,
            ),
          );
          print('My Line Chart  : $myLineChart');
        } else {
          print('Missing calculatedValues in: $data');
          print(myLineChart);
        }
      }

      print('Bar line length: ${myLineChart.length}');
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateRange.value = range;
    if (range != null) {
      fetchLineChart(startDate: range.start, endDate: range.end);
    } else {
      fetchLineChart();
    }
  }
}
