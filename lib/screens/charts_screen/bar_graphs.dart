import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/controllers/bar_chart_controller.dart';
import 'package:trucker_edge/model/profit_bar_chart_model.dart';
import 'package:intl/intl.dart';

class MyBarGraph extends StatelessWidget {
  final List<BarData3> barDataList;

  MyBarGraph({super.key, required this.barDataList});

  @override
  Widget build(BuildContext context) {
    final BarChartController barChartController = Get.put(BarChartController());

    // Filter to show only the most recent 4 data points
    final dataToDisplay = barDataList.isNotEmpty
        ? barDataList.toList()
        : List.generate(
            4,
            (index) => BarData3(
              label: 'No Data',
              value: 0.0,
              value2: 0.0,
            ),
          );

    // Find the maximum value in the dataset for scaling
    final double maxY = dataToDisplay
        .map((data) => data.value ?? 0)
        .reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppColor().appTextColor,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        margin: const EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, raints) {
                  // Calculate the height and width dynamically based on constraints
                  final availableHeight = raints.maxHeight;
                  final availableWidth = raints.maxWidth;
                  final numberOfBars = dataToDisplay.length;
                  final barWidth = availableWidth / 6; // Width per bar
                  final chartWidth =
                      barWidth * numberOfBars * 2; // Total chart width

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      height: availableHeight * 0.4, // 40% of available height
                      width: chartWidth < availableWidth
                          ? availableWidth * 01
                          : chartWidth, // Use available width or allow scrolling
                      child: BarChart(
                        BarChartData(
                          maxY: maxY, // Set maxY based on your data
                          minY: 0,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: maxY / 5, // Dynamic interval
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: Color.fromARGB(255, 224, 224, 224),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: const AxisTitles(
                                axisNameSize: 30,
                                axisNameWidget: Text(''),
                                sideTitles: SideTitles(
                                  showTitles: false,
                                )),
                            leftTitles: AxisTitles(
                              axisNameWidget: const Text(
                                'Profit/Loss Chart (\$)',
                                style: TextStyle(
                                  fontFamily: robotoRegular,
                                ),
                              ),
                              axisNameSize: 40,
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize:
                                    availableWidth * 0.08, // 15% of width
                                getTitlesWidget: (value, meta) {
                                  // Convert the value to a 1K format
                                  String formattedValue;
                                  if (value >= 1000) {
                                    formattedValue =
                                        '${(value / 1000).toStringAsFixed(0)}K';
                                  } else {
                                    formattedValue = value.toInt().toString();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      formattedValue,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                          fontFamily: robotoRegular),
                                    ),
                                  );
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              axisNameSize: 10,
                              axisNameWidget: const Text(''),
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    String dateString =
                                        dataToDisplay[value.toInt()].label;
                                    try {
                                      // Assuming dateString is in "yyyy-MM-dd" format
                                      final formattedDate =
                                          DateFormat("MM-dd").parse(dateString);
                                      final displayDate = DateFormat("d/MM")
                                          .format(formattedDate);
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          displayDate,
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontFamily: robotoRegular,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      // Handle parsing error
                                      return const Padding(
                                        padding:
                                            EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Invalid Date',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontFamily: robotoRegular,
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                            ),
                          ),
                          barGroups: dataToDisplay.asMap().entries.map((entry) {
                            int index = entry.key;
                            BarData3 data = entry.value;

                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  borderSide: BorderSide(
                                      color: AppColor().secondaryAppColor,
                                      width: 2),
                                  toY: data.value ?? 0, // Height of the bar
                                  width:
                                      barWidth * 0.2, // Half of the bar width
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xFF114D84),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
