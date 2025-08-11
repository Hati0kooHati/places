import 'dart:io';

import 'package:flutter/material.dart';
import 'package:places/features/models/place.dart';

class PlaceCardWidget extends StatelessWidget {
  final Place place;
  final void Function({required BuildContext context, required Place place})
  navigateToPlaceDetails;

  const PlaceCardWidget({
    super.key,
    required this.place,
    required this.navigateToPlaceDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => navigateToPlaceDetails(context: context, place: place),
      splashColor: theme.colorScheme.primary.withAlpha(51),
      highlightColor: theme.colorScheme.primary.withAlpha(25),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withAlpha(37),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            minVerticalPadding: 12,
            leading: Hero(
              tag: 'place_image_${place.imagePath}',
              child: CircleAvatar(
                radius: 32,
                backgroundImage: FileImage(File(place.imagePath)),
                backgroundColor: theme.colorScheme.surfaceContainerLowest,
                onBackgroundImageError: (_, __) => Icon(
                  Icons.broken_image,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 32,
                ),
              ),
            ),
            title: Text(
              place.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              place.locationInfo.address,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withAlpha(180),
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            onTap: () => navigateToPlaceDetails(context: context, place: place),
          ),
        ),
      ),
    );
  }
}
