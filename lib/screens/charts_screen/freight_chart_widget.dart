import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/model/freight_model.dart';

class FreightLineChartWidget extends StatelessWidget {
  final List<MyLineChart2> lineDataList;

  const FreightLineChartWidget({super.key, required this.lineDataList});

  @override
  Widget build(BuildContext context) {
    // Use only the most recent 4 data points
    final dataToDisplay = lineDataList.isNotEmpty
        ? lineDataList.toList() // Take only the most recent 4 points
        : List.generate(
            4,
            (index) => MyLineChart2('No Data', 0.0),
          );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          final availableWidth = constraints.maxWidth;
          final numberOfPoints = dataToDisplay.length;

          // Calculate the width of the chart to fit all data points
          final lineWidth = numberOfPoints > 1
              ? availableWidth / (numberOfPoints - 1) * (numberOfPoints - 1)
              : availableWidth;

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: AppColor().appTextColor,
            margin: EdgeInsets.all(0),
            elevation: 10,
            child: SizedBox(
              height: availableHeight * 0.3, // Adjust height as needed
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: lineWidth * 2.1, // Expand width to fit all data
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Colors.white,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20000,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
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
                                  final displayDate =
                                      DateFormat("d/M").format(formattedDate);

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      displayDate,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  print('Error parsing date: $e');
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
                          axisNameWidget: Text(
                            'Total Dispatched Miles',
                            style: TextStyle(fontFamily: robotoRegular),
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        topTitles: AxisTitles(
                          axisNameWidget: Text(
                            'Total Freight Charges',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          axisNameSize: 30,
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
                          color: const Color(0xFF6C9940),
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
                                '$date\n\$${value.toStringAsFixed(2)}',
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
