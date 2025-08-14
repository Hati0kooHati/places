import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/data/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeNotifier({required prefs}) : _prefs = prefs;

  @override
  build() {
    final themeMode = _prefs.getString("themeMode") ?? ThemeMode.system.name;

    if (themeMode == ThemeMode.dark.name) {
      return ThemeMode.dark;
    } else if (themeMode == ThemeMode.light.name) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode newThemeMode) {
    state = newThemeMode;

    _prefs.setString("themeMode", newThemeMode.name);
  }
}

final themeModeProvider = NotifierProvider(
  () => ThemeModeNotifier(prefs: AppPreferences.prefs),
);
