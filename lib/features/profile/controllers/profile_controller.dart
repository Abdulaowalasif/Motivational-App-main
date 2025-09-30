
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/constant/api_endpoin.dart';
import 'package:motivational_app/core/utills/local_storage/user_info.dart';
import 'package:motivational_app/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var profileData = <String, dynamic>{}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    String? accessToken = await UserInfo.getUserAccessToken();

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoint.profile),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        profileData.value = json.decode(response.body);
      } else {
        Get.snackbar('Error', 'Failed to load profile');
      }
    } catch (e) {
      if (kDebugMode) print('Profile fetch error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(RouteName.signin);
  }
}
