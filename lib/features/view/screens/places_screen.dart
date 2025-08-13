import 'package:flutter/material.dart';
import 'package:places/features/view/screens/add_place_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:places/features/view/screens/settings_screen.dart';
import 'package:places/features/view/widgets/place_list_widget.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  void navigateToSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Places', style: GoogleFonts.caveat(fontSize: 40)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(50),
        actions: [
          IconButton(
            onPressed: () => navigateToSettingsScreen(context),
            icon: Icon(Icons.settings, size: 28),
            color: theme.colorScheme.onPrimary,
            tooltip: 'Settings',
            splashRadius: 24,
          ),
        ],
      ),
      body: PlacesListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPlaceScreen()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        tooltip: 'Add New Place',
        child: Icon(Icons.add, size: 40),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
