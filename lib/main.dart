import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';

import 'package:trucker_edge/screens/auth_screens/splash_screen.dart';
import 'package:trucker_edge/services/notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'services/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await SharedPreferences.getInstance();
    await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform)
        .then((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          AuthController().onUserAuthenticated(user);
        }
      });
    });

    await MobileAds.instance.initialize();

    // Initialize FlutterLocalNotificationsPlugin here
    await NotificationServices().initializeNotification();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  } catch (e) {
    print("Error during initialization: $e");
  }

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    await NotificationServices().initializeNotification();
    await NotificationServices().showNotification(message);
  } catch (e) {
    print("Error in background message handler: $e");
  }
}



Future<void> transferAndDeleteWeeklyData() async {
  try {
    await Firebase.initializeApp();
    await FirebaseServices().transferAndDeleteWeeklyData();
  } catch (e) {
    print("Error transferring and deleting weekly data: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dispatched Calculator',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: AppColor().primaryAppColor,
          iconTheme: AppColor().appDrawerColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontFamily: robotoRegular,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            foregroundColor: AppColor().secondaryAppColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontFamily: robotoRegular,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            foregroundColor: AppColor().secondaryAppColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        cardColor: AppColor().appTextColor,
        useMaterial3: true,
        textTheme: TextTheme(
          bodyLarge: const TextStyle(fontFamily: robotoRegular),
          bodyMedium: TextStyle(
            fontFamily: robotoRegular,
            fontSize: 12,
            color: AppColor().secondaryAppColor,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
