import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_core/src/get_main.dart';

import 'package:http/http.dart' as http;
import 'package:motivational_app/core/constant/enum.dart';
import 'package:motivational_app/features/auth/views/sign_up_screen.dart';
import 'package:motivational_app/features/auth/widget/custom_text_field.dart';

import '../../../core/constant/api_endpoin.dart';
import '../../../core/validator/email_validator.dart';
import '../../../routes/routes_name.dart';
import '../controllers/verify_email_controller.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final controller = Get.put(VerifyEmailController());

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

              CustomTextField(
                hint: 'Enter Email Address',
                icon: Icons.email,
                controller: controller.emailController,
              ),


              const SizedBox(height: 40),
              Obx(() => buildButton(
                context,
                text: controller.isLoading.value ? 'Reseting ..' : 'Reset Password',
                onPressed: () {
                  controller.passwordResetRequest();
                },
              )),

            ],
          ),
        ),
      ),
    );
  }
}
