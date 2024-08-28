import 'package:trucker_edge/app_classes/app_class.dart';

class LineChartDataModel {
  final String date;
  final double value2;
  LineChartDataModel(this.date, this.value2);
  factory LineChartDataModel.fromMap(Map<String, dynamic> map) {
    return LineChartDataModel(
      AppClass().formatDateSpecific(map['transferTimestamp']),
      map['totalDispatchedMiles'].toDouble(),
    );
  }
}
