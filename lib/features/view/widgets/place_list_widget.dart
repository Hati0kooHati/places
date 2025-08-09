import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/features/models/place.dart';
import 'package:places/features/view_model/places_view_model.dart';
import 'package:places/features/view/screens/place_detail_screen.dart';

class PlacesListdWidget extends ConsumerStatefulWidget {
  const PlacesListdWidget({super.key});

  ConsumerState<PlacesListdWidget> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesListdWidget> {
  void onListTileTap({required Place place, required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlaceDetailScreen(place: place)),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(placesViewModel)
        .when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,

              itemBuilder: (context, index) {
                final Place place = data[index];

                return InkWell(
                  onTap: () => onListTileTap(place: place, context: context),
                  child: ListTile(
                    minTileHeight: 80,
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: FileImage(File(place.imagePath)),
                    ),

                    title: Text(place.title, style: TextStyle(fontSize: 20)),
                  ),
                );
              },
            );
          },
          error: (e, stack) => Center(child: Text("$e, $stack")),
          loading: () => Center(child: CircularProgressIndicator()),
        );
  }
}
