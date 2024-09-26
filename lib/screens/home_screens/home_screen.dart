import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:trucker_edge/app_classes/app_class.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/controllers/home_controller.dart';
import 'package:trucker_edge/screens/history_screen/update_screen.dart';
import 'package:trucker_edge/screens/load_screen/load_screen.dart';
import 'package:trucker_edge/screens/load_screen/mileage_fee_section.dart';
import 'package:trucker_edge/widgets/card_widget.dart';
import 'package:trucker_edge/widgets/my_drawer_widget.dart';
import '../../services/firebase_services.dart';
import '../calculator_screen/calculator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final GlobalKey mileageButtonKey = GlobalKey();
  final GlobalKey truckPaymentButtonKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    homeController.fetchMileageValues();
    homeController.fetchTruckPaymentIntialValues();
    FirebaseServices().fetchIsEditabbleMilage();
    FirebaseServices().fetchIsEditabbleTruckPayment();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Confirm',
                style: TextStyle(fontFamily: robotoRegular)),
            content: const Text(
                'Are you sure you want to exit the application?',
                style: TextStyle(fontFamily: robotoRegular)),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No',
                    style: TextStyle(fontFamily: robotoRegular)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final isFirstLogin = prefs.getBool('isFirstLogin') ?? true;
      if (isFirstLogin) {
        showTutorial(context);
        await prefs.setBool('isFirstLogin', false);
      }
    });
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        drawer: MyDrawerWidget(),
        key: _scaffoldKey,
        appBar: AppBar(),
        body: SafeArea(
          child: Obx(() {
            return Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    AppClass().getGreeting(),
                    style: const TextStyle(
                      fontFamily: robotoRegular,
                      fontSize: 25,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().secondaryAppColor,
                          foregroundColor: Colors.white),
                      key: mileageButtonKey,
                      onPressed: () async {
                        final result = await Get.to(() => MileageFeSection(
                              homeController: homeController,
                              isUpdate: true,
                            ));
                        if (result == true) {
                          homeController.fetchMileageValues();
                        }
                      },
                      child: const Text('Cost Per Mile'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().secondaryAppColor,
                          foregroundColor: Colors.white),
                      key: truckPaymentButtonKey,
                      onPressed: () async {
                        final result =
                            await Get.to(() => const CalculatorScreen());
                        if (result == true) {
                          homeController.fetchTruckPaymentIntialValues();
                        }
                      },
                      child: const Text('Fixed Cost'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (homeController.fTrcukPayment.value != 0.0 &&
                    homeController.fPermileageFee.value != 0.0)
                  CardWidget(
                    onTap: () async {
                      bool documentExists = await FirebaseServices()
                          .checkIfCalculatedValuesDocumentExists();
                      if (documentExists) {
                        await FirebaseServices()
                            .firestore
                            .collection('users')
                            .doc(FirebaseServices().auth.currentUser!.uid)
                            .collection('calculatedValues')
                            .limit(1)
                            .get();
                        Get.to(() => UpdateScreen(
                            homeController: homeController, isUpdate: true));
                      } else {
                        Get.to(() => LoadScreen(
                            homeController: homeController, isUpdate: false));
                      }
                    },
                    butonText: 'Calculate',
                    cardText:
                        'This is a calculator where you can calculate your expanses',
                    cardColor: AppColor().secondaryAppColor,
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: AppColor().secondaryAppColor.withOpacity(.7),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (homeController.fPermileageFee.value == 0.0)
                              const Text(
                                "1 - Please add 'Cost Per Mile' value.",
                                style: TextStyle(
                                  fontFamily: robotoRegular,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellowAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            if (homeController.fTrcukPayment.value == 0.0)
                              const Text(
                                "2 - Please add 'Fixed Payment'.",
                                style: TextStyle(
                                  fontFamily: robotoRegular,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellowAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            );
          }),
        ),
      ),
    );
  }

  void showTutorial(BuildContext context) {
    TutorialCoachMark(
      useSafeArea: true,
      targets: _createTargets(),
      colorShadow: Colors.black,
      textSkip: "SKIP",
      paddingFocus: 0,
      opacityShadow: 0.8,
    ).show(context: context, rootOverlay: true);
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "MileageButton",
        keyTarget: mileageButtonKey,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              "Step 1: Please add cost per mile",
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: robotoRegular),
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "TruckPaymentButton",
        keyTarget: truckPaymentButtonKey,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Text(
              "Step 2: Please add fixed payment",
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: robotoRegular),
            ),
          ),
        ],
      ),
    ];
  }
}
