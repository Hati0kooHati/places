import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  build() {
    return ThemeMode.dark;
  }

  void setThemeMode(ThemeMode newThemeMode) {
    state = newThemeMode;
  }
}

final themeModeProvider = NotifierProvider(ThemeModeNotifier.new);
