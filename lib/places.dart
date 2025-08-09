import 'package:flutter/material.dart';
import 'package:places/features/view/screens/places_screen.dart';

class Places extends StatelessWidget {
  const Places({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Great Places',
      home: PlacesScreen(),
    );
  }
}
