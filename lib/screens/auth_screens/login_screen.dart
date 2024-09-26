import 'package:trucker_edge/app_classes/app_class.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:trucker_edge/constants/image_strings.dart';
import 'package:trucker_edge/controllers/auth_controller.dart';
import 'package:trucker_edge/screens/auth_screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    return Scaffold(
    
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Image.asset(
                    appLogo,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    AppClass().getGreeting(),
                    style: TextStyle(
                      fontFamily: robotoRegular,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColor().secondaryAppColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please login with your phone number',
                    style: TextStyle(
                      fontFamily: robotoRegular,
                      fontSize: 18,
                      color: AppColor().secondaryAppColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      cursorColor: AppColor().secondaryAppColor,
                      controller: controller.phoneController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppColor().secondaryAppColor,
                          ),
                          labelText: 'Phone Number',
                          labelStyle:
                              TextStyle(color: AppColor().secondaryAppColor),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColor().secondaryAppColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColor().secondaryAppColor))),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => controller.isLoading.value
                        ? CircularProgressIndicator(
                            color: AppColor().primaryAppColor,
                          )
                        : ElevatedButton(
                            onPressed: () => controller.loginWithPhoneNumber(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor().primaryAppColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: robotoRegular,
                                fontSize: 16,
                                color: AppColor().appTextColor,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => RegisterScreen());
                    },
                    child: Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(
                        fontFamily: robotoRegular,
                        fontSize: 14,
                        color: AppColor().secondaryAppColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
