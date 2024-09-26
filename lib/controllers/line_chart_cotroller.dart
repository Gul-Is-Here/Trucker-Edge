import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/line_graph_model.dart';
import '../services/firebase_bar_chart_services.dart';

class LineCartController extends GetxController {
  var myLineChart = <LineChartDataModel>[].obs;
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
            }
          }

          String timestamp2 = data.containsKey('transferTimestamp')
              ? data['transferTimestamp']
              : 'Unknown Date';


          myLineChart.add(
            LineChartDataModel(
              timestamp2,
              totalDispatchedMiles,
            ),
          );
  
        } else {
    
        }
      }
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
