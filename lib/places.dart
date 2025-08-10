import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/providers/theme_data_provider.dart';
import 'package:places/features/view/screens/places_screen.dart';

class Places extends ConsumerWidget {
  const Places({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeDataModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Great Places',
      home: PlacesScreen(),
    );
  }
}
