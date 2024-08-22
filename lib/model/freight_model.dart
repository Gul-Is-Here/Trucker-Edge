import 'package:trucker_edge/app_classes/app_class.dart';

class MyLineChart {
  final String date;
  final double value2;
  MyLineChart(this.date, this.value2);
  factory MyLineChart.fromMap(Map<String, dynamic> map) {
    return MyLineChart(
      AppClass().formatDateSpecific(map['transferTimestamp']),
      map['totalFreightCharges'].toDouble(),
    );
  }
}
