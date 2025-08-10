import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:places/features/models/location_info.dart';
import 'package:places/core/service/location_service.dart';

class CurrLocationViewModelNotifier extends AutoDisposeNotifier<LocationInfo> {
  late final LocationService _locationService;

  @override
  build() {
    _locationService = ref.watch(locationProvider);
    return LocationInfo(
      latitude: 42.543099,
      longitude: 74.4791903,
      address: "",
    );
  }

  Future<LocationInfo?> getCurrentLocation() async {
    final LocationData? currLocation = await _locationService
        .getCurrentLocation();

    if (currLocation == null) {
      return null;
    }

    final LocationInfo? locationInfo = await _locationService.searchByLatLng(
      latitude: currLocation.latitude!,
      longitude: currLocation.longitude!,
    );

    if (locationInfo == null) {
      return null;
    }

    state = locationInfo;

    return locationInfo;
  }

  Future<LocationInfo?> searchByAddress({required String address}) async {
    final LocationInfo? locationInfo = await _locationService.searchByAddress(
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
    final LocationInfo? locationInfo = await _locationService.searchByLatLng(
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
