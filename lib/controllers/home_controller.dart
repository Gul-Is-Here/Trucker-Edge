import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trucker_edge/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/firebase_services.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool updatedIsEditableMilage = false.obs;
  RxBool updatedIsEditableTruckPayment = false.obs;
  var weeklyTruckPayment = 0.0.obs;
  var weeklyInsurance = 0.0.obs;
  var weeklyTrailerLease = 0.0.obs;
  var weeklyEldService = 0.0.obs;
  var weeklyoverHeadAmount = 0.0.obs;
  var weeklyOtherCost = 0.0.obs;
  var weeklyFixedCost = 0.0.obs;
  var weeklyTrailerRental = 0.0.obs;
  var weeklyOtherExpenses = 0.0.obs;
  RxDouble weeklyTotalMileageFee = 0.0.obs;
  RxDouble weeklyTotalFuel = 0.0.obs;
  RxDouble weeklyTotalDef = 0.0.obs;
  RxDouble weeklyTotalDriverPay = 0.0.obs;
  RxDouble weeklyTotalCostPerMile = 0.0.obs;
  RxDouble fPermileageFee = 0.0.obs;
  RxDouble fPerMileFuel = 0.0.obs;
  RxDouble fPerMileDef = 0.0.obs;
  RxDouble fPerMileDriverPay = 0.0.obs;
  // RxBool isEditable = true.obs;
  RxBool isEditableTruckPayment = false.obs;
  RxBool isEditableMilage = false.obs;
  RxDouble totalWeeklyFixedCost = 0.0.obs;
  final tTruckPaymentController = TextEditingController();
  final tInsuranceController = TextEditingController();
  final tTrailerLeaseController = TextEditingController();
  final tEldServicesController = TextEditingController();
  final tOverHeadController = TextEditingController();
  final tOtherController = TextEditingController();

  final perMileageFeeController = TextEditingController();
  final perMileFuelController = TextEditingController();
  final perMileDefController = TextEditingController();
  final perMileDriverPayController = TextEditingController();
  final factoringFeeController = TextEditingController();

  var freightChargeControllers = <TextEditingController>[].obs;
  var dispatchedMilesControllers = <TextEditingController>[].obs;
  var estimatedTollsControllers = <TextEditingController>[].obs;
  var otherCostsControllers = <TextEditingController>[].obs;
  RxList<Map<String, dynamic>> historyData = <Map<String, dynamic>>[].obs;

  // Loads controller save value in variables
  RxDouble freightCharge = 0.0.obs;
  RxDouble dispatchedMiles = 0.0.obs;
  RxDouble estimatedTolls = 0.0.obs;
  RxDouble otherCost = 0.0.obs;

  RxDouble totalFrightChargesAndTolls = 0.0.obs;
  RxDouble totalMilageCost = 0.0.obs;
  RxDouble totalProfit = 0.0.obs;
  RxDouble totalFreightCharges = 0.0.obs;
  RxDouble totalEstimatedTollsCost = 0.0.obs;
  RxDouble totalOtherCost = 0.0.obs;
  RxDouble totalFactoringFee = 0.0.obs;
  RxDouble totalDispatchedMiles = 0.0.obs;

  var permileageFee = 0.0.obs;
  var perMileFuel = 0.0.obs;
  var perMileDef = 0.0.obs;
  var perMileDriverPay = 0.0.obs;
  Rx<DateTime?> timestamp = Rx<DateTime?>(null);

