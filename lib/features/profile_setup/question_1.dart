import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_app/routes/routes_name.dart';

import '../../core/constant/local_data/store_variable.dart';
import '../../core/utills/helper/snackbar_helper.dart';
import '../../core/utills/universal_widget/full_size_btn.dart';

class Question_1 extends StatefulWidget {
  const Question_1({super.key});

  @override
  State<Question_1> createState() => _Question_1State();
}

class _Question_1State extends State<Question_1> {
  String? selectedTarget;

  final List<String> targetOptions = [
    'Dominate my discipline',
    'Relentless daily motivation',
    'Crush my business/career',
    'Conquer my body',
    'Forge an unbreakable mindset',
  ];

  final List<String> intensityOptions = [
    'Hardcore (no excuses, straight fire)',
    'Elite (uplifting, luxury tone)',
    'Hybrid (a calculated mix)',
  ];

  void _handleContinue() {
    if (selectedTarget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a target')),
      );
      return;
    }
    // Navigate to the next screen or perform an action
    print('Selected target: $selectedTarget');
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
                'Every Alpha has a target.\nWhat\'s yours?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 30),
              ...targetOptions.map((option) {
                final isSelected = selectedTarget == option;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTarget = option;
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
                            groupValue: selectedTarget,
                            onChanged: (value) {
                              setState(() {
                                selectedTarget = value;
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
                  if (selectedTarget != null) {
                    StoreVariable.userProfileSetup['mission'] = selectedTarget;
                    Get.toNamed(RouteName.question11);
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