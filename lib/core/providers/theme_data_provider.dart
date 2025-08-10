import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeDataModeNotifier extends Notifier<ThemeData> {
  @override
  build() {
    return ThemeData.dark();
  }

  void changeTheme() {
    if (state.brightness == Brightness.dark) {
      state = ThemeData.light();
    } else {
      state = ThemeData.dark();
    }
  }
}

final themeDataModeProvider = NotifierProvider(ThemeDataModeNotifier.new);
