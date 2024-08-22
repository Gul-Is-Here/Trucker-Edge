import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trucker_edge/screens/load_screen/result_screen.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trucker_edge/controllers/home_controller.dart';
import 'package:trucker_edge/widgets/addLoad_dialogBox.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../../constants/fonts_strings.dart';
import '../../services/firebase_services.dart';
import '../../widgets/custome_textFormField.dart';

class LoadScreen extends StatefulWidget {
  final HomeController homeController;
  final Map<String, dynamic>? loadData;
  final String? documentId;
  final bool isUpdate;

  const LoadScreen(
      {super.key,
      required this.homeController,
      this.loadData,
      this.documentId,
      required this.isUpdate});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.homeController.freightChargeControllers.clear();
    widget.homeController.dispatchedMilesControllers.clear();
    widget.homeController.estimatedTollsControllers.clear();
    widget.homeController.otherCostsControllers.clear();
    super.initState();
    // Check if the data has already been loaded
    if (widget.loadData != null) {
      // Load data only if it hasn't been loaded before
      if (widget.homeController.freightChargeControllers.isEmpty) {
        _initializeControllers();
      }
    } else {
      // Ensure at least one load is present
      widget.homeController.addNewLoad();
    }
  }

  void _initializeControllers() {
    var loads = widget.loadData!['loads'] as List<dynamic>;
    for (var load in loads) {
      widget.homeController.freightChargeControllers.add(TextEditingController(
          text: (load['freightCharge'] as num).toString()));
      widget.homeController.dispatchedMilesControllers.add(
          TextEditingController(
              text: (load['dispatchedMiles'] as num).toString()));
      widget.homeController.estimatedTollsControllers.add(TextEditingController(
          text: (load['estimatedTolls'] as num).toString()));
      widget.homeController.otherCostsControllers.add(
          TextEditingController(text: (load['otherCosts'] as num).toString()));
    }
  }

  Future<void> showConfirmationDialog(
      BuildContext context, VoidCallback onYesPressed) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(widget.isUpdate ? 'Confirm Update' : 'Confirm Submit'),
          titleTextStyle: const TextStyle(
              fontFamily: robotoRegular, color: Colors.black, fontSize: 18),
          content: Text(widget.isUpdate
              ? 'Are you sure you want to update?'
              : 'Are you sure you want to submit?'),
          contentTextStyle: TextStyle(
            fontFamily: robotoRegular,
            color: Colors.black,
          ),
          actions: [
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red, fontFamily: robotoRegular),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                    color: AppColor().primaryAppColor,
                    fontFamily: robotoRegular),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss the dialog
                onYesPressed(); // Call the provided callback
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerWidget(),
      appBar: AppBar(
          // title: Text('Additional Costs'),
          ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Obx(
                () => Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget
                              .homeController.freightChargeControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // const SizedBox(height: 20)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Card(
                                        color: AppColor().secondaryAppColor,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            'Load ${index + 1}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppColor().appTextColor,
                                              fontFamily: robotoRegular,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    10.heightBox,
                                    buildTextFormField(
                                      controller: widget.homeController
                                          .freightChargeControllers[index],
                                      label: 'Freight Charge (\$)',
                                      hint: 'e.g., \$1000',
                                      validator:
                                          widget.homeController.validateInput,
                                      intialValue: null,
                                    ),
                                    buildTextFormField(
                                      controller: widget.homeController
                                          .dispatchedMilesControllers[index],
                                      label: 'Dispatched Miles',
                                      hint: 'e.g., 2000',
                                      validator:
                                          widget.homeController.validateInput,
                                      intialValue: null,
                                    ),
                                    buildTextFormField(
                                      controller: widget.homeController
                                          .estimatedTollsControllers[index],
                                      label: 'Estimated Tolls (\$)',
                                      hint: 'e.g., \$50',
                                      validator:
                                          widget.homeController.validateInput,
                                      intialValue: null,
                                    ),
                                    buildTextFormField(
                                      controller: widget.homeController
                                          .otherCostsControllers[index],
                                      label: 'Other Costs (\$)',
                                      hint: 'e.g., \$100',
                                      validator: widget
                                          .homeController.validateNonNegative,
                                      intialValue: null,
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 24,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            // Show delete confirmation dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      const Text('Delete Load'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this load?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child:
                                                          const Text('Delete'),
                                                      onPressed: () {
                                                        print(
                                                            'widget.isUpdate: ${widget.isUpdate}');
                                                        if (widget.isUpdate) {
                                                          widget.homeController
                                                              .removeLoad(
                                                                  index);
                                                          Navigator.of(context)
                                                              .pop();
                                                        } else if (widget
                                                                .isUpdate ==
                                                            false) {
                                                          widget.homeController
                                                              .removeLoad(
                                                                  index);
                                                          Navigator.of(context)
                                                              .pop();
                                                        } else {
                                                          var userId =
                                                              FirebaseServices()
                                                                  .auth
                                                                  .currentUser
                                                                  ?.uid;
                                                          var documentId =
                                                              widget.documentId;
                                                          if (userId != null &&
                                                              documentId !=
                                                                  null) {
                                                            HomeController()
                                                                .calculateVariableCosts();
                                                            FirebaseServices().deleteLoad(
                                                                documentId:
                                                                    documentId,
                                                                loadIndex:
                                                                    index,
                                                                context:
                                                                    context,
                                                                freightChargeControllers: widget
                                                                    .homeController
                                                                    .freightChargeControllers,
                                                                dispatchedMilesControllers: widget
                                                                    .homeController
                                                                    .dispatchedMilesControllers,
                                                                estimatedTollsControllers: widget
                                                                    .homeController
                                                                    .estimatedTollsControllers,
                                                                otherCostsControllers: widget
                                                                    .homeController
                                                                    .otherCostsControllers,
                                                                userId: userId);
                                                          } else {}
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5),
                                          child: TextButton.icon(
                                            style: TextButton.styleFrom(
                                              side: BorderSide(
                                                  color: AppColor()
                                                      .secondaryAppColor),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                            onPressed: () => showAddLoadDialog(
                                                context, widget.homeController),
                                            icon: const Icon(
                                              Icons.add,
                                              size: 14,
                                            ),
                                            label: Text(
                                              'Add',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    20.heightBox,
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      20.heightBox,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: AppColor().primaryAppColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.elliptical(40, 40),
                  )),
              child: Column(
                children: [
                  widget.isUpdate
                      ? TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            side:
                                const BorderSide(width: 1, color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () async {
                            showConfirmationDialog(context, () async {
                              if (formKey.currentState!.validate()) {
                                if (widget.isUpdate) {
                                  widget.homeController.totalFreightCharges
                                      .value = 0.0;
                                  widget.homeController.totalDispatchedMiles
                                      .value = 0.0;
                                  widget.homeController.totalEstimatedTollsCost
                                      .value = 0.0;
                                  widget.homeController.totalOtherCost.value =
                                      0.0;
                                  for (int i = 0;
                                      i <
                                          widget.homeController
                                              .freightChargeControllers.length;
                                      i++) {
                                    widget.homeController.freightCharge.value =
                                        double.tryParse(widget
                                                .homeController
                                                .freightChargeControllers[i]
                                                .text) ??
                                            0.0;
                                    widget.homeController.dispatchedMiles
                                        .value = double.tryParse(widget
                                            .homeController
                                            .dispatchedMilesControllers[i]
                                            .text) ??
                                        0.0;
                                    widget.homeController.estimatedTolls.value =
                                        double.tryParse(widget
                                                .homeController
                                                .estimatedTollsControllers[i]
                                                .text) ??
                                            0.0;
                                    widget.homeController.otherCost.value =
                                        double.tryParse(widget
                                                .homeController
                                                .otherCostsControllers[i]
                                                .text) ??
                                            0.0;

                                    widget.homeController.totalFreightCharges
                                            .value +=
                                        widget
                                            .homeController.freightCharge.value;
                                    widget.homeController.totalDispatchedMiles
                                            .value +=
                                        widget.homeController.dispatchedMiles
                                            .value;
                                    widget.homeController
                                            .totalEstimatedTollsCost.value +=
                                        widget.homeController.estimatedTolls
                                            .value;
                                    widget.homeController.totalOtherCost
                                            .value +=
                                        widget.homeController.otherCost.value;
                                  }
                                  Map<String, dynamic> weeklyFixedCosts =
                                      await FirebaseServices()
                                          .fetchFixedWeeklyCost();

                                  // Update with fetched values
                                  widget.homeController.weeklyTruckPayment
                                          .value =
                                      weeklyFixedCosts['weeklyTruckPayment'] ??
                                          widget.homeController
                                              .weeklyTruckPayment.value;
                                  widget.homeController.weeklyInsurance.value =
                                      weeklyFixedCosts[
                                              'weeklyInsurancePayment'] ??
                                          widget.homeController.weeklyInsurance
                                              .value;
                                  widget.homeController.weeklyTrailerLease
                                          .value =
                                      weeklyFixedCosts['weeklyTrailerLease'] ??
                                          widget.homeController
                                              .weeklyTrailerLease.value;
                                  widget.homeController.weeklyEldService.value =
                                      weeklyFixedCosts['weeklyEldService'] ??
                                          widget.homeController.weeklyEldService
                                              .value;
                                  widget.homeController.weeklyoverHeadAmount
                                          .value =
                                      weeklyFixedCosts['monthlyOverheadCost'] ??
                                          widget.homeController
                                              .weeklyoverHeadAmount.value;
                                  widget.homeController.weeklyOtherCost.value =
                                      weeklyFixedCosts['monthlyOtherCost'] ??
                                          widget.homeController.weeklyOtherCost
                                              .value;
                                  widget.homeController.totalWeeklyFixedCost
                                          .value =
                                      weeklyFixedCosts['weeklyFixedCost'];
                                  // Fetch per-mile costs from Firebase
                                  Map<String, double> perMileageCosts =
                                      await FirebaseServices()
                                          .fetchPerMileageAmount();
                                  widget.homeController.permileageFee.value =
                                      perMileageCosts['milageFeePerMile'] ??
                                          0.0;
                                  widget.homeController.perMileFuel.value =
                                      perMileageCosts['fuelFeePerMile'] ?? 0.0;
                                  widget.homeController.perMileDef.value =
                                      perMileageCosts['defFeePerMile'] ?? 0.0;
                                  widget.homeController.perMileDriverPay.value =
                                      perMileageCosts['driverPayFeePerMile'] ??
                                          0.0;

                                  // Calculate total factoring fee
                                  widget.homeController.totalFactoringFee
                                      .value = (widget.homeController
                                              .totalFreightCharges.value *
                                          2) /
                                      100;

                                  // Calculate total mileage cost
                                  widget.homeController.totalMilageCost
                                      .value = (widget.homeController
                                              .permileageFee.value *
                                          widget.homeController
                                              .totalDispatchedMiles.value) +
                                      (widget.homeController.perMileFuel.value *
                                          widget.homeController
                                              .totalDispatchedMiles.value) +
                                      (widget
                                              .homeController.perMileDef.value *
                                          widget.homeController
                                              .totalDispatchedMiles.value) +
                                      ((widget.homeController.perMileDriverPay
                                                  .value *
                                              widget.homeController
                                                  .totalDispatchedMiles.value) *
                                          1.2) +
                                      widget.homeController.totalFactoringFee
                                          .value;
                                  widget.homeController.totalProfit.value = widget
                                          .homeController
                                          .totalFreightCharges
                                          .value -
                                      widget.homeController.totalWeeklyFixedCost
                                          .value -
                                      widget.homeController.totalMilageCost
                                          .value -
                                      widget.homeController
                                          .totalEstimatedTollsCost.value -
                                      widget
                                          .homeController.totalOtherCost.value;

                                  FirebaseServices().updateEntry(
                                    documentId: widget.documentId!,
                                    data: {
                                      'totalFreightCharges': widget
                                          .homeController
                                          .totalFreightCharges
                                          .value,
                                      'totalDispatchedMiles': widget
                                          .homeController
                                          .totalDispatchedMiles
                                          .value,
                                      'totalMileageCost': widget
                                          .homeController.totalMilageCost.value,
                                      'timestamp': FieldValue.serverTimestamp(),
                                      'updateTime': DateTime.now(),
                                      'loads': List.generate(
                                        widget.homeController
                                            .freightChargeControllers.length,
                                        (index) {
                                          return {
                                            'freightCharge': double.tryParse(
                                                    widget
                                                        .homeController
                                                        .freightChargeControllers[
                                                            index]
                                                        .text) ??
                                                0.0,
                                            'dispatchedMiles': double.tryParse(
                                                    widget
                                                        .homeController
                                                        .dispatchedMilesControllers[
                                                            index]
                                                        .text) ??
                                                0.0,
                                            'estimatedTolls': double.tryParse(
                                                    widget
                                                        .homeController
                                                        .estimatedTollsControllers[
                                                            index]
                                                        .text) ??
                                                0.0,
                                            'otherCosts': double.tryParse(widget
                                                    .homeController
                                                    .otherCostsControllers[
                                                        index]
                                                    .text) ??
                                                0.0,
                                          };
                                        },
                                      ),
                                      'totalFactoringFee': widget.homeController
                                          .totalFactoringFee.value,
                                      'totalProfit': widget
                                          .homeController.totalProfit.value,
                                    },
                                  );
                                  widget.homeController
                                      .calculateVariableCosts();
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Get.to(() => ResultsScreen(
                                      homeController: widget.homeController));
                                } else {
                                  widget.homeController
                                      .calculateVariableCosts();
                                  FirebaseServices().storeCalculatedValues(
                                    totalFactoringFee: widget
                                        .homeController.totalFactoringFee.value,
                                    totalFreightCharges: widget.homeController
                                        .totalFreightCharges.value,
                                    totalDispatchedMiles: widget.homeController
                                        .totalDispatchedMiles.value,
                                    totalMileageCost: widget
                                        .homeController.totalMilageCost.value,
                                    totalProfit:
                                        widget.homeController.totalProfit.value,
                                    freightChargeControllers: widget
                                        .homeController.freightChargeControllers
                                        .map((controller) => controller.text)
                                        .toList(),
                                    dispatchedMilesControllers: widget
                                        .homeController
                                        .dispatchedMilesControllers
                                        .map((controller) => controller.text)
                                        .toList(),
                                    estimatedTollsControllers: widget
                                        .homeController
                                        .estimatedTollsControllers
                                        .map((controller) => controller.text)
                                        .toList(),
                                    otherCostsControllers: widget
                                        .homeController.otherCostsControllers
                                        .map((controller) => controller.text)
                                        .toList(),
                                    context: context,
                                    homeController: widget.homeController,
                                  );
                                  Get.snackbar(
                                    'Success',
                                    'Data submitted successfully',
                                    backgroundColor: AppColor().primaryAppColor,
                                    duration: const Duration(seconds: 2),
                                    colorText: Colors.white,
                                  );

                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Get.to(() => ResultsScreen(
                                      homeController: widget.homeController));
                                }
                              }
                            });
                          },
                          child: Text(
                            textAlign: TextAlign.center,
                            'Update',
                            style: TextStyle(
                                color: AppColor().primaryAppColor,
                                fontFamily: robotoRegular),
                          ),
                        )
                      : TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side:
                                const BorderSide(width: 1, color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            showConfirmationDialog(context, () {
                              if (formKey.currentState!.validate()) {
                                widget.homeController.calculateVariableCosts();

                                FirebaseServices().storeCalculatedValues(
                                    totalFactoringFee: widget
                                        .homeController.totalFactoringFee.value,
                                    totalFreightCharges: widget.homeController
                                        .totalFreightCharges.value,
                                    totalDispatchedMiles: widget.homeController
                                        .totalDispatchedMiles.value,
                                    totalMileageCost: widget
                                        .homeController.totalMilageCost.value,
                                    totalProfit:
                                        widget.homeController.totalProfit.value,
                                    freightChargeControllers: widget
                                        .homeController.freightChargeControllers
                                        .map((controller) => controller.text)
                                        .toList(),
                                    dispatchedMilesControllers: widget
                                        .homeController
                                        .dispatchedMilesControllers
                                        .map((controller) => controller.text)
                                        .toList(),
                                    estimatedTollsControllers: widget
                                        .homeController
                                        .estimatedTollsControllers
                                        .map((controller) => controller.text)
                                        .toList(),
                                    otherCostsControllers: widget.homeController.otherCostsControllers.map((controller) => controller.text).toList(),
                                    context: context,
                                    homeController: widget.homeController);

                                Get.snackbar(
                                  'Success',
                                  'Data submitted successfully',
                                  backgroundColor: AppColor().primaryAppColor,
                                  duration: Duration(seconds: 2),
                                  colorText: Colors.white,
                                );

                                Navigator.of(context).pop(); // Close the dialog
                                Get.to(() => ResultsScreen(
                                    homeController: widget.homeController));
                              }
                            });
                          },
                          child: Text(
                            textAlign: TextAlign.center,
                            'Submit',
                            style: TextStyle(
                                color: AppColor().primaryAppColor,
                                fontFamily: robotoRegular),
                          ),
                        ),
                ],
              ))
        ],
      ),
    );
  }
}
