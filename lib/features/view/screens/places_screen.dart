import 'package:flutter/material.dart';
import 'package:places/features/view/screens/add_place_screen.dart';
import 'package:places/features/view/widgets/place_list_widget.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPlaceScreen()),
              );
            },
            icon: Icon(Icons.add, size: 40),
          ),
        ],
      ),
      body: PlacesListdWidget(),
    );
  }
}
