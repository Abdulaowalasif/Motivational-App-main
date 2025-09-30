import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motivational_app/features/auth/widget/custom_text_field.dart';
import 'package:motivational_app/features/profile/controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
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

                /// Avatar
                Center(
                  child: Obx(() {
                    final image = controller.profileImage.value;
                    final defaultImage =
                        Get.arguments?['profile_image'] ??
                            'https://avatar.iran.liara.run/public/91';

                    return Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: image != null
                              ? FileImage(File(image.path))
                              : NetworkImage(defaultImage) as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showImageSourceDialog(context),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.edit,
                                  size: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 24),

                /// Name
                _buildLabel("Name", textColor),
                CustomTextField(
                  controller: controller.nameController,
                  hint: "Enter your name",
                ),
                const SizedBox(height: 16),

                /// Email
                _buildLabel("Email", textColor),
                CustomTextField(
                  controller: controller.emailController,
                  hint: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                /// Age
                _buildLabel("Age", textColor),
                CustomTextField(
                  controller: controller.ageController,
                  hint: "Enter your age",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                /// Gender
                _buildLabel("Gender", textColor),
                Obx(() => DropdownButtonFormField<String>(
                  value: controller.gender.value,
                  items: ['Male', 'Female', 'Other']
                      .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
                      .toList(),
                  onChanged: (val) => controller.gender.value = val!,
                )),
                const SizedBox(height: 16),

                /// Phone
                _buildLabel("Phone", textColor),
                CustomTextField(
                  controller: controller.phoneController,
                  hint: "Enter your phone",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 28),

                /// Save button
                Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: color),
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
