import 'package:trucker_edge/model/freight_model.dart';
import 'package:trucker_edge/services/firebase_bar_chart_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class FreightLineController extends GetxController {
  var myFreightLineChart = <MyLineChart>[].obs;
  var selectedDateRange = Rx<DateTimeRange?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFreightLineChart();
  }

  Future<void> fetchFreightLineChart(
      {DateTime? startDate, DateTime? endDate}) async {
    isLoading.value = true;

    try {
      final List<Map<String, dynamic>> rawData =
          await FirebaseBarChartServices()
              .fetchBarData(startDate: startDate, endDate: endDate);
      // Clear the existing data
      myFreightLineChart.clear();

      for (var data in rawData) {
        if (data.containsKey('calculatedValues')) {
          List<dynamic> calculatedValues =
              data['calculatedValues'] as List<dynamic>;

          double totalDispatchedMiles = 0.0;

          for (var value in calculatedValues) {
            if (value is Map<String, dynamic> &&
                value.containsKey('totalFreightCharges')) {
              totalDispatchedMiles += value['totalFreightCharges'];
            } else {
              print('Invalid entry or missing totalFreightCharges in: $value');
            }
          }

          String timestamp2 = data.containsKey('transferTimestamp')
              ? data['transferTimestamp']
              : 'Unknown Date';

          print('timestamp line Chart $timestamp2');
          myFreightLineChart.add(
            MyLineChart(
              timestamp2,
              totalDispatchedMiles,
            ),
          );
          print('My Line Chart  : $myFreightLineChart');
        } else {
          print('Missing calculatedValues in: $data');
          print(myFreightLineChart);
        }
      }

      print('Bar line length: ${myFreightLineChart.length}');
    } finally {
      isLoading.value = false;
    }
  }

  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateRange.value = range;
    if (range != null) {
      fetchFreightLineChart(startDate: range.start, endDate: range.end);
    } else {
      fetchFreightLineChart();
    }
  }
}
