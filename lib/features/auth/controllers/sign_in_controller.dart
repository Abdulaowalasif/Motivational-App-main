import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constant/api_endpoin.dart';
import '../../../core/utills/helper/snackbar_helper.dart';
import '../../../core/utills/local_storage/user_info.dart';
import '../../../core/utills/local_storage/user_status.dart';
import '../../../core/validator/email_validator.dart';
import '../../../core/validator/password_validator.dart';
import '../../../routes/routes_name.dart';

class SignInController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;

    if (email.isEmpty || password.isEmpty) {
      SnackbarHelper.info('Please fill in all fields', Get.context ?? Get.overlayContext!);
      isLoading.value = false;
      return;
    }
    if (!EmailValidator.isValid(email)) {
      SnackbarHelper.info('Please enter a valid email address', Get.context ?? Get.overlayContext!);
      isLoading.value = false;
      return;
    }
    if (!PasswordValidator.isValid(password)) {
      SnackbarHelper.info(
        'Password must be at least 8 characters long, contain uppercase, lowercase, numbers, and special characters',
        Get.context ?? Get.overlayContext!,
      );
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoint.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Response status for login: ${response.statusCode} and body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        UserStatus.setUserIsLoggedIn(true);
        UserInfo.saveUserAccessToken(responseData['access_token']);
        UserInfo.saveUser(responseData['user']);

        bool isSubscriber = responseData['user']['active_subscriber'] ?? false;
        bool isTrial = responseData['user']['trial_consumed'] == 'trialing';

        if (!isSubscriber || isTrial) {
          Get.offAllNamed(RouteName.subscription);
        } else if(isSubscriber) {
          Get.offAllNamed(RouteName.motivation1);
        }

        SnackbarHelper.success('Login Successful', Get.context ?? Get.overlayContext!);
        Get.offAllNamed(RouteName.motivation);
      } else {
        final responseData = jsonDecode(response.body);
        SnackbarHelper.error(
          responseData['message'] ?? 'Login failed',
          Get.context ?? Get.overlayContext!,
        );
      }
    } catch (e) {
      if (kDebugMode) print('Error: $e');
      SnackbarHelper.error('Something went wrong. Please try again.', Get.context ?? Get.overlayContext!);
    } finally {
      isLoading.value = false; // ✅ Always reset
    }
  }
}
