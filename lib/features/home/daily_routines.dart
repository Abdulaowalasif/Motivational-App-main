import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_app/routes/routes_name.dart';

class DailyRoutines extends StatelessWidget {
  const DailyRoutines({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/solar_fire-bold.png'),
            Text(
              textAlign: TextAlign.center,
              'Hunt Your Goals Every \nSingle Day',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 28,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            WeeklyStreakWidget(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.toNamed(RouteName.subscription);
                },
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeeklyStreakWidget extends StatefulWidget {
  const WeeklyStreakWidget({super.key});

  @override
  State<WeeklyStreakWidget> createState() => _WeeklyStreakWidgetState();
}

class _WeeklyStreakWidgetState extends State<WeeklyStreakWidget> {
  // Example: index 0 is 'We', selected by default
  int selectedDayIndex = 0;

  final List<String> weekdays = [
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
    'Mo',
    'Tu',
    'Sa',
  ];

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Container(
      margin: EdgeInsetsGeometry.all(20),
      padding: EdgeInsetsGeometry.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
      ),
      child: Column(
        children: [
          // Days Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(weekdays.length, (index) {
              final isSelected = index == selectedDayIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Text(
                      weekdays[index],
                      style: TextStyle(fontSize: 12, color: textColor),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                        });
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.amber[800]
                              : Colors.black87,
                          shape: BoxShape.circle,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          // Message
          const Text(
            'Build a streak, one day at a time.',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
