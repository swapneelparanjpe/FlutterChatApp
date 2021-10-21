import 'package:shared_preferences/shared_preferences.dart';

class Prefs {

  static String prefIsLoggedIn = "PREF_IS_LOGGED_IN";
  static String prefUsername = "PREF_USERNAME";
  static String prefEmail = "PREF_EMAIL";

  static Future setPrefUsername(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(prefUsername, username);
  }

  static Future setPrefEmail(String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(prefEmail, email);
  }

  static Future setPrefIsLoggedIn(bool isLoggedIn) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(prefIsLoggedIn, isLoggedIn);
  }

  static Future<String?> getPrefUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(prefUsername);
  }

  static Future<String?> getPrefEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(prefEmail);
  }

  static Future<bool?> getPrefIsLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(prefIsLoggedIn);
  }

}