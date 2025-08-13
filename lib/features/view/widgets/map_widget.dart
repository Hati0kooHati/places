import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:places/features/models/location_info.dart';

class MapWidget extends StatefulWidget {
  final LocationInfo locationInfo;
  final MapController mapController;
  final bool isLoading;

  final void Function({required double latitude, required double longitude})
  searchByLatLng;

  const MapWidget({
    super.key,
    required this.locationInfo,
    required this.mapController,
    required this.isLoading,
    required this.searchByLatLng,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  void moveMap() {
    widget.mapController.move(
      LatLng(widget.locationInfo.latitude, widget.locationInfo.longitude),
      widget.mapController.camera.zoom,
    );
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    if ((oldWidget.locationInfo.longitude != widget.locationInfo.longitude ||
            oldWidget.locationInfo.latitude != widget.locationInfo.latitude) &&
        !widget.isLoading) {
      moveMap();
    }
    super.didUpdateWidget(oldWidget);
  }

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
              mapController: widget.mapController,
              options: MapOptions(
                onTap: (tapPosition, point) => widget.searchByLatLng(
                  latitude: point.latitude,
                  longitude: point.longitude,
                ),
                initialCenter: LatLng(
                  widget.locationInfo.latitude,
                  widget.locationInfo.longitude,
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
                        widget.locationInfo.latitude,
                        widget.locationInfo.longitude,
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

            if (widget.isLoading)
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
