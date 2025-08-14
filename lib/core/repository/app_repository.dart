import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:places/core/service/image_service.dart';
import 'package:places/core/service/location_service.dart';
import 'package:places/core/service/places_service.dart';
import 'package:places/features/models/location_info.dart';
import 'package:places/features/models/place.dart';

class AppRepository {
  final ImageService _imageService;
  final LocationService _locationService;
  final PlacesService _placesService;

  AppRepository({
    required imageService,
    required locationService,
    required placesService,
  }) : _imageService = imageService,
       _locationService = locationService,
       _placesService = placesService;

  Future<File?> pickImage(ImageSource imageSource) async {
    try {
      return await _imageService.pickImage(imageSource);
    } catch (e) {
      return null;
    }
  }

  Future<Place?> addPlace({
    required String title,
    required File image,
    required LocationInfo locationInfo,
  }) async {
    try {
      final String copiedImagePath = await _imageService.saveImage(image);

      final Place newPlace = Place(
        title: title,
        imagePath: copiedImagePath,
        locationInfo: locationInfo,
      );

      _placesService.addPlace(newPlace);
      return newPlace;
    } catch (e) {
      return null;
    }
  }

  Future<List<Place>> loadPlaces() async {
    return await _placesService.loadPlaces();
  }

  Future<LocationInfo?> get currentLocation async {
    final LocationData? currLocation = await _locationService
        .getCurrentLocation();

    if (currLocation == null) {
      return null;
    }

    final LocationInfo? locationInfo = await _locationService.searchByLatLng(
      latitude: currLocation.latitude!,
      longitude: currLocation.longitude!,
    );

    return locationInfo;
  }

  Future<LocationInfo?> searchByAddress({required String address}) async {
    return await _locationService.searchByAddress(address: address);
  }

  Future<LocationInfo?> searchByLatLng({
    required double latitude,
    required double longitude,
  }) async {
    return await _locationService.searchByLatLng(
      latitude: latitude,
      longitude: longitude,
    );
  }
}

final appRepositoryProvider = Provider<AppRepository>((ref) {
  final ImageService imageService = ref.read(imageServiceProvider);
  final LocationService locationService = ref.read(locationServiceProvider);
  final PlacesService placesService = ref.read(placesServiceProvider);

  return AppRepository(
    imageService: imageService,
    locationService: locationService,
    placesService: placesService,
  );
});
