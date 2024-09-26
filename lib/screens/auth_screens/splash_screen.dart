import 'package:trucker_edge/controllers/home_controller.dart';

import 'package:trucker_edge/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trucker_edge/constants/image_strings.dart';
import 'package:trucker_edge/screens/auth_screens/login_screen.dart';
import 'package:trucker_edge/screens/home_screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    FirebaseServices().fetchIsEditabbleTruckPayment();
    FirebaseServices().fetchIsEditabbleMilage();
    _navigateToNextScreen();
    
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    User? user = _auth.currentUser;
    if (user != null) {
      Get.offAll(
          () => const HomeScreen()); // User is signed in, navigate to home screen
    } else {
      Get.offAll(() =>
       
          const LoginScreen()); // No user is signed in, navigate to login screen
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
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
    // NotificationServices().firebaseInit(context);

    return PopScope(
      onPopInvoked: (didPop) {
        _onWillPop();
      },
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                appLogo,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
