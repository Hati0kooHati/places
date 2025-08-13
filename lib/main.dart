import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/data/app_preferences.dart';
import 'package:places/core/data/local_database.dart';
import 'package:places/places.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabase.init();
  await AppPreferences.init();

  runApp(const ProviderScope(child: Places()));
}
