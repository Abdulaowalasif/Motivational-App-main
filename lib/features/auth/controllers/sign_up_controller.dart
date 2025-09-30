import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constant/api_endpoin.dart';
import '../../../core/constant/enum.dart';
import '../../../core/utills/helper/snackbar_helper.dart';
import '../../../core/validator/email_validator.dart';
import '../../../core/validator/password_validator.dart';
import '../views/verify_code.dart';

class SignUpController extends GetxController{

  RxBool isLoading = false.obs;

  void signUp(String name, String email, String phone, String password, String confirmPassword) async {
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      SnackbarHelper.info('Please fill all fields',Get.context!);
      return;
    }
    if (password != confirmPassword) {
      SnackbarHelper.info('Passwords do not match',Get.context!);
      return;
    }
    if (!EmailValidator.isValid(email)) {
      SnackbarHelper.info('Invalid email address',Get.context!);
      return;
    }
    if (!PasswordValidator.isValid(password)) {
      SnackbarHelper.info(
          'Password must be at least 8 characters long, contain uppercase and lowercase letters, numbers, and special characters.'
          ,Get.context!);
      return;
    }

    final fullName = name.trim();
    final nameParts = fullName.split(' ');
    final firstName = nameParts[0];
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoint.register),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone_number': phone,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );
      print('Response Status for Sign Up: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        SnackbarHelper.success(responseData['message'] ?? 'Sign up successful',Get.context!);
        Get.to(VerifyCode(), arguments: {
          'email': email,
          'type': VerificationType.registration,
        });
      } else {
        print('Sign up failed: ${response.statusCode}');
        SnackbarHelper.error(
            'Sign up failed: ${response.statusCode} - ${response.body}',Get.context!
        );
      }
    } catch (e) {
      SnackbarHelper.error('Network error: ${e.toString()}',Get.context!);
    }
  }

}