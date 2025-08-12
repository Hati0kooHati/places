import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:places/features/models/place.dart';
import 'package:places/features/view/screens/full_photo_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailScreen({super.key, required this.place});

  void navigateToFullPhotoScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullPhotoScreen(imagePath: place.imagePath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    return Scaffold(
      body: GestureDetector(
        onTap: () => navigateToFullPhotoScreen(context),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: isPortrait ? 400 : 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  place.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                    shadows: [
                      Shadow(color: Colors.black.withAlpha(125), blurRadius: 4),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: place.id,
                      child: Image.file(
                        File(place.imagePath),
                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) => Container(
                          color: theme.colorScheme.surfaceContainerLowest,
                          child: Icon(
                            Icons.broken_image,
                            size: 100,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withAlpha(75),
                            Colors.transparent,
                            Colors.black.withAlpha(125),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 2,
              shadowColor: theme.colorScheme.shadow.withAlpha(75),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      place.locationInfo.address,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Map Preview
                    Card(
                      elevation: 4,
                      shadowColor: theme.colorScheme.shadow.withAlpha(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                place.locationInfo.latitude,
                                place.locationInfo.longitude,
                              ),
                              initialZoom: 12,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(
                                      place.locationInfo.latitude,
                                      place.locationInfo.longitude,
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Text(
                    //   'Details',
                    //   style: theme.textTheme.titleLarge?.copyWith(
                    //     fontWeight: FontWeight.bold,
                    //     color: theme.colorScheme.primary,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    // Text(
                    //   'Add more details about this place here.',
                    //   style: theme.textTheme.bodyLarge?.copyWith(
                    //     color: theme.colorScheme.onSurfaceVariant,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
