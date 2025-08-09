import 'package:flutter/material.dart';

class InputAddressWidget extends StatelessWidget {
  final TextEditingController addressEditingController;
  final void Function() search;
  final void Function() getCurrentLocation;

  const InputAddressWidget({
    super.key,
    required this.addressEditingController,
    required this.search,
    required this.getCurrentLocation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 4,
      shadowColor: theme.colorScheme.shadow.withAlpha(100),
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: addressEditingController,
        decoration: InputDecoration(
          hintText: 'Enter address (e.g., Kyrgyzstan, Chuy, Ala-Archa)',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(128),
          ),
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: theme.colorScheme.primary,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.search, color: theme.colorScheme.primary),
                tooltip: 'Search',
                onPressed: search,
                splashRadius: 24,
              ),
              IconButton(
                icon: Icon(Icons.my_location, color: theme.colorScheme.primary),
                tooltip: 'Use current location',
                onPressed: getCurrentLocation,
                splashRadius: 24,
              ),
            ],
          ),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        style: theme.textTheme.bodyLarge,
        onSubmitted: (_) => search(),
      ),
    );
  }
}
