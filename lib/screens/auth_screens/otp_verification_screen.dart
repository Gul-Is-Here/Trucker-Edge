import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/constants/fonts_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../controllers/auth_controller.dart';

class OTPVerificationScreen extends StatelessWidget {
  final String verificationId;
  final String email;
  final String name;
  final String phone;

  OTPVerificationScreen({
    super.key,
    required this.verificationId,
    required this.email,
    required this.name,
    required this.phone,
  });

  final AuthController authController = Get.find();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  void verifyOTP() {
    String otp =
        _otpControllers.map((controller) => controller.text.trim()).join();
    authController.verifyOTP(otp, isLogin: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontFamily: robotoRegular,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Enter the OTP sent to your phone number',
                  style: TextStyle(
                    fontFamily: robotoRegular,
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * .14,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        cursorColor: AppColor().primaryAppColor,
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColor().secondaryAppColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColor().secondaryAppColor),
                            ),
                            focusColor: AppColor().primaryAppColor),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 20),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) {
                          if (value.length == 1 && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          } else if (value.length == 1 && index == 5) {
                            _focusNodes[index].unfocus();
                          } else if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              Obx(() => authController.isLoading.value
                  ? CircularProgressIndicator(
                      color: AppColor().secondaryAppColor,
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: AppColor().appTextColor,
                          backgroundColor: AppColor().primaryAppColor),
                      onPressed: verifyOTP,
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(color: AppColor().appTextColor),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
