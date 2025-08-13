import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  const AppPreferences._();

  static late final SharedPreferences _prefs;

  static SharedPreferences get prefs {
    return _prefs;
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
