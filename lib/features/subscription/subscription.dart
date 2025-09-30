import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:motivational_app/core/constant/api_endpoin.dart';
import 'package:motivational_app/core/utills/helper/snackbar_helper.dart';
import 'package:motivational_app/core/utills/local_storage/user_info.dart';
import 'package:motivational_app/features/subscription/controllers/payment_controller.dart';
import 'package:motivational_app/routes/routes_name.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final daysRemaining = (Get.arguments != null && Get.arguments['daysRemaining'] != null)
        ? Get.arguments['daysRemaining']
        : '0';
    final controller = Get.put(PaymentController());
    final RxString selectedPackage = 'year'.obs; // Default selection

    int daysRemainingInt = double.tryParse(daysRemaining)?.toInt() ?? 0;
    print('Days remaining: $daysRemainingInt');

    Future<void> getFreeTrial() async{
      String? accessToken = await UserInfo.getUserAccessToken();

      final response = await http.post(
          Uri.parse(ApiEndpoint.getFreeTrile),
          headers: {
            'Authorization' : 'Bearer $accessToken'
          }
      );

      print('Response status for free trial: ${response.statusCode} and body: ${response.body}');

      if(response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(RouteName.motivation1);
      } else if(response.statusCode == 400) {
        SnackbarHelper.info('You have already used your free trial.', context);
      } else {
        SnackbarHelper.error('Something went wrong, please try again later', context);
      }
    }

    // Package selection widget
    Widget buildPackageCard({
      required String packageType,
      required String title,
      required String price,
      required String originalPrice,
      required String period,
      String? badge,
      required RxString selectedPackage,
    }) {
      return Obx(() {
        bool isSelected = selectedPackage.value == packageType;
        return GestureDetector(
          onTap: () => selectedPackage.value = packageType,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xffe6e6e6) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.black : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Radio button
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.grey,
                            width: 2,
                          ),
                          color: isSelected ? Colors.black : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 16),

                      // Package details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  price,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (originalPrice.isNotEmpty)
                                  Text(
                                    originalPrice,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              period,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge
                if (badge != null)
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Title and subtitle
                Text(
                  'Choose Your Plan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start with 3-day free trial, cancel anytime',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 24),

                // Subscription packages
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      buildPackageCard(
                        packageType: 'year',
                        title: 'Yearly Plan',
                        price: '\$10/year',
                        originalPrice: '\$20',
                        period: 'Save 50% - Best Value',
                        badge: 'MOST POPULAR',
                        selectedPackage: selectedPackage,
                      ),

                      buildPackageCard(
                        packageType: 'month',
                        title: 'Monthly Plan',
                        price: '\$9/month',
                        originalPrice: '',
                        period: 'Billed monthly, cancel anytime',
                        selectedPackage: selectedPackage,
                      ),

                      buildPackageCard(
                        packageType: 'life_time',
                        title: 'Lifetime Access',
                        price: '\$180',
                        originalPrice: '\$360',
                        period: 'One-time payment, lifetime access',
                        badge: 'BEST DEAL',
                        selectedPackage: selectedPackage,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Feature card (kept the same)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffe6e6e6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 250,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 40,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/icons/Vector.png'),
                              const SizedBox(height: 15),
                              Image.asset('assets/icons/Group.png'),
                              const SizedBox(height: 15),
                              Image.asset('assets/icons/Vector-1.png'),
                            ],
                          ),
                        ),

                        // Feature descriptions
                        Expanded(
                          child: Container(
                            height: 250,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Today',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Get full access and see your mindset start to change.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Day 2',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Get a reminder that your trial ends in 24 hours',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'After Day 3',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "Your free trial ends and you'll be charged, cancel anytime before",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Days remaining text (if applicable)
                if (daysRemainingInt > 0)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, color: Colors.red, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Days remaining: $daysRemaining',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Subscribe button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Handle subscription based on selected package
                      controller.initiatePayment(packageType: selectedPackage.value);
                    },
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Text('Processing...');
                      }

                      String buttonText = 'Start Free Trial';
                      switch (selectedPackage.value) {
                        case 'month':
                          buttonText = 'Start Free Trial - Then \$9/month';
                          break;
                        case 'year':
                          buttonText = 'Start Free Trial - Then \$10/year';
                          break;
                        case 'life_time':
                          buttonText = 'Start Free Trial - Then \$180 once';
                          break;
                      }

                      return Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 12),

                // Free trial button (only show if no active trial)
                if (daysRemainingInt == 0)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: BorderSide(color: textColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await getFreeTrial();
                      },
                      child: Text(
                        'Just start free trial (3 days)',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Footer text
                Center(
                  child: Text(
                    'Cancel anytime. Terms and conditions apply.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}