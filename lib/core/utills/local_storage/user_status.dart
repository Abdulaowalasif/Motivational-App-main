import 'package:shared_preferences/shared_preferences.dart';

class UserStatus {

  static void setUserIsLoggedIn(bool isLoggedIn)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<bool> getUserIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static void setUserIsPremium(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', isPremium);
  }
  static Future<bool> getUserIsPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPremium') ?? false;
  }

  static void setUserIsOnBoarded(bool isOnBoarded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnBoarded', isOnBoarded);
  }
  static Future<bool> getUserIsOnBoarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isOnBoarded') ?? false;
  }

}