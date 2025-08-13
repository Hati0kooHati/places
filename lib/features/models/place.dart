import 'package:places/features/models/location_info.dart';
import 'package:uuid/uuid.dart';

final Uuid uid = Uuid();

class Place {
  final String title;
  final String imagePath;
  final LocationInfo locationInfo;

  final String id;

  Place({
    required this.title,
    required this.imagePath,
    required this.locationInfo,
    id,
  }) : id = id ?? uid.v4();

  factory Place.fromMap(Map map) {
    return Place(
      id: map["id"],
      title: map["title"],
      imagePath: map["imagePath"],
      locationInfo: map["locationInfo"],
    );
  }
}
