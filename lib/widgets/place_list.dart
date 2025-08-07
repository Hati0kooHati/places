import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place.dart';
import 'package:places/providers/places.dart';
import 'package:places/screens/place_detail.dart';

class PlacesListdWidget extends ConsumerStatefulWidget {
  PlacesListdWidget({super.key});

  ConsumerState<PlacesListdWidget> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesListdWidget> {
  void onListTileTap({required Place place, required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlaceDetailScreen(place: place)),
    );
  }

  late Future<void> placesFuture;

  @override
  void initState() {
    super.initState();
    placesFuture = ref.read(placesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final List<Place> placesList = ref.watch(placesProvider);

    return FutureBuilder(
      future: placesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Occured an Error, restart ${snapshot.error}",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            );
          }

          if (placesList.isEmpty) {
            return Center(
              child: Text(
                "No places found...",
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            );
          }

          return ListView.builder(
            itemCount: placesList.length,

            itemBuilder: (context, index) {
              final Place place = placesList[index];

              return InkWell(
                onTap: () {
                  onListTileTap(place: place, context: context);
                },
                child: ListTile(
                  minTileHeight: 80,
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: FileImage(place.image),
                  ),

                  title: Text(place.title, style: TextStyle(fontSize: 20)),
                ),
              );
            },
          );
        }

        return Text("error");
      },
    );
  }
}
