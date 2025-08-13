import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/data/app_preferences.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  build() {
    final prefs = AppPreferences.prefs;

    final themeMode = prefs.getString("themeMode") ?? ThemeMode.system.name;

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

    final prefs = AppPreferences.prefs;
    prefs.setString("themeMode", newThemeMode.name);
  }
}

final themeModeProvider = NotifierProvider(ThemeModeNotifier.new);
