import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:motivational_app/core/constant/local_data/store_variable.dart';
import 'package:motivational_app/core/utills/helper/snackbar_helper.dart';

import '../../core/utills/universal_widget/full_size_btn.dart';
import '../../routes/routes_name.dart';

class NameScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  NameScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    String name = nameController.text.isEmpty ? 'Enter your name' : nameController.text;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding:  EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'What do you want to\nbe called?',
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
            const SizedBox(height: 40),
            SizedBox(
              height: 60,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
              ),
            ),

            Spacer(),

            FullSizeBtn(
              title: 'Next',
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  StoreVariable.userProfileSetup['name'] = nameController.text;
                  Get.toNamed(RouteName.ageScreen);
                }else{
                  SnackbarHelper.error('Please enter your name', context);
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}


