import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../core/constant/local_data/store_variable.dart';
import '../../core/utills/helper/snackbar_helper.dart';
import '../../core/utills/universal_widget/full_size_btn.dart';
import '../../routes/routes_name.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? selectedGender;

  final List<String> genderOptions = [
    'Female',
    'Male',
    'Other',
    'Prefer not say',
  ];


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    String age = selectedGender ?? 'Select your age';

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
            ...genderOptions.map((age) {
              final isSelected = selectedGender == age;
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = age;
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
                          groupValue: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
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
                if (selectedGender != null) {
                  StoreVariable.userProfileSetup['gender'] = selectedGender;
                  Get.toNamed(RouteName.language);
                }else{
                  SnackbarHelper.error('Please Select a gender ', context);
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
