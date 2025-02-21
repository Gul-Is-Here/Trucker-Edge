import 'package:flutter/gestures.dart';
import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/image_strings.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open the link",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

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
                  const SizedBox(height: 80),
                  Image.asset(
                    appLogo,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Create an Account',
                    style: TextStyle(
                      fontFamily: robotoRegular,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColor().secondaryAppColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sign up to get started!',
                    style: TextStyle(
                        fontFamily: robotoRegular,
                        fontSize: 18,
                        color: AppColor().secondaryAppColor),
                  ),
                  const SizedBox(height: 40),

                  // ✅ Name Field
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
                        borderSide:
                            BorderSide(color: AppColor().secondaryAppColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Email Field
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
                        borderSide:
                            BorderSide(color: AppColor().secondaryAppColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Phone Field
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

                  // ✅ Terms & Conditions Checkbox
                  Obx(() => Row(
                        children: [
                          Checkbox(
                            value: authController.isAgreed.value,
                            onChanged: (value) {
                              authController.isAgreed.value = value!;
                            },
                            activeColor: AppColor().primaryAppColor,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: "I agree to the ", // Normal text
                                style: TextStyle(
                                    fontFamily: robotoRegular,
                                    fontSize: 14,
                                    color: AppColor().secondaryAppColor),
                                children: [
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue, // Link color
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchURL(
                                            "https://sgsolutionsgroup.com/privacy-policy-for-trucker-edge/");
                                      },
                                  ),
                                  TextSpan(
                                    text: " and ",
                                    style: TextStyle(
                                        fontFamily: robotoRegular,
                                        fontSize: 14,
                                        color: AppColor().secondaryAppColor),
                                  ),
                                  TextSpan(
                                    text: "Terms of Service",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue, // Link color
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchURL(
                                            "https://sgsolutionsgroup.com/privacy-policy-for-trucker-edge/");
                                      },
                                  ),
                                  TextSpan(
                                    text:
                                        ". I also agree to receive SMS/OTP for verification purposes.",
                                    style: TextStyle(
                                        fontFamily: robotoRegular,
                                        fontSize: 14,
                                        color: AppColor().secondaryAppColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),

                  const SizedBox(height: 10),

                  // ✅ Register Button (Disabled Until Checkbox is Checked)
                  Obx(
                    () => authController.isLoading.value
                        ? CircularProgressIndicator(
                            color: AppColor().primaryAppColor,
                          )
                        : ElevatedButton(
                            onPressed: authController.isAgreed.value
                                ? authController.registerUser
                                : null, // ✅ Disabled if not agreed
                            style: ElevatedButton.styleFrom(
                              backgroundColor: authController.isAgreed.value
                                  ? AppColor().primaryAppColor
                                  : Colors.grey, // ✅ Disabled Button Color
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Register',
                                style: TextStyle(
                                  fontFamily: robotoRegular,
                                  fontSize: 16,
                                  color: Colors.white,
                                )),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ Already Have an Account? Login
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
