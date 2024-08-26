import 'package:trucker_edge/app_classes/app_class.dart';

class MyLineChart2 {
  final String date;
  final double value2;
  MyLineChart2(this.date, this.value2, {required int value2, required String date});
  factory MyLineChart2.fromMap(Map<String, dynamic> map) {
    return MyLineChart2(
      AppClass().formatDateSpecific(map['transferTimestamp']),
      map['totalDispatchedMiles'].toDouble(),
    );
  }
}
 