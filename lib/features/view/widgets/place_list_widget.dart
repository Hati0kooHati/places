import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/features/models/place.dart';
import 'package:places/features/view_model/places_view_model.dart';
import 'package:places/features/view/screens/place_detail_screen.dart';

class PlacesListdWidget extends ConsumerWidget {
  const PlacesListdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void tryAgain() {
      ref.watch(placesViewModel.notifier).tryLoadPlacesAgain();
    }

    return ref
        .watch(placesViewModel)
        .when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,

              itemBuilder: (context, index) {
                final Place place = data[index];

                return InkWell(
                  onTap: () => PlaceDetailScreen(place: place),
                  child: ListTile(
                    minTileHeight: 80,
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: FileImage(File(place.imagePath)),
                    ),

                    title: Text(place.title, style: TextStyle(fontSize: 20)),
                  ),
                );
              },
            );
          },
          error: (e, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Failed to load places",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: tryAgain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
          loading: () => Center(child: CircularProgressIndicator()),
        );
  }
}
