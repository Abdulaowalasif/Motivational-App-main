import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_app/features/profile/controllers/profile_controller.dart';
import 'package:motivational_app/features/profile/widgets/profile_tile_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:motivational_app/core/constant/api_endpoin.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.profileData;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.close, color: textColor),
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          data['profile_image'] ??
                              'https://avatar.iran.liara.run/public/91',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['full_name'] ?? '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  color: cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 16),
                    child: Column(
                      children: [
                        ProfileTileWidget(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: data['email'] ?? '',
                          textColor: textColor,
                        ),
                        const Divider(),
                        ProfileTileWidget(
                          icon: Icons.cake,
                          title: 'Age',
                          subtitle: data['age']?.toString() ?? '',
                          textColor: textColor,
                        ),
                        const Divider(),
                        ProfileTileWidget(
                          icon: Icons.wc,
                          title: 'Gender',
                          subtitle: data['gender'] ?? '',
                          textColor: textColor,
                        ),
                        const Divider(),
                        ProfileTileWidget(
                          icon: Icons.phone,
                          title: 'Phone',
                          subtitle: data['phone_number'] ?? '',
                          textColor: textColor,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/editProfile', arguments: data);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => controller.logout(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Logout',
                        style: TextStyle(fontSize: 16, color: Colors.red)),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    TextButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse(ApiEndpoint.privacyPolicyUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse(ApiEndpoint.privacyPolicyUrl),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
