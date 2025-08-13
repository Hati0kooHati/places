import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/data/local_database.dart';
import 'package:places/features/models/place.dart';

class PlacesService {
  Future<List<Place>> loadPlaces() async {
    final db = await LocalDatabase.db;
    final userPlaces = await db.query("user_places");

    final List<Place> placesList = userPlaces
        .map((Map map) => Place.fromMap(map))
        .toList();

    return placesList;
  }

  void addPlace(Place newPlace) async {
    final db = await LocalDatabase.db;

    await db.insert("user_places", newPlace.toMap());
  }
}

final placesServiceProvider = Provider((ref) => PlacesService());
