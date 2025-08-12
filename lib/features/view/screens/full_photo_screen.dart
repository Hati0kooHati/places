import 'dart:io';
import 'package:flutter/material.dart';

class FullPhotoScreen extends StatelessWidget {
  final String imagePath;

  const FullPhotoScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Interactive image viewer
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.contain,
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
                  Colors.black.withAlpha(80),
                  Colors.transparent,
                  Colors.black.withAlpha(80),
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withAlpha(200),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.onSurface,
                  size: 28,
                ),
                splashColor: theme.colorScheme.primary.withAlpha(100),
                tooltip: 'Back',
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
