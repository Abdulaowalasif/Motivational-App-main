import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/constant/api_endpoin.dart';
import 'package:motivational_app/core/utills/local_storage/user_info.dart';
import 'package:motivational_app/core/utills/local_storage/user_status.dart';

import '../../core/constant/local_data/store_variable.dart';
import '../../core/utills/helper/snackbar_helper.dart';
import '../../core/utills/universal_widget/full_size_btn.dart';
import '../../routes/routes_name.dart';

class GrindLevel extends StatefulWidget {
  const GrindLevel({super.key});

  @override
  State<GrindLevel> createState() => _GrindLevelState();
}

class _GrindLevelState extends State<GrindLevel> {
  String? selectedGrindDepth;

  final List<String> grindDepthOptions = [
    'Starting the climb',
    'In the trenches',
    'No mercy',
  ];

  void _handleContinue() {
    if (selectedGrindDepth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a grind depth')),
      );
      return;
    }
    // Navigate to the next screen or perform an action
    print('Selected grind depth: $selectedGrindDepth');
  }

  void motivationProfileSetup() async{
    String? accessToken = await UserInfo.getUserAccessToken();
    if( accessToken != null && accessToken.isNotEmpty) {
      try{
        final response = await http.post(
          Uri.parse(ApiEndpoint.motivationProfileSetup),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(StoreVariable.userProfileSetup),
        );

        print('Response status for submitting profilesetup: ${response.statusCode} and body: ${response.body}');

        if(response.statusCode == 201 || response.statusCode == 200) {
          UserStatus.setUserIsOnBoarded(true);
          UserStatus.setUserIsLoggedIn(true);
          Get.toNamed(RouteName.subscription);
        } else {
          final errorData = jsonDecode(response.body);
          print('Error during profile setup: ${errorData['detail']}');
          SnackbarHelper.error(errorData['detail'], context);
        }

      }catch(e){
        print('Error during profile setup: $e');
      }
    } else {
      SnackbarHelper.error('Please Login First', context);
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
                'How deep is your grind?',
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
              ...grindDepthOptions.map((option) {
                final isSelected = selectedGrindDepth == option;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGrindDepth = option;
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
                            groupValue: selectedGrindDepth,
                            onChanged: (value) {
                              setState(() {
                                selectedGrindDepth = value;
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
                title: 'Continue',
                onPressed: () {
                  if (selectedGrindDepth != null) {
                    StoreVariable.userProfileSetup['grind_level'] = selectedGrindDepth;
                    print('Selected  option is: ${StoreVariable.userProfileSetup}');
                    motivationProfileSetup();
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