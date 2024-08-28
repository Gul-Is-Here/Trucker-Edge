// import 'package:trucker_edge/controllers/freight_controller.dart';
// import 'package:trucker_edge/controllers/line_chart_cotroller.dart';
// import 'package:trucker_edge/model/freight_model.dart';
// import 'package:trucker_edge/widgets/my_drawer_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../constants/colors.dart';
// import '../../constants/fonts_strings.dart';
// import '../../controllers/bar_chart_controller.dart';
// import '../../model/line_graph_model.dart';
// import '../../model/profit_bar_chart_model.dart';
// import 'package:intl/intl.dart';

// class CombinedAnalyticsScreen extends StatelessWidget {
//   final BarChartController barChartController = Get.put(BarChartController());
//   final LineCartController lineChartController = Get.put(LineCartController());
//   final FreightLineController freightLineController =
//       Get.put(FreightLineController());

//   CombinedAnalyticsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: MyDrawerWidget(),
//       appBar: AppBar(
//         title: Text(
//           'Reports',
//           style: TextStyle(
//             color: AppColor().appTextColor,
//             fontFamily: robotoRegular,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               barChartController.setSelectedDateRange(null);
//               freightLineController.setSelectedDateRange(null);
//               lineChartController.setSelectedDateRange(null);
//             },
//           ),
//         ],
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           bool isTablet = constraints.maxWidth > 600;
//           return SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: isTablet ? 40 : 20),
//                 const Text(
//                   'Profit/Loss Chart',
//                   style: TextStyle(fontFamily: robotoRegular, fontSize: 18),
//                 ),
//                 Center(child: _buildCharts(context, isTablet)),
//                 Center(child: _buildFreightChart(context, isTablet)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCharts(BuildContext context, bool isTablet) {
//     return Obx(() {
//       if (barChartController.isLoading.value ||
//           lineChartController.isLoading.value ||
//           freightLineController.isLoading.value) {
//         return Column(
//           children: [
//             _buildShimmerEffect(context, isTablet),
//             _buildShimmerEffect(context, isTablet),
//           ],
//         );
//       } else if (barChartController.barData.isEmpty ||
//           lineChartController.myLineChart.isEmpty ||
//           freightLineController.myFreightLineChart.isEmpty) {
//         return const Center(child: Text('No Data'));
//       } else {
//         return Column(
//           children: [
//             SizedBox(height: isTablet ? 20 : 10),
//             _buildBarChart(context, isTablet),
//             SizedBox(height: isTablet ? 20 : 10),
//             _buildLineChart(context, isTablet),
//           ],
//         );
//       }
//     });
//   }

