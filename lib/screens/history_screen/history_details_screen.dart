import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/controllers/histroy_controller.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryDetailsScreen extends StatelessWidget {
  final String documentId;
  final dynamic data;

  const HistoryDetailsScreen({
    super.key,
    required this.documentId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    var histroyController = Get.put(HistroyController());
    double getValue(dynamic value) {
      return value != null ? (value as num).toDouble() : 0.0;
    }

    return Scaffold(
        drawer: MyDrawerWidget(),
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontFamily: robotoRegular,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (data['calculatedValues'].length == null)
                    const Center(
                      child: Text(
                        'No Load added This Week',
                      ),
                    )
                  else
                    Column(
                      children: List.generate(
                        data['calculatedValues'].length,
                        (index) => Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      'Total Miles',
                                      style: TextStyle(
                                          fontFamily: robotoRegular,
                                          fontSize: 15,
                                          color: AppColor().secondaryAppColor),
                                    ),
                                    subtitle: Text(
                                      getValue(data['calculatedValues'][index]
                                              ['totalDispatchedMiles'])
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontFamily: robotoRegular,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor().secondaryAppColor),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      getValue(data['calculatedValues'][index]
                                                  ['totalProfit']) <=
                                              0
                                          ? 'Loss'
                                          : 'Profit',
                                      style: TextStyle(
                                          fontFamily: robotoRegular,
                                          fontSize: 15,
                                          color: AppColor().secondaryAppColor),
                                    ),
                                    subtitle: Text(
                                      getValue(data['calculatedValues'][index]
                                              ['totalProfit'])
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: robotoRegular,
                                          fontSize: 13,
                                          color: AppColor().secondaryAppColor),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      'Total Fr. charges',
                                      style: TextStyle(
                                          fontFamily: robotoRegular,
                                          fontSize: 15,
                                          color: AppColor().secondaryAppColor),
                                    ),
                                    subtitle: Text(
                                      getValue(data['calculatedValues'][index]
                                              ['totalFreightCharges'])
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: robotoRegular,
                                          fontSize: 13,
                                          color: AppColor().secondaryAppColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            10.heightBox,
                            const Divider(
                              thickness: 2,
                            ),
                            10.heightBox,
                            Obx(
                              () => ListTile(
                                onTap: () {
                                  histroyController.toggleFixedCost();
                                },
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Fixed Cost',
                                      style: TextStyle(
                                          fontFamily: 'robotoRegular',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor().secondaryAppColor),
                                    ),
                                    Icon(
                                      histroyController.isCloseFixedCost.value
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up,
                                      color: AppColor().secondaryAppColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              elevation: 5,
                              color: AppColor().appTextColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadiusDirectional.only(
                                      topStart: Radius.circular(10),
                                      topEnd: Radius.circular(10))),
                              child: Obx(
                                () => Visibility(
                                  visible:
                                      !histroyController.isCloseFixedCost.value,
                                  child: Column(
                                    children: List.generate(
                                      data['truckPayment'].length,
                                      (index) => SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      10.heightBox,
                                                      Text(
                                                        'Truck Payment',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        'ELD Service',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        'Trailer Lease',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        'Insurance',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        'Overhead',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        'Other',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  5.widthBox,
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      10.heightBox,
                                                      Text(
                                                        '\$${getValue(data['truckPayment'][index]['monthlyTruckPayment']).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 13),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        '\$${getValue(data['truckPayment'][index]['monthlyEldService']).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        '\$${getValue(data['truckPayment'][index]['monthlyTrailerLease']).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        '\$${getValue(data['truckPayment'][index]['monthlyTruckInsurance']).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        '\$${getValue(data['truckPayment'][index]['monthlyOverheadCost']).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        '\$${getValue(data['truckPayment'][index]['monthlyOtherCost']).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      histroyController
                                          .toggleFixedCostPerMile(); // Function to toggle Cost Per Mile visibility
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Cost Per Mile',
                                          style: TextStyle(
                                            fontFamily: 'robotoRegular',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor()
                                                .secondaryAppColor, // Replace with your color
                                          ),
                                        ),
                                        Icon(
                                          histroyController
                                                  .isClosePerMileCost.value
                                              ? Icons.keyboard_arrow_down
                                              : Icons.keyboard_arrow_up,
                                          color: AppColor()
                                              .secondaryAppColor, // Replace with your color
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    color: AppColor().appTextColor,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusDirectional.only(
                                        topStart: Radius.circular(10),
                                        topEnd: Radius.circular(10),
                                      ),
                                    ),
                                    child: Obx(
                                      () => Visibility(
                                        visible: !histroyController
                                            .isClosePerMileCost.value,
                                        child: Column(
                                          children: List.generate(
                                            data['mileageFee'].length,
                                            (index) => SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // const Text(
                                                    //   'Cost Per Mile',
                                                    //   style: TextStyle(
                                                    //     fontFamily:
                                                    //         'robotoRegular',
                                                    //     fontSize: 20,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            10.heightBox,
                                                            Text(
                                                              'Mileage Fee',
                                                              style: TextStyle(
                                                                color: AppColor()
                                                                    .secondaryAppColor,
                                                                fontFamily:
                                                                    'robotoRegular',
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            10.heightBox,
                                                            Text(
                                                              'Fuel',
                                                              style: TextStyle(
                                                                color: AppColor()
                                                                    .secondaryAppColor, // Replace with your color
                                                                fontFamily:
                                                                    'robotoRegular',
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            10.heightBox,
                                                            Text(
                                                              'DEF',
                                                              style: TextStyle(
                                                                color: AppColor()
                                                                    .secondaryAppColor, // Replace with your color
                                                                fontFamily:
                                                                    'robotoRegular',
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            10.heightBox,
                                                            Text(
                                                              'Driver Pay',
                                                              style: TextStyle(
                                                                color: AppColor()
                                                                    .secondaryAppColor, // Replace with your color
                                                                fontFamily:
                                                                    'robotoRegular',
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        20.widthBox,
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            10.heightBox,
                                                            Text(
                                                              '\$${getValue(data['mileageFee'][index]['milageFeePerMile']).toStringAsFixed(3)}',
                                                              style: TextStyle(
                                                                color: AppColor()
                                                                    .secondaryAppColor, // Replace with your color
                                                                fontFamily:
                                                                    'robotoRegular',
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            10.heightBox,
                                                            Text(
                                                              '\$${getValue(data['mileageFee'][index]['fuelFeePerMile']).toStringAsFixed(3)}',
                                                              style: TextStyle(
                                                                color: AppColor()
                                                                    .secondaryAppColor, // Replace with your color
                                                                fontFamily:
                                                                    'robotoRegular',
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            10.heightBox,
                                                            Text(
                                                              '\$${getValue(data['mileageFee'][index]['defFeePerMile']).toStringAsFixed(3)}',
                                                              style: TextStyle(
                                                                color: AppColor()
                                                                    .secondaryAppColor, // Replace with your color
                                                                fontFamily:
                                                                    'robotoRegular',
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            10.heightBox,
                                                            Text(
                                                              '\$${getValue(data['mileageFee'][index]['driverPayFeePerMile']).toStringAsFixed(3)}',
                                                              style: TextStyle(
                                                                color: AppColor()
                                                                    .secondaryAppColor, // Replace with your color
                                                                fontFamily:
                                                                    'robotoRegular',
                                                                fontSize: 12,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.heightBox,
                            const Text(
                              'Truck loads',
                              style: TextStyle(
                                fontFamily: robotoRegular,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            10.heightBox,
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.28,
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                    data['calculatedValues'][index]['loads']
                                        .length, (loadIndex) {
                                  var load = data['calculatedValues'][index]
                                      ['loads'][loadIndex];
                                  return SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Card(
                                        color: AppColor().appTextColor,
                                        
                                        elevation: 5,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusDirectional.only(
                                                    topStart:
                                                        Radius.circular(10),
                                                    topEnd:
                                                        Radius.circular(10))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColor()
                                                      .secondaryAppColor),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Text(
                                                  '${loadIndex + 1}',
                                                  style: TextStyle(
                                                    fontFamily: robotoRegular,
                                                    fontSize: 19,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            10.heightBox,
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Dispatched Miles',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 13),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        'Freight Charges',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 13),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        'Estimated Tolls',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 13),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        'Other Cost',
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 13),
                                                      ),
                                                      10.heightBox,
                                                    ],
                                                  ),
                                                  20.widthBox,
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "\$${load['dispatchedMiles'].toString()}",
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 13),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        "\$${load['freightCharge'].toString()}",
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 13),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        "\$${load['estimatedTolls'].toString()}",
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 13),
                                                      ),
                                                      10.heightBox,
                                                      Text(
                                                        "\$${load['otherCosts'].toString()}",
                                                        style: TextStyle(
                                                            color: AppColor()
                                                                .secondaryAppColor,
                                                            fontFamily:
                                                                robotoRegular,
                                                            fontSize: 13),
                                                      ),
                                                      10.heightBox,
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}
