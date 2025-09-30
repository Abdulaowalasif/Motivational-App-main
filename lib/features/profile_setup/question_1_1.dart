import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../core/constant/local_data/store_variable.dart';
import '../../core/utills/helper/snackbar_helper.dart';
import '../../core/utills/universal_widget/full_size_btn.dart';
import '../../routes/routes_name.dart';

class Question11 extends StatefulWidget {
  const Question11({super.key});

  @override
  State<Question11> createState() => _Question11State();
}

class _Question11State extends State<Question11> {
  String? selectedIntensity;

  final List<String> intensityOptions = [
    'Hardcore (no excuses, straight fire)',
    'Elite (uplifting, luxury tone)',
    'Hybrid (a calculated mix)',
  ];

  String getValidIntensity(String? intensity) {
    switch(intensity) {
      case 'Hardcore (no excuses, straight fire)':
        return 'Hardcore';
      case 'Elite (uplifting, luxury tone)':
        return 'Elite';
      case 'Hybrid (a calculated mix)':
        return 'Hybrid';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How do you want it?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We need to know how hard to push you.',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 30),
              ...intensityOptions.map((option) {
                final isSelected = selectedIntensity == option;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIntensity = option;
                      });
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          Radio<String>(
                            value: option,
                            groupValue: selectedIntensity,
                            onChanged: (value) {
                              setState(() {
                                selectedIntensity = value;
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
                  if (selectedIntensity != null) {
                    StoreVariable.userProfileSetup['tone'] = getValidIntensity(selectedIntensity);
                    Get.toNamed(RouteName.grind);
                  }else{
                    SnackbarHelper.error('Select An Option', context);
                    return;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}