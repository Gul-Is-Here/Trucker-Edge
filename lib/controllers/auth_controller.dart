import 'package:trucker_edge/constants/colors.dart';
import 'package:trucker_edge/services/firebase_services.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/auth_screens/login_screen.dart';
import '../screens/auth_screens/otp_verification_screen.dart';
import '../screens/auth_screens/otpverification_login.dart';
import '../screens/home_screens/home_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var verificationId = ''.obs;
  var isLoading = false.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Ensure the phone number is in the correct format with the country code +1 for USA
  String _formatPhoneNumber(String phone) {
    return '+1$phone';
  }

  void registerUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _formatPhoneNumber(phone),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _registerUserWithCredential(credential, name, email, phone);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', 'Verification failed: ${e.message}',
              snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          Get.to(() => OTPVerificationScreen(
                verificationId: verificationId,
                email: email,
                name: name,
                phone: phone,
              ));
          isLoading.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }

  void loginWithPhoneNumber() async {
    String phone = phoneController.text.trim();

    if (phone.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number',
          colorText: AppColor().appTextColor,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM);

      return;
    }

    isLoading.value = true;

    try {
      QuerySnapshot userQuery = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (userQuery.docs.isNotEmpty) {
        await _auth.verifyPhoneNumber(
          phoneNumber: _formatPhoneNumber(phone),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            Get.offAll(() => const HomeScreen());
          },
          verificationFailed: (FirebaseAuthException e) {
            Get.snackbar('Error', 'Verification failed: ${e.message}',
                snackPosition: SnackPosition.BOTTOM);
            isLoading.value = false;
          },
          codeSent: (String verificationId, int? resendToken) {
            this.verificationId.value = verificationId;
            Get.to(() => OTPVerificationLoginScreen(
                  verificationId: verificationId,
                  phone: phone,
                ));
            isLoading.value = false;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            this.verificationId.value = verificationId;
          },
        );
      } else {
        Get.snackbar('Error', 'Phone number does not exist',
            snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }

  void verifyOTP(String otp, {required bool isLogin}) async {
    if (otp.isEmpty) {
      Get.snackbar('Error', 'Please enter the OTP',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otp,
      );

      if (isLogin) {
        await _auth.signInWithCredential(credential);
        Get.offAll(() => const HomeScreen());
      } else {
        await _registerUserWithCredential(
          credential,
          nameController.text.trim(),
          emailController.text.trim(),
          phoneController.text.trim(),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    }
  }

  void onUserAuthenticated(User user) {}
  Future<void> _registerUserWithCredential(PhoneAuthCredential credential,
      String name, String email, String phone) async {
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'name': name,
      'email': email,
      'phone': phone,
    });
    Get.snackbar('Success', 'Registration successful',
        snackPosition: SnackPosition.BOTTOM);
    FirebaseServices().saveUserToken();
    FirebaseServices().setupTokenRefreshListener();
    Get.offAll(() => const HomeScreen());
    isLoading.value = false;
  }

  void signOut() async {
    phoneController.clear();
    emailController.clear();
    nameController.clear();

    try {
      await _auth.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  

  // Method to get the current user UID
  String? getCurrentUserUID() {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }
}
