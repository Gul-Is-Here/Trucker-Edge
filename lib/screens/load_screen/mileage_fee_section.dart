import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/colors.dart';
import '../../constants/fonts_strings.dart';
import '../../controllers/home_controller.dart';
import '../../services/firebase_services.dart';
import '../../widgets/customized_row_mileage.dart';
import '../../widgets/my_drawer_widget.dart';

class MileageFeSection extends StatefulWidget {
  final HomeController homeController;
  final bool isUpdate;

  const MileageFeSection(
      {super.key, required this.homeController, required this.isUpdate});

  @override
  _MileageFeSectionState createState() => _MileageFeSectionState();
}

class _MileageFeSectionState extends State<MileageFeSection> {
  final formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  void initializeControllers() async {
    var fetchedValues = await FirebaseServices().fetchPerMileageAmount();
    if (!mounted) return;
    widget.homeController.perMileageFeeController.text =
        fetchedValues['milageFeePerMile'].toString();
    widget.homeController.perMileFuelController.text =
        fetchedValues['fuelFeePerMile'].toString();
    widget.homeController.perMileDefController.text =
        fetchedValues['defFeePerMile'].toString();
    widget.homeController.perMileDriverPayController.text =
        fetchedValues['driverPayFeePerMile'].toString();
  }

  Future<void> submitForm() async {
    if (formKey1.currentState!.validate()) {
      widget.homeController.isLoading.value = true;
      await FirebaseServices().storePerMileageAmount(
        isEditabbleMilage: widget.homeController.isEditableMilage.value,
        perMileFee: double.tryParse(
                widget.homeController.perMileageFeeController.text) ??
            0.0,
        perMileFuel:
            double.tryParse(widget.homeController.perMileFuelController.text) ??
                0.0,
        perMileDef:
            double.tryParse(widget.homeController.perMileDefController.text) ??
                0.0,
        perMileDriverPay: double.tryParse(
                widget.homeController.perMileDriverPayController.text) ??
            0.0,
      );
      widget.homeController.isLoading.value = false;
      widget.homeController.isEditableMilage.value = false;
      await FirebaseServices().toggleIsEditabbleMilage();
      bool updatedIsEditableMilage =
          await FirebaseServices().fetchIsEditabbleMilage();
      if (!mounted) return;
      widget.homeController.isEditableMilage.value = updatedIsEditableMilage;
      initializeControllers();
      if (!mounted) return;
      Navigator.pop(context, true); // Pass a result indicating success
    }
  }

  Future<void> showSubmitConfirmationDialog(BuildContext context) async {
    bool? shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Submission'),
        content: const Text('Are you sure you want to submit the data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'No',
              style: TextStyle(color: Colors.red, fontFamily: robotoRegular),
            ),
          ),
          TextButton(
            onPressed: () {
              submitForm();
              widget.homeController.updatedIsEditableMilage.value = false;
              widget.homeController.isEditableMilage.value =
                  widget.homeController.updatedIsEditableMilage.value;

              Get.back(result: true);
            },
            child: Text(
              'Yes',
              style: TextStyle(
                  color: AppColor().primaryAppColor, fontFamily: robotoRegular),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showEditConfirmationDialog(BuildContext context) async {
    bool? shouldEdit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Edit'),
        content: const Text('Are you sure you want to edit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'No',
              style: TextStyle(color: Colors.red, fontFamily: robotoRegular),
            ),
          ),
          TextButton(
            onPressed: () async {
              bool documentExists = await FirebaseServices()
                  .checkIfCalculatedValuesDocumentExists();

              if (documentExists) {
                await FirebaseServices().transferAndDeleteWeeklyData();
              }

              widget.homeController.isEditableMilage.value = false;
              await FirebaseServices().toggleIsEditabbleMilage();
              widget.homeController.updatedIsEditableMilage.value =
                  await FirebaseServices().fetchIsEditabbleMilage();
              widget.homeController.isEditableMilage.value =
                  widget.homeController.updatedIsEditableMilage.value;
              Future.delayed((const Duration(seconds: 3)));
              Navigator.of(context).pop(true);
            },
            child: Text(
              'Yes',
              style: TextStyle(
                  color: AppColor().primaryAppColor, fontFamily: robotoRegular),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (widget.homeController.isEditableMilage.value) {
      bool? shouldLeave = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text('Please submit the data before leaving.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'OK',
                style: TextStyle(
                    color: AppColor().secondaryAppColor,
                    fontFamily: robotoRegular),
              ),
            ),
          ],
        ),
      );
      return shouldLeave ?? false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: widget.homeController.isEditableMilage.value == true
              ? null
              : MyDrawerWidget(),
          appBar: AppBar(),
          body: Obx(
            () => Stack(
              children: [
                // 20.heightBox,
                if (widget.homeController.isLoading.value)
                  Center(
                    child: CircularProgressIndicator(
                      color: AppColor().primaryAppColor,
                    ),
                  ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Form(
                        key: formKey1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Cost Per Mile',
                                    style: TextStyle(
                                      fontFamily: robotoRegular,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      onPressed: () {
                                        showEditConfirmationDialog(context);
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              buildRowForMileage(
                                intialValue: widget
                                    .homeController.fPermileageFee.value
                                    .toString(),
                                label: 'Mileage Fee (\$/mile)',
                                hint: 'e.g., \$0.50',
                                controller: widget
                                    .homeController.perMileageFeeController,
                                value: widget.homeController.fPermileageFee,
                                validator: widget.homeController.validateInput,
                                isEnable: widget.homeController
                                    .updatedIsEditableMilage.value,
                              ),
                              buildRowForMileage(
                                intialValue: widget
                                    .homeController.fPerMileFuel.value
                                    .toString(),
                                label: 'Fuel (\$/mile)',
                                hint: 'e.g., \$0.20',
                                controller:
                                    widget.homeController.perMileFuelController,
                                value: widget.homeController.fPerMileFuel,
                                validator: widget.homeController.validateInput,
                                isEnable: widget.homeController
                                    .updatedIsEditableMilage.value,
                              ),
                              buildRowForMileage(
                                intialValue: widget
                                    .homeController.fPerMileDef.value
                                    .toString(),
                                label: 'DEF (\$/mile)',
                                hint: 'e.g., \$0.05',
                                controller:
                                    widget.homeController.perMileDefController,
                                value: widget.homeController.fPerMileDef,
                                validator: widget.homeController.validateInput,
                                isEnable: widget.homeController
                                    .updatedIsEditableMilage.value,
                              ),
                              buildRowForMileage(
                                intialValue: widget
                                    .homeController.fPerMileDriverPay.value
                                    .toString(),
                                label: 'Driver Pay (\$/mile)',
                                hint: 'e.g., \$0.30',
                                controller: widget
                                    .homeController.perMileDriverPayController,
                                value: widget.homeController.fPerMileDriverPay,
                                validator: widget.homeController.validateInput,
                                isEnable: widget.homeController
                                    .updatedIsEditableMilage.value,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    Obx(
                      () => widget.homeController.isEditableMilage.value
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor().primaryAppColor,
                                foregroundColor: AppColor().appTextColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            .36),
                              ),
                              onPressed: () {
                                showSubmitConfirmationDialog(context);
                              },
                              child: const Text('Submit'),
                            )
                          : Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
