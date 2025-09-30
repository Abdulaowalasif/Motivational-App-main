import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routes_name.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                'Welcome to Alpha',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 32,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,

                fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "This isn’t another motivational app.\nThis is where hunters become leaders.",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    color: Theme
                        .of(context)
                        .brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

              ),
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/Logo.png', // Replace with your image path
                width: 381,
                height: 381,
                fit: BoxFit.cover,

              ),
              SizedBox(height: 90),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RouteName.nameScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'End the pack',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
