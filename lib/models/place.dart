import 'dart:io';

import 'package:places/models/location_place.dart';
import 'package:uuid/uuid.dart';

final Uuid uid = Uuid();

class Place {
  final String title;
  final File image;
  final LocationPlace? locationPlace;

  final String id;

  Place({required this.title, required this.image, this.locationPlace})
    : id = uid.v4();
}
