import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/constant/enum.dart';
import 'package:motivational_app/core/utills/helper/snackbar_helper.dart';
import 'package:motivational_app/core/utills/local_storage/user_info.dart';
import 'package:motivational_app/features/auth/views/forgot_password.dart';
import 'package:motivational_app/features/auth/views/reset_password.dart';
import 'package:motivational_app/features/home/wellcome_screen.dart';

import '../../../core/constant/api_endpoin.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({super.key});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final int length = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _textFocusNodes;
  late List<FocusNode> _keyboardFocusNodes;

  late String email;
  late VerificationType type;

  final storage = GetStorage();

  String get code => _controllers.map((e) => e.text).join();

  String getApiEndpoint() {
    if (type == VerificationType.registration) {
      return ApiEndpoint.verifyOTP;
    } else if (type == VerificationType.passwordReset) {
      return ApiEndpoint.verifyRestOTP;
    }
    return '';
  }


  Map<String, dynamic> getBody() {
    if (type == VerificationType.registration) {
      return {
        'email': email,
        'otp_code': code,
        'otp_type': type.name,
      };
    } else if (type == VerificationType.passwordReset) {
      return {
        'otp_code': code,
      };

    }
    return {};
  }

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(length, (_) => TextEditingController());
    _textFocusNodes = List.generate(length, (_) => FocusNode());
    _keyboardFocusNodes = List.generate(length, (_) => FocusNode());

    final args = (Get.arguments as Map?) ?? {};
    email = args['email']?.toString() ?? '';

    // Fixed: Use string key instead of enum type
    String typeString = args['type']?.toString() ?? 'registration';

    // Parse the verification type from string
    if (typeString == 'passwordReset') {
      type = VerificationType.passwordReset;
    } else {
      type = VerificationType.registration; // default
    }

    // Alternative approach - if you're passing the enum directly:
    // type = args['type'] as VerificationType? ?? VerificationType.registration;

  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _textFocusNodes) {
      f.dispose();
    }
    for (final f in _keyboardFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < length - 1) {
      FocusScope.of(context).requestFocus(_textFocusNodes[index + 1]);
    } else if (value.isNotEmpty && index == length - 1) {
      _textFocusNodes[index].unfocus();
    }
  }

  void _onKey(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _controllers[index - 1].clear();
        FocusScope.of(context).requestFocus(_textFocusNodes[index - 1]);
      }
    }
  }

  void verifyEmail() async {
    if (code.length == 6 && !_controllers.any((c) => c.text.isEmpty)) {
      try {

        print('API Endpoint: ${getApiEndpoint()}'); // Debug print
        print('Request Body: ${jsonEncode(getBody())}'); // Debug print

        final response = await http.post(
          Uri.parse(getApiEndpoint()),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(getBody()),
        );


        print('Response Status for Create User: ${response.statusCode} and Body: ${response.body}');

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (type == VerificationType.registration) {

            // Store tokens and user data in
            UserInfo.saveUserAccessToken(responseData['access_token']);
            UserInfo.saveUserRefreshToken(responseData['refresh_token']);
            UserInfo.saveUser(responseData['user']);

            SnackbarHelper.success('Verification successful',context);
            Get.to(const WelcomeScreen());
          } else if (type == VerificationType.passwordReset) {
            SnackbarHelper.success('Verification successful',context);
            Get.to(ResetPassword());
          } else {
            SnackbarHelper.error('Unknown verification type',context);
          }
        } else {
          // Parse error message
          String errorMsg = 'Verification failed';
          try {
            final errorData = jsonDecode(response.body);
            if (errorData is Map && errorData['non_field_errors'] != null) {
              errorMsg = (errorData['non_field_errors'] as List).join('\n');
            } else if (errorData['message'] != null) {
              errorMsg = errorData['message'];
            }
          } catch (_) {
            print('Error parsing error message: ${response.body}');
          }
        }
      } catch (e) {
        print('Error occurred: $e'); // Debug print
        SnackbarHelper.error('An error occurred while verifying the code.',context);
      }
    } else {
      SnackbarHelper.error('Please enter a valid 6-digit code.',context);
    }
  }

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
                'Check your email',
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'We sent a code to $email. Enter 6 digit code that mentioned in the email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(length, (index) {
                  return RawKeyboardListener(
                    focusNode: _keyboardFocusNodes[index],
                    onKey: (event) => _onKey(event, index),
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 50,
                        height: 60,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _textFocusNodes[index],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          onChanged: (value) => _onChanged(value, index),
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: verifyEmail,
                child: const Text(
                  'Verify code',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}