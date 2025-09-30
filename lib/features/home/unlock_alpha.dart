import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_app/routes/routes_name.dart';

class AlphaPlusScreen extends StatelessWidget {
  const AlphaPlusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 10),

            // Title and subtitle
            Text(
              'Unlock Alpha+',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'If you’re serious, go all in.',
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 30),

            // Feature card
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
                      height: 316,
                      margin: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 40,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/icons/Vector.png'),
                          const SizedBox(height: 20),
                          Image.asset('assets/icons/Group.png'),
                          const SizedBox(height: 20),
                          Image.asset('assets/icons/Vector-1.png'),
                        ],
                      ),
                    ),

                    // Feature descriptions
                    Container(
                      height: 316,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text(
                            'Exclusive Alpha Circle (premium users only)',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Unlimited quotes & notifications',
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 20),
                          Text('Zero ads', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(RouteName.quoteSchedule);
                      },
                      child: const Text('Go Alpha+'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(RouteName.quoteSchedule);
                      },
                      child: Text('Stay Basic'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Footer text
            Text(
              '3 day free trial. Are you Alpha or not?',
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
