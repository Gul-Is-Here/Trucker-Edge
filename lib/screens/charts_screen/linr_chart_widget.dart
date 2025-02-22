import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trucker_edge/constants/colors.dart';
import '../../constants/fonts_strings.dart';
import '../../model/line_graph_model.dart'; // Ensure this is the updated model name

class MyLineChartWidget extends StatelessWidget {
  final List<LineChartDataModel>
      lineDataList; // Updated to match new model name

  const MyLineChartWidget({super.key, required this.lineDataList});

  @override
  Widget build(BuildContext context) {
    // Filter to show only the most recent 4 data points
    final dataToDisplay = lineDataList.isNotEmpty
        ? lineDataList.toList() // Take only the most recent 4 points
        : List.generate(
            4,
            (index) => LineChartDataModel('No Data', 0.0),
          );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          final availableWidth = constraints.maxWidth;
          final numberOfPoints = dataToDisplay.length;
          final lineWidth = numberOfPoints > 1
              ? availableWidth / (numberOfPoints - 1) * (numberOfPoints - 1)
              : availableWidth;

          return Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: AppColor().appTextColor,
            child: SizedBox(
              height: availableHeight * 0.3, // Adjust height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: lineWidth * 2.1, // Expand width to fit all data
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Colors.white, // Set background to white
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20000,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300, // Lighter grid lines
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < dataToDisplay.length) {
                                final dateString = dataToDisplay[index].date;

                                try {
                                  final fullDateString =
                                      '$dateString ${DateTime.now().year}';
                                  final formattedDate = DateFormat("d MMM yyyy")
                                      .parse(fullDateString);
                                  final displayDate = DateFormat("d-MM-yyyy")
                                      .format(formattedDate);

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      displayDate,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                          fontFamily: robotoRegular),
                                    ),
                                  );
                                } catch (e) {
                                  return const SizedBox();
                                }
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameSize: 30,
                          axisNameWidget: const Text('Total Dispatched Miles'),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 25,
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
                                      fontSize: 9,
                                      color: Colors.black,
                                      fontFamily: robotoRegular),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          axisNameWidget: Text(
                            '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          axisNameSize: 60,
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: dataToDisplay
                              .asMap()
                              .entries
                              .map(
                                (entry) => FlSpot(
                                    entry.key.toDouble(), entry.value.value2),
                              )
                              .toList(),
                          isCurved: true,
                          color: const Color(
                              0xFF6C9940), // Adjust color for visibility
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(show: false),
                          aboveBarData: BarAreaData(show: false),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final index = spot.spotIndex;
                              final data = dataToDisplay[index];
                              final date = data.date;
                              final value = spot.y;
                              return LineTooltipItem(
                                '$date\n${value.toStringAsFixed(0)}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                        handleBuiltInTouches: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
