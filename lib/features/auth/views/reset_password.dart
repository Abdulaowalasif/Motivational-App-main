import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_app/core/validator/password_validator.dart';
import 'package:motivational_app/features/auth/views/sign_up_screen.dart';
import 'package:motivational_app/features/auth/widget/custom_text_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/constant/api_endpoin.dart';
import '../../../routes/routes_name.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void resetPassword() async {
    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (!PasswordValidator.isValid(passwordController.text) &&
        !PasswordValidator.isValid(confirmPasswordController.text)){
      Get.snackbar('Error', 'Password must be at least 8 characters long',snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try{
      final response = await http.post(
        Uri.parse(ApiEndpoint.passwordResetRequest),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'new_password': passwordController.text,
          'confirm_password': confirmPasswordController.text,
        }),
      );
      if (response.statusCode == 200) {
        // Success logic
        final responseData = jsonDecode(response.body);
        Get.snackbar('Success', responseData['message'] ?? 'OTP sent to your email', snackPosition: SnackPosition.BOTTOM);
        Get.toNamed(RouteName.signin);
        // Navigate or clear fields
      } else {
        // Error logic
        Get.snackbar('Error', 'Sign up failed ${response.statusCode}: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    }catch(e){
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28),
                  onPressed: () => Get.back(),
                ),
              ),
              Image.asset(
                'assets/images/Logo.png',
                height: 200,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
              Text(
                'Password reset',
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: 'Enter new password',
                icon: Icons.lock,
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'Confirm new password',
                icon: Icons.lock,
                obscureText: true,
                controller: confirmPasswordController,
              ),


              const SizedBox(height: 40),
              buildButton(context, text: 'Update password', onPressed: () {
                resetPassword();
              }),

            ],
          ),
        ),
      ),
    );
  }
}
