import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/features/models/location_info.dart';
import 'package:places/features/models/place.dart';

import 'package:places/core/repository/places_repository.dart';
import 'package:places/core/service/image_service.dart';
import 'package:places/features/view/screens/add_place_screen.dart';

class PlacesViewModelNotifier extends AsyncNotifier<List<Place>> {
  late final PlacesRepository _placesRepo;
  late final ImageService _imageService;

  @override
  build() async {
    _placesRepo = ref.watch(placesReposotoryProvider);
    _imageService = ref.watch(imageServiceProvider);

    return await _placesRepo.loadPlaces();
  }

  void addPlace({
    required String title,
    required File image,
    required LocationInfo locationInfo,
  }) async {
    state = await AsyncValue.guard(() async {
      final String copiedImagePath = await _imageService.saveImage(image);

      final Place newPlace = Place(
        title: title,
        imagePath: copiedImagePath,
        locationInfo: locationInfo,
      );

      _placesRepo.addPlace(newPlace);

      return [newPlace, ...state.value!];
    });
  }
}

final placesViewModel =
    AsyncNotifierProvider<PlacesViewModelNotifier, List<Place>>(
      PlacesViewModelNotifier.new,
    );
