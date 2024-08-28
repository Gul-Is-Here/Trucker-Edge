import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/controllers/bar_chart_controller.dart';
import 'package:trucker_edge/model/profit_bar_chart_model.dart';
import 'package:trucker_edge/screens/charts_screen/chart_screen.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';

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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppColor().appTextColor,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.all(0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, raints) {
                    // Calculate the height and width dynamically based on raints
                    final availableHeight = raints.maxHeight;
                    final availableWidth = raints.maxWidth;
                    final numberOfBars = dataToDisplay.length;
                    final barWidth = availableWidth / 6; // Width per bar
                    final chartWidth =
                        barWidth * numberOfBars * 2; // Total chart width

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height:
                            availableHeight * 0.4, // 60% of available height
                        width: chartWidth < availableWidth
                            ? availableWidth * 0.8
                            : chartWidth, // Use available width or allow scrolling
                        child: BarChart(BarChartData(
                          gridData: FlGridData(
                            verticalInterval: 2000,
                            show: false,
                            drawVerticalLine: false,
                            horizontalInterval: 20000,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Color.fromARGB(255, 224, 224, 224),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          maxY: 100000,
                          minY: 0,
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                                style: BorderStyle.solid),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: AxisTitles(
                                axisNameSize: 30,
                                axisNameWidget: Text(
                                  'Profit/Loss Chart',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: robotoRegular,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              axisNameWidget: Text(
                                'Profit/Loss Chart (\$)',
                                style: TextStyle(
                                  fontFamily: robotoRegular,
                                ),
                              ),
                              axisNameSize: 40,
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize:
                                    availableWidth * 0.15, // 15% of width
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: TextStyle(color: Colors.black),
                                  );
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    dataToDisplay[value.toInt()].label,
                                    style: TextStyle(color: Colors.black),
                                  );
                                },
                              ),
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
                                  toY: data.value ?? 0,
                                  width:
                                      barWidth * 0.2, // Half of the bar width
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xFF114D84),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    gradient: LinearGradient(colors: [
                                      Color(0xFF505250),
                                      Color(0xFFCBD3C1),
                                    ]),
                                    show: true,
                                    toY: 100000,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        )),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
