import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_app/features/auth/views/sign_up_screen.dart';

import '../../../routes/routes_name.dart';

class AccountCreatedSuccessfully extends StatelessWidget {
  const AccountCreatedSuccessfully({super.key});

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
                'Account created successfully',
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Your account has been created. You can now log in and start exploring your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 40),
              buildButton(context, text: 'Sign in', onPressed: () {
                Get.toNamed(RouteName.welcomeScreen);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
