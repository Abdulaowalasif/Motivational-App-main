
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:motivational_app/features/auth/controllers/sign_up_controller.dart';

import 'package:motivational_app/features/auth/widget/custom_text_field.dart';
import 'package:motivational_app/routes/routes_name.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {

    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    final signUpController = Get.put(SignUpController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(horizontal: 10),

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
                hint: 'Enter Full Name',
                icon: Icons.person,

                controller: nameController,

              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'Enter Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'Enter Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                controller: phoneController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'Enter Password',
                icon: Icons.lock,
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'Confirm Password',
                icon: Icons.lock,
                obscureText: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 40),
              signUpController.isLoading.value
                  ? const CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              )
              :buildButton(context, text: signUpController.isLoading.value ? 'Sign Up ..' : 'Sign Up', onPressed: () {
                signUpController.signUp(
                  nameController.text.trim(),
                  emailController.text.trim(),
                  phoneController.text.trim(),
                  passwordController.text.trim(),
                  confirmPasswordController.text.trim(),
                );
              }),
              const SizedBox(height: 16),
              buildButton(
                context,
                text: 'Sign In',
                onPressed: () {
                  Get.toNamed(RouteName.signin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildButton(
  BuildContext context, {
  required String text,
  required VoidCallback onPressed,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.white : Colors.black,
        foregroundColor: isDark ? Colors.black : Colors.white,
        elevation: 6,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

