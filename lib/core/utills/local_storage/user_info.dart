import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserInfo{

  static void saveUserAccessToken(String token)async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('access_token', token);
  }

  static Future<String?> getUserAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('access_token');
  }

  static void saveUserRefreshToken(String token)async{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('refresh_token', token);
  }
  static Future<String?> getUserRefreshToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('refresh_token');
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', user.toString());
  }

  static Future<Map<String, dynamic>?> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userString = sharedPreferences.getString('user');
    if (userString != null) {
      return userString.isNotEmpty
          ? Map<String, dynamic>.from(
              userString is String ? (userString.startsWith('{') ? jsonDecode(userString) : {}) : {})
          : null;
    }
    return null;
  }

}