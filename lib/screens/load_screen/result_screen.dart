import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/screens/home_screens/home_screen.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucker_edge/controllers/home_controller.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/result_widget.dart';

class ResultsScreen extends StatelessWidget {
  final HomeController homeController;

  ResultsScreen({required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(),
      body: Column(
        children: [
          10.heightBox,
          const Center(
            child: Text(
              'Summary/Results',
              style: TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ResultWidget(
                      textColor: AppColor().appTextColor,
                      headingTextColor: AppColor().appTextColor,
                      cardColor: AppColor().secondaryAppColor,
                      title: 'Total Freight Charges',
                      value:
                          '\$${homeController.totalFreightCharges.value.toStringAsFixed(2)}',
                    ),
                    ResultWidget(
                      textColor: AppColor().appTextColor,
                      headingTextColor: AppColor().appTextColor,
                      cardColor: homeController.totalProfit <= 0
                          ? Colors.red
                          : AppColor().primaryAppColor,
                      title: homeController.totalProfit <= 0
                          ? 'Loss'
                          : 'Total Profit',
                      value:
                          '\$${homeController.totalProfit.value.toStringAsFixed(2)}',
                    ),
                    ResultWidget(
                      textColor: AppColor().appTextColor,
                      headingTextColor: AppColor().appTextColor,
                      cardColor: AppColor().secondaryAppColor,
                      title: 'Total Dispatched Miles',
                      value:
                          '\$${homeController.totalDispatchedMiles.value.toStringAsFixed(2)}',
                    ),
                    10.heightBox,
                  ],
                ),
              ),
            ),
          ),
          // Fixed Footer
          Container(
              // height: 10,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: AppColor().primaryAppColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.elliptical(40, 40),
                  )),
              child: IconButton(
                  onPressed: () {
                    Get.offAll(() => HomeScreen(), curve: Curves.easeIn);
                  },
                  icon: Icon(Icons.home,
                      size: 30, color: AppColor().appTextColor))),
        ],
      ),
    );
  }
}
