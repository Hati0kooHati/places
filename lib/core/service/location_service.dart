import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:places/features/models/location_info.dart';

class LocationService {
  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    locationData = await location.getLocation();

    return locationData;
  }

  Future<LocationInfo?> searchByLatLng({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=0",
    );
    final response = await http.get(
      url,
      headers: {'User-Agent': 'places/1.0 (dserion.prn@gmail.com)'},
    );

    if (response.statusCode == 404) {
      return null;
    }

    final data = jsonDecode(response.body) as Map;

    if (data.isEmpty) {
      return null;
    }

    final LocationInfo locationInfo = LocationInfo(
      latitude: latitude,
      longitude: longitude,
      address: data["display_name"],
    );

    return locationInfo;
  }

  Future<LocationInfo?> searchByAddress({required String address}) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$address&format=json&polygon_kml=1&addressdetails=0",
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'places/1.0 (dserion.prn@gmail.com)'},
    );

    if (response.statusCode == 404) {
      return null;
    }

    final data = jsonDecode(response.body) as List;

    if (data.isEmpty) {
      return null;
    }

    final Map result = data[0];

    final LocationInfo locationInfo = LocationInfo(
      latitude: double.parse(result["lat"]),
      longitude: double.parse(result["lon"]),
      address: result["display_name"],
    );

    return locationInfo;
  }
}

final locationProvider = Provider<LocationService>((ref) => LocationService());
