import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:motivational_app/core/utills/local_storage/user_status.dart';
import 'package:motivational_app/routes/app_routes.dart';

import 'core/themes/themes.dart';
import 'routes/routes_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp(isLoggedIn: await UserStatus.getUserIsLoggedIn(), isOnBoarded: await UserStatus.getUserIsOnBoarded()));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isOnBoarded;
  MyApp({super.key, required this.isLoggedIn, required this.isOnBoarded});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: isLoggedIn
          ?  RouteName.motivation
          : RouteName.signin,
      getPages: AppRoute.pages,
    );
  }
}