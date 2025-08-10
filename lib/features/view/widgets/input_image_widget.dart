import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/core/providers/is_image_error_provider.dart';
import 'package:places/features/view_model/curr_image_view_model.dart';

class InputImageWidget extends ConsumerStatefulWidget {
  const InputImageWidget({super.key});

  @override
  ConsumerState<InputImageWidget> createState() => _InputImageWidgetState();
}

class _InputImageWidgetState extends ConsumerState<InputImageWidget> {
  void pickImage(ImageSource imageSource) async {
    final pickedImage = await ref
        .watch(currImageViewModel.notifier)
        .pickImage(imageSource);

    if (pickedImage == null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to pick image")));
      return;
    }

    ref.watch(isImageErrorProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isImageError = ref.watch(isImageErrorProvider);

    final File? currImage = ref.watch(currImageViewModel);

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
        const SizedBox(height: 12),
        Text(
          'No Image Selected',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(150),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text("Camera"),
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                elevation: 2,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text("Gallery"),
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
                backgroundColor: theme.colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ],
    );

    return Container(
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: isImageError
              ? theme.colorScheme.error
              : theme.colorScheme.outline.withAlpha(100),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: currImage != null
              ? Stack(
                  key: ValueKey(currImage.path),
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      currImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          'Failed to load image',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Row(
                        children: [
                          FloatingActionButton.small(
                            onPressed: () => pickImage(ImageSource.camera),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            tooltip: 'Take new photo',
                            child: const Icon(Icons.camera_alt_outlined),
                          ),
                          const SizedBox(width: 8),
                          FloatingActionButton.small(
                            onPressed: () => pickImage(ImageSource.gallery),
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            tooltip: 'Pick from gallery',
                            child: const Icon(Icons.photo_library_outlined),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : content,
        ),
      ),
    );
  }
}
