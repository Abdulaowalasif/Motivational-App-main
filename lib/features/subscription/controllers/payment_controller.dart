import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/constant/api_endpoin.dart';
import 'package:motivational_app/core/utills/helper/snackbar_helper.dart';
import 'package:motivational_app/core/utills/local_storage/user_info.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentController {
  RxBool isLoading = false.obs;
  String selectedSubscriptionType = 'year'; // Default subscription type

  Future<void> initiatePayment({String? packageType}) async {
    isLoading.value = true;

    // Set the subscription type based on the selected package
    if (packageType != null) {
      selectedSubscriptionType = packageType;
    }

    String? accessToken = await UserInfo.getUserAccessToken();
    print('Access token retrieved: $accessToken');
    print('Selected subscription type: $selectedSubscriptionType');

    if (accessToken != null) {
      final response = await http.post(
          // Uri.parse(ApiEndpoint.initiatePayment),
          Uri.parse(ApiEndpoint.checkOut),
          headers: {
            'Authorization' : 'Bearer $accessToken',
          },
          body:{
            "package": selectedSubscriptionType  // month, year, or life_time
          }
      );

      print('Payment initiation response code: ${response.statusCode} and body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        String stripePaymentIntentID = responseData['url'];
        SnackbarHelper.info('Payment initiated, confirming...', Get.context!);
        launchUrl(Uri.parse(stripePaymentIntentID), mode: LaunchMode.externalApplication);
        isLoading.value = false;
      } else {
        print('Failed to initiate payment: ${response.body}');
        isLoading.value = false;
        SnackbarHelper.error('Failed to initiate payment. Please try again.', Get.context!);
      }
    } else {
      isLoading.value = false;
      SnackbarHelper.error('Authentication error. Please login again.', Get.context!);
    }
  }


  // Helper method to get subscription display name
  String getSubscriptionDisplayName() {
    switch (selectedSubscriptionType) {
      case 'month':
        return 'Monthly (\$9/month)';
      case 'year':
        return 'Yearly (\$10/year)';
      case 'life_time':
        return 'Lifetime (\$180)';
      default:
        return 'Selected Plan';
    }
  }

  // Helper method to reset controller state
  void resetController() {
    isLoading.value = false;
    selectedSubscriptionType = 'year';
  }
}