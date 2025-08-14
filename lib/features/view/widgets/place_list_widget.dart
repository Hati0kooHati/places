import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/features/models/place.dart';
import 'package:places/features/view/widgets/place_card_widget.dart';
import 'package:places/features/view_model/places_view_model.dart';
import 'package:places/features/view/screens/place_detail_screen.dart';

class PlacesListWidget extends ConsumerWidget {
  const PlacesListWidget({super.key});

  void tryAgain(WidgetRef ref) {
    ref.watch(placesViewModel.notifier).tryLoadPlacesAgain();
  }

  void navigateToPlaceDetails({
    required BuildContext context,
    required Place place,
  }) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(place: place)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(placesViewModel)
        .when(
          data: (data) {
            if (data.isEmpty) {
              return Center(
                child: Text(
                  "No places found...",
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              );
            }
            return ListView.builder(
              itemCount: data.length,

              itemBuilder: (context, index) {
                final Place place = data[index];

                return PlaceCardWidget(
                  key: ValueKey(place.id),
                  place: place,
                  navigateToPlaceDetails: navigateToPlaceDetails,
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
                  onPressed: () => tryAgain(ref),
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