//--------Truck Payment Fetch Values to Show TextformField In calculator Screen-------
  RxDouble fTrcukPayment = 0.0.obs;
  RxDouble fTrcukInsurace = 0.0.obs;
  RxDouble fTrcukTrailerLease = 0.0.obs;
  RxDouble fTrcukEldService = 0.0.obs;
  RxDouble fTrcukOverhead = 0.0.obs;
  RxDouble fTrcukOther = 0.0.obs;
  RxDouble fTruckWeeklyPayment = 0.0.obs;
  RxDouble fTruckWeeklyInsurance = 0.0.obs;
  RxDouble fTruckWeeklyTrailerLease = 0.0.obs;
  RxDouble fTruckWeeklyEldServices = 0.0.obs;
  NotificationServices notifications = NotificationServices();
  @override
  void onInit() {
    super.onInit();
    notifications.requestNotificationPermission();
    notifications.getDeviceToken().then((value) {
      print('Device token');
      print(value);
    });
    tTruckPaymentController.addListener(_calculateFixedCost);
    tInsuranceController.addListener(_calculateFixedCost);
    tTrailerLeaseController.addListener(_calculateFixedCost);
    tEldServicesController.addListener(_calculateFixedCost);
    tOverHeadController.addListener(_calculateFixedCost);
    tOtherController.addListener(_calculateFixedCost);
    weeklyFixedCost.addListener;
    fTrcukPayment.addListener;
    fPermileageFee.addListener;

    addNewLoad(); // Initialize with the first load
    // fetchHistoryData(); // Fetch data from Firebase
    FirebaseServices().fetchPerMileageAmount(); // Fetch per-mile cost
    FirebaseServices().fetchFixedWeeklyCost(); // Fetch weekly fixed costs
    fetchMileageValues(); //  This Method is Used To fetch Intial Values of Trcuk Per Mileage fee Payments in Mileage Screen
    fetchTruckPaymentIntialValues(); // This Method is Used To fetch Intial Values of Trcuk monthly Payments in Calculator Screen
    FirebaseServices().fetchIsEditabbleMilage();
    FirebaseServices().fetchIsEditabbleTruckPayment();
  }

  // void fetchInitialValues() async {
  //   fTrcukPayment.value =  fetchMileageValues() as double;
  //   fPermileageFee.value = await FirebaseServices().fetchMileageValues();
  // }

  @override
  void onClose() {
    for (var controller in freightChargeControllers) {
      controller.dispose();
    }
    for (var controller in dispatchedMilesControllers) {
      controller.dispose();
    }
    for (var controller in estimatedTollsControllers) {
      controller.dispose();
    }
    for (var controller in otherCostsControllers) {
      controller.dispose();
    }

    super.onClose();
  }

  ///-----------------------------------------------------------------------------------------
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Must be filled!';
    } else if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    } else if (double.parse(value) < 0) {
      return 'Cannot enter negative value';
    }
    return null;
  }

  // For non-null value only use in other costs and overhead costs
  String? validateNonNegative(String? value) {
    if (value == null || value.isEmpty) {
      return null; // No validation needed for empty values
    } else if (double.tryParse(value) == null) {
      return 'Enter a valid number';
    } else if (double.parse(value) < 0) {
      return 'Value must be positive';
    }
    return null; // No errors
  }

  void _calculateFixedCost() async {
    // Get the monthly amounts from the input fields
    double truckPaymentAmount =
        double.tryParse(tTruckPaymentController.text) ?? 0;
    double truckInsuranceAmount =
        double.tryParse(tInsuranceController.text) ?? 0;
    double trailerLeaseAmount =
        double.tryParse(tTrailerLeaseController.text) ?? 0;
    double eldService = double.tryParse(tEldServicesController.text) ?? 0;
    double overHeadAmount = double.tryParse(tOverHeadController.text) ?? 0;
    double otherAmount = double.tryParse(tOtherController.text) ?? 0;

    // Calculate weekly values from monthly amounts
    weeklyTruckPayment.value = (truckPaymentAmount * 12) / 52;
    weeklyInsurance.value = (truckInsuranceAmount * 12) / 52;
    weeklyTrailerLease.value = (trailerLeaseAmount * 12) / 52;
    weeklyEldService.value = (eldService * 12) / 52;
    weeklyoverHeadAmount.value = (overHeadAmount * 12) / 52;
    weeklyOtherCost.value = (otherAmount * 12) / 52;

    // Calculate the total weekly fixed cost from the individual weekly costs
    weeklyFixedCost.value = weeklyTruckPayment.value +
        weeklyInsurance.value +
        weeklyTrailerLease.value +
        weeklyEldService.value +
        weeklyoverHeadAmount.value +
        weeklyOtherCost.value;
  }

  //------------------->Truck Weekly Fixed Cost Value <----------------------
  Future<void> updateFixedCosts() async {
    Map<String, double> weeklyFixedCosts =
        await FirebaseServices().fetchFixedWeeklyCost();

    weeklyTruckPayment.value =
        weeklyFixedCosts['monthlyTruckPayment'] ?? weeklyTruckPayment.value;
    weeklyInsurance.value =
        weeklyFixedCosts['monthlyTruckInsurance'] ?? weeklyInsurance.value;
    weeklyTrailerLease.value =
        weeklyFixedCosts['monthlyTrailerLease'] ?? weeklyTrailerLease.value;
    weeklyEldService.value =
        weeklyFixedCosts['monthlyEldService'] ?? weeklyEldService.value;
    weeklyoverHeadAmount.value =
        weeklyFixedCosts['monthlyOverheadCost'] ?? weeklyoverHeadAmount.value;
    weeklyOtherCost.value =
        weeklyFixedCosts['monthlyOtherCost'] ?? weeklyOtherCost.value;

    totalWeeklyFixedCost.value =
        weeklyFixedCosts['weeklyFixedCost'] ?? weeklyFixedCost.value;
    weeklyFixedCost.value = weeklyTruckPayment.value +
        weeklyInsurance.value +
        weeklyTrailerLease.value +
        weeklyEldService.value +
        weeklyoverHeadAmount.value +
        weeklyOtherCost.value;
  }

  void calculateVariableCosts() async {
    // Initialize totals
    totalFreightCharges.value = 0.0;
    totalDispatchedMiles.value = 0.0;
    totalEstimatedTollsCost.value = 0.0;
    totalOtherCost.value = 0.0;
    // Calculate totals from controllers
    for (int i = 0; i < freightChargeControllers.length; i++) {
      freightCharge.value =
          double.tryParse(freightChargeControllers[i].text) ?? 0.0;
      dispatchedMiles.value =
          double.tryParse(dispatchedMilesControllers[i].text) ?? 0.0;
      estimatedTolls.value =
          double.tryParse(estimatedTollsControllers[i].text) ?? 0.0;
      otherCost.value = double.tryParse(otherCostsControllers[i].text) ?? 0.0;

      totalFreightCharges.value += freightCharge.value;
      totalDispatchedMiles.value += dispatchedMiles.value;
      totalEstimatedTollsCost.value += estimatedTolls.value;
      totalOtherCost.value += otherCost.value;
    }
    Map<String, dynamic> weeklyFixedCosts =
        await FirebaseServices().fetchFixedWeeklyCost();

    // Update with fetched values
    weeklyTruckPayment.value =
        weeklyFixedCosts['weeklyTruckPayment'] ?? weeklyTruckPayment.value;
    weeklyInsurance.value =
        weeklyFixedCosts['weeklyInsurancePayment'] ?? weeklyInsurance.value;
    weeklyTrailerLease.value =
        weeklyFixedCosts['weeklyTrailerLease'] ?? weeklyTrailerLease.value;
    weeklyEldService.value =
        weeklyFixedCosts['weeklyEldService'] ?? weeklyEldService.value;
    weeklyoverHeadAmount.value =
        weeklyFixedCosts['monthlyOverheadCost'] ?? weeklyoverHeadAmount.value;
    weeklyOtherCost.value =
        weeklyFixedCosts['monthlyOtherCost'] ?? weeklyOtherCost.value;
    totalWeeklyFixedCost.value = weeklyFixedCosts['weeklyFixedCost'];
    // Fetch per-mile costs from Firebase
    Map<String, double> perMileageCosts =
        await FirebaseServices().fetchPerMileageAmount();
    permileageFee.value = perMileageCosts['milageFeePerMile'] ?? 0.0;
    perMileFuel.value = perMileageCosts['fuelFeePerMile'] ?? 0.0;
    perMileDef.value = perMileageCosts['defFeePerMile'] ?? 0.0;
    perMileDriverPay.value = perMileageCosts['driverPayFeePerMile'] ?? 0.0;

    // Calculate total factoring fee
    totalFactoringFee.value = (totalFreightCharges.value * 2) / 100;

    // Calculate total mileage cost
    totalMilageCost.value = (permileageFee.value * totalDispatchedMiles.value) +
        (perMileFuel.value * totalDispatchedMiles.value) +
        (perMileDef.value * totalDispatchedMiles.value) +
        ((perMileDriverPay.value * totalDispatchedMiles.value) * 1.2) +
        totalFactoringFee.value;
    totalProfit.value = totalFreightCharges.value -
        totalWeeklyFixedCost.value -
        totalMilageCost.value -
        totalEstimatedTollsCost.value -
        totalOtherCost.value;
    print('total freight ${totalFreightCharges.value}');
    print('total totalWeeklyFixedCost ${totalWeeklyFixedCost.value}');
    print('total totalMilageCost ${totalMilageCost.value}');
    print('total totalEstimatedTollsCost ${totalEstimatedTollsCost.value}');
    print('total totalOtherCost ${totalOtherCost.value}');
  }

  void addNewLoad() {
    var freightChargeController = TextEditingController();
    var dispatchedMilesController = TextEditingController();
    var estimatedTollsController = TextEditingController();
    var otherCostsController = TextEditingController();

    freightChargeController.addListener(calculateVariableCosts);
    dispatchedMilesController.addListener(calculateVariableCosts);
    estimatedTollsController.addListener(calculateVariableCosts);
    otherCostsController.addListener(calculateVariableCosts);

    freightChargeControllers.add(freightChargeController);
    dispatchedMilesControllers.add(dispatchedMilesController);
    estimatedTollsControllers.add(estimatedTollsController);
    otherCostsControllers.add(otherCostsController);
  }

  void removeLoad(int index) {
    if (freightChargeControllers.length > 1) {
      freightChargeControllers.removeAt(index);
      dispatchedMilesControllers.removeAt(index);
      estimatedTollsControllers.removeAt(index);
      otherCostsControllers.removeAt(index);
    }
  }

  void clearLoadFields() {
    for (var controller in estimatedTollsControllers) {
      controller.clear();
    }
    for (var controller in otherCostsControllers) {
      controller.clear();
    }
  }

  // void fetchHistoryData() async {
  //   User? user = FirebaseServices().auth.currentUser;
  //   if (user != null) {
  //     QuerySnapshot querySnapshot = await FirebaseServices()
  //         .firestore
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('calculatedValues')
  //         .get();

  //     // Process the data from the querySnapshot as needed
  //     // For example, convert it to a list of entries
  //     List<DocumentSnapshot> documents = querySnapshot.docs;
  //     // Update your state with the new data
  //     print('Fetched ${documents.length} documents.');
  //   } else {
  //     print('Error: No user is currently logged in.');
  //   }
  // }

  void fetchTruckPaymentIntialValues() async {
    Map<String, double> weeklyFixedCosts =
        await FirebaseServices().fetchFixedWeeklyCost();
    fTrcukPayment.value =
        weeklyFixedCosts['monthlyTruckPayment'] ?? fTrcukPayment.value;
    fTrcukInsurace.value =
        weeklyFixedCosts['monthlyTruckInsurance'] ?? weeklyInsurance.value;
    fTrcukTrailerLease.value =
        weeklyFixedCosts['monthlyTrailerLease'] ?? weeklyTrailerLease.value;
    fTrcukEldService.value =
        weeklyFixedCosts['monthlyEldService'] ?? weeklyEldService.value;
    fTrcukOverhead.value =
        weeklyFixedCosts['monthlyOverheadCost'] ?? weeklyoverHeadAmount.value;
    fTrcukOther.value =
        weeklyFixedCosts['monthlyOtherCost'] ?? weeklyOtherCost.value;

    totalWeeklyFixedCost.value =
        weeklyFixedCosts['weeklyFixedCost'] ?? weeklyFixedCost.value;

    fTruckWeeklyPayment.value =
        weeklyFixedCosts['weeklyTruckPayment'] ?? fTruckWeeklyPayment.value;
    fTruckWeeklyTrailerLease.value = weeklyFixedCosts['weeklyTrailerLease'] ??
        fTruckWeeklyTrailerLease.value;
    fTruckWeeklyInsurance.value = weeklyFixedCosts['weeklyInsurancePayment'] ??
        fTruckWeeklyInsurance.value;
    fTruckWeeklyEldServices.value =
        weeklyFixedCosts['weeklyEldService'] ?? fTruckWeeklyEldServices.value;
    checkTrcukControllerValues();
  }

  // Method To check if Trcuk Monthly Payment Controllers are Empty then show these values

  void checkTrcukControllerValues() {
    print('Call Successfully');
    if (tTruckPaymentController.text.isEmpty ||
        tEldServicesController.text.isEmpty ||
        tInsuranceController.text.isEmpty ||
        tTrailerLeaseController.text.isEmpty ||
        tOverHeadController.text.isEmpty ||
        tOtherController.text.isEmpty) {
      tTruckPaymentController.text = fTrcukPayment.value.toString();
      tEldServicesController.text = fTrcukEldService.value.toString();
      tInsuranceController.text = fTrcukInsurace.value.toString();
      tTrailerLeaseController.text = fTrcukTrailerLease.value.toString();
      tOverHeadController.text = fTrcukOverhead.value.toString();
      tOtherController.text = fTrcukOther.value.toString();
    } else {
      return;
    }
  }

  // ---------------------- Fetch Milage Values------------------

  Future<void> fetchMileageValues() async {
    isLoading.value = true;
    try {
      Map<String, double> mileageValues =
          await FirebaseServices().fetchPerMileageAmount();
      // Update the Rx variables with the fetched values
      fPermileageFee.value =
          mileageValues['milageFeePerMile'] ?? fPermileageFee.value;
      fPerMileFuel.value =
          mileageValues['fuelFeePerMile'] ?? fPerMileFuel.value;
      fPerMileDef.value = mileageValues['defFeePerMile'] ?? fPerMileDef.value;
      fPerMileDriverPay.value =
          mileageValues['driverPayFeePerMile'] ?? fPerMileDriverPay.value;

      // Update the text controllers with the fetched values
      perMileageFeeController.text = fPermileageFee.value.toStringAsFixed(2);
      perMileFuelController.text = fPerMileFuel.value.toStringAsFixed(2);
      perMileDefController.text = fPerMileDef.value.toStringAsFixed(2);
      perMileDriverPayController.text =
          fPerMileDriverPay.value.toStringAsFixed(2);
      checkPerMileageFee();
    } catch (e) {
      print('Error fetching mileage values: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void checkPerMileageFee() {
    print('call');
    if (perMileageFeeController.text.isEmpty) {
      perMileageFeeController.text = fPermileageFee.value.toString();
      print(perMileDefController.text);
    }
    if (perMileFuelController.text.isEmpty) {
      perMileFuelController.text = fPerMileFuel.value.toString();
    }
    if (perMileDefController.text.isEmpty) {
      perMileDefController.text = fPerMileDef.value.toString();
    }
    if (perMileDriverPayController.text.isEmpty) {
      perMileDriverPayController.text = fPerMileDriverPay.value.toString();
    }
  }
}
