import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/data/local_database.dart';
import 'package:places/features/models/place.dart';
import 'package:sqflite/sqflite.dart';

class PlacesService {
  final Database _db;

  const PlacesService({required db}) : _db = db;

  Future<List<Place>> loadPlaces() async {
    final userPlaces = await _db.query("user_places");

    final List<Place> placesList = userPlaces
        .map((Map map) => Place.fromMap(map))
        .toList();

    return placesList;
  }

  void addPlace(Place newPlace) async {
    final db = LocalDatabase.db;

    await db.insert("user_places", newPlace.toMap());
  }
}

final placesServiceProvider = Provider(
  (ref) => PlacesService(db: LocalDatabase.db),
);
