import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:motivational_app/routes/routes_name.dart';

import '../../core/constant/local_data/store_variable.dart';
import '../../core/utills/helper/snackbar_helper.dart';
import '../../core/utills/universal_widget/full_size_btn.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String? selectedLanguage;

  final List<Map<String, String>> languageOptions = [
    {'name': 'English (US)', 'flag': '🇺🇸'},
    {'name': 'English (UK)', 'flag': '🇬🇧'},
    {'name': 'French (FR)', 'flag': '🇫🇷'},
    {'name': 'German (DE)', 'flag': '🇩🇪'},
  ];

  void _handleContinue() {
    if (selectedLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a language')),
      );
      return;
    }
    print('Selected language: $selectedLanguage');
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
                'Language',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 30),
              ...languageOptions.map((option) {
                final isSelected = selectedLanguage == option['name'];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLanguage = option['name'];
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
                          Row(
                            children: [
                              Text(
                                option['flag']!,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                option['name']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Radio<String>(
                            value: option['name']!,
                            groupValue: selectedLanguage,
                            onChanged: (value) {
                              setState(() {
                                selectedLanguage = value;
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
                  if (selectedLanguage != null) {
                    StoreVariable.userProfileSetup['language'] = selectedLanguage;
                    Get.toNamed(RouteName.question1);
                  }else{
                    SnackbarHelper.error('Please enter your name', context);
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