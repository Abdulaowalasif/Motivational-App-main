import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motivational_app/features/auth/views/sign_up_screen.dart';
import 'package:motivational_app/features/auth/widget/custom_text_field.dart';
import '../../../core/constant/local_data/showMinimalistDeveloperFootprintDialog.dart';
import '../../../core/constant/string_constent/icon_string.dart';
import '../../../routes/routes_name.dart';
import '../controllers/sign_in_controller.dart';



class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final signInController = Get.put(SignInController());



  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    int count = 0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  if(count == 5){
                    // Open a popup with app version
                    showMinimalistDeveloperFootprintDialog(context);
                    count = 0;
                  }

                  count++;
                },
                  child: Image.asset(IconString.logo, height: 200, width: double.infinity)
              ),
              const SizedBox(height: 20),

              CustomTextField(
                hint: 'Enter Email Address',
                icon: Icons.email,
                controller: emailController,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                hint: 'Enter Password',
                icon: Icons.lock,
                obscureText: true,
                controller: passwordController,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(RouteName.forgotPassword),
                  child: Text('Forgot password?', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return signInController.isLoading.value
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                )
                    : buildButton(
                  context,
                  text: 'Sign in',
                  onPressed: () {
                    signInController.signIn(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  },
                );
              }),

              const SizedBox(height: 20),
              buildButton(context, text: 'Sign Up', onPressed: () => Get.toNamed(RouteName.signup)),
              const SizedBox(height: 20),

              Text('or continue with', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
              const SizedBox(height: 20),

              // Signup with Google and Apple
              SocialSignInButton(logoPath: IconString.googleLogo,
                text: 'Sign up with Google',
              ),
              const SizedBox(height: 20),
              SocialSignInButton(
                logoPath: IconString.appleLogo,
                text: 'Sign up with Apple',
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class SocialSignInButton extends StatelessWidget {
  final String logoPath;
  final String text;
  final VoidCallback? onPressed;

  const SocialSignInButton({
    Key? key,
    required this.logoPath,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity, // Fixed width for the button
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50), // Rounded corners
          border: Border.all(color: Colors.black, width: 1.0), // Black border
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displays the logo image from the asset path.
            Image.asset(
              logoPath,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 15), // Spacing between the logo and text
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Arial', // A clean, sans-serif font
              ),
            ),
          ],
        ),
      ),
    );
  }
}