import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucker_edge/controllers/bar_chart_controller.dart';
import 'package:trucker_edge/controllers/line_chart_cotroller.dart'; // Corrected import
import 'package:trucker_edge/controllers/freight_controller.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import '../../constants/fonts_strings.dart';
import 'bar_graphs.dart';
import 'freight_chart_widget.dart';
import 'linr_chart_widget.dart'; // Update with correct name

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BarChartController barChartController = Get.put(BarChartController());
    final LineCartController lineChartController =
        Get.put(LineCartController());
    final FreightLineController freightLineController =
        Get.put(FreightLineController());

    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawerWidget(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Added SingleChildScrollView
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Profit/Loss Chart',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: robotoRegular,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 300, // Adjust height as needed
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (barChartController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return MyBarGraph(
                        barDataList: barChartController.barData.isNotEmpty
                            ? barChartController.barData
                            : [],
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Dispatched Miles',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: robotoRegular,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 300, // Adjust height as needed
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (lineChartController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return MyLineChartWidget(
                        lineDataList: lineChartController.myLineChart.isNotEmpty
                            ? lineChartController.myLineChart
                            : [],
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Freight Charges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 300, // Adjust height as needed
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (freightLineController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return FreightLineChartWidget(
                        lineDataList:
                            freightLineController.myFreightLineChart.isNotEmpty
                                ? freightLineController.myFreightLineChart
                                : [],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
