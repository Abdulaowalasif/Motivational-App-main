import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motivational_app/routes/routes_name.dart';

import 'controllers/get_user_data_controller.dart';

class Motivation extends StatefulWidget {
  const Motivation({super.key});

  @override
  State<Motivation> createState() => _MotivationState();
}

class _MotivationState extends State<Motivation> {
  @override
  void initState() {

    GetUserDataController getUserDataController =  GetUserDataController();
    getUserDataController.fetchUserData();

    // Future.delayed(
    //   Duration(seconds: 3),
    //   () => Get.toNamed(RouteName.motivation1),
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Text(
          'Welcome to Motivation',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
