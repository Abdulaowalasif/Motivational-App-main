import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:motivational_app/core/constant/api_endpoin.dart';
import 'package:motivational_app/core/utills/helper/snackbar_helper.dart';
import 'package:motivational_app/core/utills/local_storage/user_info.dart';
import 'package:motivational_app/routes/routes_name.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  var gender = 'Male'.obs;
  var profileImage = Rx<XFile?>(null);

  final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get existing profile data from arguments
    final profileData = Get.arguments as Map<String, dynamic>?;

    if (profileData != null) {
      nameController.text = profileData['full_name'] ?? '';
      emailController.text = profileData['email'] ?? '';
      ageController.text = profileData['age']?.toString() ?? '';
      phoneController.text = profileData['phone_number'] ?? '';
      gender.value = _reverseGender(profileData['gender']);
    }
  }

  /// Pick Image
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 50,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFile != null) {
        profileImage.value = pickedFile;
      }
    } catch (e) {
      SnackbarHelper.error(
        'Failed to pick image: $e',
        Get.context ?? Get.overlayContext!,
      );
    }
  }

  /// Save Profile
  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      String? accessToken = await UserInfo.getUserAccessToken();

      var request = http.MultipartRequest(
        "PUT",
        Uri.parse(ApiEndpoint.profileUpdate),
      );
      request.headers['Authorization'] = 'Bearer $accessToken';

      request.fields.addAll({
        "full_name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "age": int.tryParse(ageController.text.trim())?.toString() ?? '',
        "gender": _formatGender(gender.value),
      });

      if (profileImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "profile_image",
            profileImage.value!.path,
            filename: profileImage.value!.name,
          ),
        );
      }

      var response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        SnackbarHelper.success(
          'Profile updated successfully',
          Get.context ?? Get.overlayContext!,
        );
        Get.offNamed(RouteName.profile);
      } else {
        final responseData = jsonDecode(responseBody.body);
        SnackbarHelper.error(
          responseData['message'] ?? 'Failed to update profile',
          Get.context ?? Get.overlayContext!,
        );
      }
    } catch (e) {
      if (kDebugMode) print('Error updating profile: $e');
      SnackbarHelper.error(
        'Something went wrong. Please try again.',
        Get.context ?? Get.overlayContext!,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Format gender for API
  String _formatGender(String gender) {
    switch (gender) {
      case 'Male':
        return 'male';
      case 'Female':
        return 'female';
      default:
        return 'other';
    }
  }

  /// Reverse gender for dropdown
  String _reverseGender(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      default:
        return 'Other';
    }
  }
}
