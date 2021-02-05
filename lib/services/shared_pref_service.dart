import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKeys {
  SharedPrefKeys._();
  static const String darkModeEnabled = 'darkModeEnabled';
  static const String isFirstLaunch = 'isFirstLaunch';
}

class SharedPreferencesService {
  static SharedPreferencesService _instance;
  static SharedPreferences _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  Future<void> setDarkModeInfo(bool isDarkModeEnabled) async =>
      await _preferences.setBool(
          SharedPrefKeys.darkModeEnabled, isDarkModeEnabled);

  Future<void> setIsFirstLaunchInfo(bool isFirstLaunch) async =>
      await _preferences.setBool(
          SharedPrefKeys.isFirstLaunch, isFirstLaunch);

  bool get isFirstLaunch =>
      _preferences.getBool(SharedPrefKeys.isFirstLaunch);

  bool get isDarkModeEnabled =>
      _preferences.getBool(SharedPrefKeys.darkModeEnabled);
}