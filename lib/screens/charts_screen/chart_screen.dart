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
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
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
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (barChartController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (barChartController.barData.isEmpty) {
                        return const Center(child: Text('No data available'));
                      }
                      return MyBarGraph(
                        barDataList: barChartController.barData,
                      );
                    }),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
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
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (lineChartController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (lineChartController.myLineChart.isEmpty) {
                        return const Center(child: Text('No data available'));
                      }
                      return MyLineChartWidget(
                        lineDataList: lineChartController.myLineChart,
                      );
                    }),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Total Freight Charges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 300,
              child: Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (freightLineController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (freightLineController.myFreightLineChart.isEmpty) {
                        return const Center(child: Text('No data available'));
                      }
                      return FreightLineChartWidget(
                        lineDataList: freightLineController.myFreightLineChart,
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
