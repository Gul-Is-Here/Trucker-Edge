import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/image_strings.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      backgroundColor: AppColor().appTextColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Image.asset(
                    appLogo,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Create an Account',
                    style: TextStyle(
                      fontFamily: robotoRegular,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColor().secondaryAppColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sign up to get started!',
                    style: TextStyle(
                        fontFamily: robotoRegular,
                        fontSize: 18,
                        color: AppColor().secondaryAppColor),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    cursorColor: AppColor().secondaryAppColor,
                    controller: authController.nameController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColor().secondaryAppColor,
                        ),
                        labelText: 'Name',
                        labelStyle:
                            TextStyle(color: AppColor().secondaryAppColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: AppColor().secondaryAppColor))),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    cursorColor: AppColor().secondaryAppColor,
                    controller: authController.emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColor().secondaryAppColor,
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: AppColor().secondaryAppColor,
                            fontFamily: robotoRegular),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: AppColor().secondaryAppColor))),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: authController.phoneController,
                    cursorColor: AppColor().secondaryAppColor,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColor().secondaryAppColor,
                      ),
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(
                          color: AppColor().secondaryAppColor,
                          fontFamily: robotoRegular),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColor().secondaryAppColor,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => authController.isLoading.value
                        ? CircularProgressIndicator(
                            color: AppColor().primaryAppColor,
                          )
                        : ElevatedButton(
                            onPressed: authController.registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor().primaryAppColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Register',
                                style: TextStyle(
                                  fontFamily: robotoRegular,
                                  fontSize: 16,
                                  color: Colors.white,
                                )),
                          ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      'Already have an account? Login',
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
