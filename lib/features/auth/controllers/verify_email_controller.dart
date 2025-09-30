import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/utills/helper/snackbar_helper.dart';

import '../../../core/constant/api_endpoin.dart';
import '../../../core/constant/enum.dart';
import '../../../core/validator/email_validator.dart';
import '../../../routes/routes_name.dart';

class VerifyEmailController extends GetxController {

  final TextEditingController emailController = TextEditingController();
  RxBool isLoading = false.obs;

  void passwordResetRequest() async {
    isLoading.value = true;

    if (emailController.text.isEmpty) {
      SnackbarHelper.info('Please enter your email', Get.context!);
      isLoading.value = false;
      return;
    }
    if (!EmailValidator.isValid(emailController.text)) {
      SnackbarHelper.info('Please enter a valid email', Get.context!);
      isLoading.value = false;
      return;
    }
    try{
      final response = await http.post(
        Uri.parse(ApiEndpoint.passwordResetRequest),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
        }),
      );

      print('Response status for email verify: ${response.statusCode} and body: ${response.body}');

      if (response.statusCode == 200) {
        SnackbarHelper.success('OTP sent to your email', Get.context!);
        Get.toNamed(RouteName.verifyCode, arguments: {
          'email': emailController.text,
          'type': VerificationType.passwordReset,

        });
        emailController.clear();
        isLoading.value = false;
      } else {
        SnackbarHelper.error('Failed to send OTP. Please try again.', Get.context!);
        isLoading.value = false;
      }
    }catch(e){
      print('Error: $e');
      isLoading.value = false;
    }
  }
}