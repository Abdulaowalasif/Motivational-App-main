import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/constant/api_endpoin.dart';
import 'package:motivational_app/core/utills/local_storage/user_info.dart';

import '../../../core/constant/local_data/store_variable.dart';
import '../../../routes/routes_name.dart';

class GetUserDataController {
  Future<void> fetchUserData() async {
    String? accessToken = await UserInfo.getUserAccessToken();

    if(accessToken != null) {
      final response = await http.get(
          Uri.parse(ApiEndpoint.profile),
          headers: {
            'Authorization': 'Bearer $accessToken',
          }
      );
      print('Response status for user data: ${response.statusCode} and body: ${response.body}');

      if(response.statusCode == 200) {
          Get.offNamed(RouteName.motivation1);
      } else if (response.statusCode == 401) {
        Get.offAllNamed(RouteName.signin);
        print('Token expired, redirecting to signin');
      } else {
        // Handle other error responses
        Get.offAllNamed(RouteName.signin);
        print('Failed to fetch user data: ${response.statusCode}');
      }

    } else {
      // No access token found
      Get.toNamed(RouteName.signin);
      print('No access token found, redirecting to signin');
    }
  }

  // Helper method to check if user has valid subscription
  bool hasValidSubscription(Map<String, dynamic> userData) {
    bool isActiveSubscriber = userData['active_subscriber'] ?? false;
    String subscriptionStatus = userData['subscription_status'] ?? '';

    return isActiveSubscriber &&
        (subscriptionStatus == 'active' || subscriptionStatus == 'trialing');
  }

  // Helper method to calculate days remaining
  int calculateDaysRemaining(String? endDateStr) {
    if (endDateStr == null || endDateStr.isEmpty) return 0;

    try {
      DateTime endDate = DateTime.parse(endDateStr);
      DateTime now = DateTime.now();
      int daysRemaining = endDate.difference(now).inDays;
      return daysRemaining > 0 ? daysRemaining : 0;
    } catch (e) {
      print('Error parsing date: $e');
      return 0;
    }
  }
}