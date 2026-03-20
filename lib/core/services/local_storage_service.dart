import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class LocalStorageService {
  static Future<bool> isOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(Constants.onboardingSeen) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constants.onboardingSeen, true);
  }
}