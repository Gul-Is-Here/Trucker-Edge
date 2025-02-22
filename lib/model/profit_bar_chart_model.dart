import '../app_classes/app_class.dart';

class BarData3 {
  final String label;
  final double? value;
  final double? value2;

  BarData3({
    required this.value2,
    required this.label,
    required this.value,
  });

  factory BarData3.fromMap(Map<String, dynamic> map) {
    // Extract fields from the map with null safety
    final totalDispatchedMiles = map['totalDispatchedMiles']?.toDouble();
    final transferTimestamp = map['transferTimestamp']?.toDate();
    final totalProfit = map['totalProfit']?.toDouble();

    // Handle the possibility of null values
    return BarData3(
      value2: totalDispatchedMiles ?? 0.0, // Default to 0.0 if null
      label: transferTimestamp != null
          ? AppClass().formatDateSpecific(transferTimestamp)
          : 'No Date', // Default label if date is null
      value: totalProfit ?? 0.0, // Default to 0.0 if null
    );
  }
}
