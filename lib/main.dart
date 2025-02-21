import 'dart:async'; // ✅ Import Timer
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/screens/auth_screens/splash_screen.dart';
import 'package:trucker_edge/services/firebase_services.dart';
import 'package:trucker_edge/services/notification_services.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    await SharedPreferences.getInstance();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        AuthController().onUserAuthenticated(user);
      }
    });

    // Initialize local notifications
    await NotificationServices().initializeNotification();

    // Listen for Firebase background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Restrict app orientation to portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // ✅ Check for missed executions on app start
    checkAndTriggerMissedMondays();

    // ✅ Start a timer that checks every hour
    Timer.periodic(Duration(hours: 1), (timer) {
      checkAndTriggerMissedMondays();
    });
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

// ✅ Function to check and execute data transfer for missed Mondays
Future<void> checkAndTriggerMissedMondays() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  DateTime now = DateTime.now();
  int lastExecutionTimestamp = prefs.getInt('lastExecution') ?? 0;
  DateTime lastExecutionDate =
      DateTime.fromMillisecondsSinceEpoch(lastExecutionTimestamp);

  // Find the most recent Monday before or on today
  DateTime lastMissedMonday = findLastMissedMonday(now);

  // If last execution was before this Monday, run the function
  if (lastExecutionDate.isBefore(lastMissedMonday)) {
    print(
        "✅ Running Weekly Data Transfer for Missed Monday: $lastMissedMonday");
    await transferAndDeleteWeeklyData();

    // Update last execution timestamp in SharedPreferences
    await prefs.setInt(
        'lastExecution', lastMissedMonday.millisecondsSinceEpoch);
  } else {
    print("🕒 Last execution was recent. No missed Mondays found.");
  }
}

// ✅ Function to find the most recent Monday at 6 AM
DateTime findLastMissedMonday(DateTime now) {
  DateTime lastMonday =
      now.subtract(Duration(days: (now.weekday - DateTime.monday) % 7));
  return DateTime(lastMonday.year, lastMonday.month, lastMonday.day, 6, 0);
}

// ✅ Function to execute weekly data transfer
Future<void> transferAndDeleteWeeklyData() async {
  try {
    await Firebase.initializeApp();
    await FirebaseServices().transferAndDeleteWeeklyData();
    print("✅ Weekly data transfer completed!");
  } catch (e) {
    print("❌ Error transferring and deleting weekly data: $e");
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
        scaffoldBackgroundColor: AppColor().appTextColor,
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
