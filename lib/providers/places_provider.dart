import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/location_place.dart';
import 'package:places/models/place.dart';

import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> get database async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "places.db"),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, imageFile TEXT, lat REAL, lng REAL, address TEXT)",
      );
    },
    version: 1,
  );

  return db;
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  Future<void> loadPlaces() async {
    final db = await database;

    final userPlaces = await db.query("user_places");

    final List<Place> placesList = userPlaces
        .map(
          (Map<String, dynamic> row) => Place(
            title: row["title"],
            image: File(row["imagePath"]),
            locationPlace: LocationPlace(
              lat: row["lat"],
              lng: row["lng"],
              address: row["address"],
            ),
          ),
        )
        .toList();

    state = placesList;
  }

  void savePlace({required String title, required File image}) async {
    final appDocDir = await syspath.getApplicationDocumentsDirectory();
    final copiedImage = await image.copy(
      "${appDocDir.path}/${path.basename(image.path)}",
    );

    final Place newPlace = Place(
      title: title,
      image: copiedImage,
      locationPlace: LocationPlace(lat: 1, lng: 1, address: "address"),
    );

    final db = await database;

    db.insert("user_places", {
      "id": newPlace.id,
      "title": newPlace.title,
      "imagePath": newPlace.image.path,
      "lat": newPlace.locationPlace!.lat,
      "lng": newPlace.locationPlace!.lng,
      "address": newPlace.locationPlace!.address,
    });

    state = [newPlace, ...state];
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
