import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/repository/app_repository.dart';
import 'package:places/features/models/location_info.dart';
import 'package:places/features/models/place.dart';

class PlacesViewModelNotifier extends AsyncNotifier<List<Place>> {
  late final AppRepository _appRepository;

  @override
  build() async {
    _appRepository = ref.read(appRepositoryProvider);

    return await _appRepository.loadPlaces();
  }

  Future<Place?> addPlace({
    required String title,
    required File image,
    required LocationInfo locationInfo,
  }) async {
    final Place? newPlace = await _appRepository.addPlace(
      title: title,
      image: image,
      locationInfo: locationInfo,
    );

    if (newPlace == null) {
      return null;
    }

    state = AsyncData([newPlace, ...state.value!]);
    return newPlace;
  }

  void tryLoadPlacesAgain() async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() => _appRepository.loadPlaces());
  }
}

final placesViewModel =
    AsyncNotifierProvider<PlacesViewModelNotifier, List<Place>>(
      PlacesViewModelNotifier.new,
    );
