import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:places/features/models/location_info.dart';

class MapWidget extends StatelessWidget {
  final LocationInfo locationInfo;
  final MapController mapController;
  final bool isLoading;

  const MapWidget({
    super.key,
    required this.locationInfo,
    required this.mapController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 450,
        width: double.infinity,
        child: Stack(
          children: [
            FlutterMap(
              key: ValueKey(
                "${locationInfo.longitude}-${locationInfo.latitude}",
              ),
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  locationInfo.latitude,
                  locationInfo.longitude,
                ),

                initialZoom: 7,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        locationInfo.latitude,
                        locationInfo.longitude,
                      ),
                      child: Icon(
                        Icons.location_pin,
                        color: theme.colorScheme.primary,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (isLoading)
              Container(
                color: theme.colorScheme.surface.withAlpha(150),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
