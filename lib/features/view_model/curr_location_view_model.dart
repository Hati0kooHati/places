import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/repository/app_repository.dart';
import 'package:places/features/models/location_info.dart';

class CurrLocationViewModelNotifier extends AutoDisposeNotifier<LocationInfo> {
  late final AppRepository _appRepository;

  @override
  build() {
    _appRepository = ref.watch(appRepositoryProvider);

    return LocationInfo(latitude: 0, longitude: 0, address: "");
  }

  Future<LocationInfo?> getCurrentLocation() async {
    final LocationInfo? locationInfo = await _appRepository.currentLocation;

    if (locationInfo == null) {
      return null;
    }

    state = locationInfo;

    return locationInfo;
  }

  Future<LocationInfo?> searchByAddress({required String address}) async {
    final LocationInfo? locationInfo = await _appRepository.searchByAddress(
      address: address,
    );

    if (locationInfo == null) {
      return null;
    }

    state = locationInfo;
    return locationInfo;
  }

  Future<LocationInfo?> searchByLatLng({
    required double latitude,
    required double longitude,
  }) async {
    final LocationInfo? locationInfo = await _appRepository.searchByLatLng(
      latitude: latitude,
      longitude: longitude,
    );

    if (locationInfo == null) {
      return null;
    }

    state = locationInfo;
    return locationInfo;
  }

  void clearAddress() {
    state = state.copyWith(address: "");
  }
}

final currLocationViewModel = AutoDisposeNotifierProvider(
  CurrLocationViewModelNotifier.new,
);