//   Widget _buildBarChart(BuildContext context, bool isTablet) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SizedBox(
//         height: MediaQuery.of(context).size.height * (isTablet ? 0.35 : 0.25),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SizedBox(
//             width: barChartController.barData.length < 2
//                 ? MediaQuery.of(context).size.width * .9
//                 : barChartController.barData.length * 85.0,
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceEvenly,
//                 maxY: barChartController.barData
//                         .map((data) => data.value)
//                         .reduce((a, b) => a! > b! ? a : b)! +
//                     10,
//                 barTouchData: BarTouchData(
//                   touchTooltipData: BarTouchTooltipData(
//                     getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                       return BarTooltipItem(
//                         '\$',
//                         TextStyle(
//                           color: AppColor().appTextColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: rod.toY.toStringAsFixed(2),
//                             style: TextStyle(
//                               color: rod.toY > 0 ? Colors.white : Colors.red,
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 titlesData: FlTitlesData(
//                   show: true,
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         if (barChartController.barData.isEmpty) {
//                           return const Text('No Data');
//                         }

//                         // Find the label corresponding to the hash value
//                         String label = barChartController.barData
//                             .firstWhere(
//                                 (element) =>
//                                     element.label.hashCode == value.toInt(),
//                                 orElse: () => BarData(
//                                       label: 'Unknown',
//                                       value: 0,
//                                       value2: 0,
//                                     ))
//                             .label;

//                         // Parse and format the label
//                         DateTime date = DateFormat("d MMM").parse(label);
//                         String formattedDate = DateFormat.Md().format(date);

//                         return SideTitleWidget(
//                           axisSide: AxisSide.bottom,
//                           space: 10,
//                           child: Text(formattedDate,
//                               style: const TextStyle(
//                                   fontSize: 10, fontFamily: robotoRegular)),
//                         );
//                       },
//                     ),
//                   ),
//                   leftTitles: AxisTitles(
//                     drawBelowEverything: true,
//                     sideTitles: SideTitles(
//                       getTitlesWidget: (value, meta) {
//                         return Text(
//                           value.toStringAsFixed(0),
//                           style: const TextStyle(
//                               fontFamily: robotoRegular,
//                               fontSize: 10,
//                               color: Colors.black),
//                         );
//                       },
//                       showTitles: true,
//                       interval: 2500,
//                       reservedSize: 40,
//                     ),
//                   ),
//                 ),
//                 borderData: FlBorderData(
//                     show: true,
//                     border: Border.all(color: AppColor().primaryAppColor)),
//                 barGroups: barChartController.barData.map((data) {
//                   return BarChartGroupData(
//                     x: data.label.hashCode,
//                     barRods: [
//                       BarChartRodData(
//                         color: data.value! > 0
//                             ? AppColor().secondaryAppColor
//                             : Colors.red,
//                         toY: data.value!,
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLineChart(BuildContext context, bool isTablet) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: SizedBox(
//           width: lineChartController.myLineChart.length < 2
//               ? MediaQuery.of(context).size.width * .9
//               : lineChartController.myLineChart.length * 85.0,
//           child: Column(
//             children: [
//               const Text(
//                 'Miles Chart ',
//                 style: TextStyle(fontFamily: robotoRegular, fontSize: 18),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height *
//                     (isTablet ? 0.35 : 0.25),
//                 child: SfCartesianChart(
//                   primaryXAxis: DateTimeAxis(
//                     labelStyle: TextStyle(
//                       fontFamily: robotoRegular,
//                       fontSize: 10,
//                       color: AppColor().secondaryAppColor,
//                     ),
//                     dateFormat: DateFormat.Md(),
//                     intervalType: DateTimeIntervalType.days,
//                     majorGridLines: const MajorGridLines(width: 0),
//                     interval: 1, // Display data points where data is available
//                     labelIntersectAction: AxisLabelIntersectAction.hide,
//                   ),
//                   primaryYAxis: const NumericAxis(
//                     labelStyle: TextStyle(
//                       fontFamily: robotoRegular,
//                       fontSize: 10,
//                       color: Colors.black,
//                     ),
//                     title: AxisTitle(
//                       text: 'Dispatched Miles',
//                       textStyle: TextStyle(
//                         fontFamily: 'RobotoRegular',
//                         fontSize: 10,
//                       ),
//                     ),
//                   ),
//                   tooltipBehavior: TooltipBehavior(enable: true),
//                   series: [
//                     LineSeries<MyLineChart2, DateTime>(
//                       dataSource: lineChartController.myLineChart,
//                       xValueMapper: (MyLineChart2 data, _) =>
//                           DateFormat("d MMM").parse(data.date),
//                       yValueMapper: (MyLineChart2 data, _) => data.value2,
//                       markerSettings: MarkerSettings(
//                         isVisible: true,
//                         color: AppColor().secondaryAppColor,
//                         borderWidth: 2,
//                         borderColor: AppColor().primaryAppColor,
//                       ),
//                       dataLabelSettings: const DataLabelSettings(
//                         isVisible: true,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFreightChart(BuildContext context, bool isTablet) {
//     return Obx(() {
//       if (freightLineController.isLoading.value) {
//         return _buildShimmerEffect(context, isTablet);
//       } else if (freightLineController.myFreightLineChart.isEmpty) {
//         return const Center(child: Text(''));
//       } else {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SizedBox(
//               width: freightLineController.myFreightLineChart.length < 2
//                   ? MediaQuery.of(context).size.width * .9
//                   : freightLineController.myFreightLineChart.length * 85,
//               child: Column(
//                 children: [
//                   const Text(
//                     'Freight Charges Chart ',
//                     style: TextStyle(fontFamily: robotoRegular, fontSize: 18),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height *
//                         (isTablet ? 0.35 : 0.25),
//                     child: SfCartesianChart(
//                       primaryXAxis: DateTimeAxis(
//                         labelStyle: TextStyle(
//                           fontFamily: robotoRegular,
//                           fontSize: 10,
//                           color: AppColor().secondaryAppColor,
//                         ),
//                         dateFormat: DateFormat.Md(),
//                         intervalType: DateTimeIntervalType.days,
//                         majorGridLines: const MajorGridLines(width: 0),
//                         interval:
//                             1, // Display data points where data is available
//                         labelIntersectAction: AxisLabelIntersectAction.hide,
//                       ),
//                       primaryYAxis: const NumericAxis(
//                         labelStyle: TextStyle(
//                           fontFamily: robotoRegular,
//                           fontSize: 10,
//                           color: Colors.black,
//                         ),
//                         title: AxisTitle(
//                           text: 'Freight Charges ( \$ )',
//                           textStyle: TextStyle(
//                             fontFamily: 'RobotoRegular',
//                             fontSize: 10,
//                           ),
//                         ),
//                       ),
//                       tooltipBehavior: TooltipBehavior(enable: true),
//                       series: [
//                         LineSeries<MyLineChart, DateTime>(
//                           dataSource: freightLineController.myFreightLineChart,
//                           xValueMapper: (MyLineChart data, _) =>
//                               DateFormat("d MMM").parse(data.date),
//                           yValueMapper: (MyLineChart data, _) => data.value2,
//                           markerSettings: MarkerSettings(
//                             isVisible: true,
//                             color: AppColor().secondaryAppColor,
//                             borderWidth: 2,
//                             borderColor: AppColor().primaryAppColor,
//                           ),
//                           dataLabelSettings: const DataLabelSettings(
//                             isVisible: true,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }
//     });
//   }

//   Widget _buildShimmerEffect(BuildContext context, bool isTablet) {
//     return Center(
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: Container(
//           width: MediaQuery.of(context).size.width * .8,
//           height: MediaQuery.of(context).size.height * (isTablet ? 0.35 : 0.25),
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
