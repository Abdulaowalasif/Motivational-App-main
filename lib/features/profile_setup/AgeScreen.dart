import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:motivational_app/core/constant/local_data/store_variable.dart';
import 'package:motivational_app/core/utills/helper/snackbar_helper.dart';

import '../../core/utills/universal_widget/full_size_btn.dart';
import '../../routes/routes_name.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  String? selectedAge;

  final List<String> ageRanges = [
    '13 to 17',
    '18 to 24',
    '25 to 34',
    '35 to 44',
    '45 to 54',
    '55+',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    String age = selectedAge ?? 'Select your age';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "How old are you?",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 30),
            ...ageRanges.map((age) {
              final isSelected = selectedAge == age;
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAge = age;
                    });
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade400,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
                          : Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          age,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        Radio<String>(
                          value: age,
                          groupValue: selectedAge,
                          onChanged: (value) {
                            setState(() {
                              selectedAge = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            const Spacer(),
            FullSizeBtn(
              title: 'Next',
              onPressed: () {
                if (selectedAge != null) {
                  StoreVariable.userProfileSetup['age_range'] = selectedAge;
                  Get.toNamed(RouteName.gender);
                }else{
                  SnackbarHelper.error('Please select your age !', context);
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
