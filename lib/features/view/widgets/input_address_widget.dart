import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/providers/is_address_error_provider.dart';
import 'package:places/features/view_model/curr_location_view_model.dart';

class InputAddressWidget extends ConsumerWidget {
  final TextEditingController addressEditingController;
  final void Function() search;
  final void Function() getCurrentLocation;
  final bool isLoading;

  const InputAddressWidget({
    super.key,
    required this.addressEditingController,
    required this.search,
    required this.getCurrentLocation,
    required this.isLoading,
  });

  void addressFieldOnChanged({
    required bool isAddressError,
    required WidgetRef ref,
  }) {
    if (isAddressError) {
      ref.watch(isAddressErrorProvider.notifier).state = false;
    }
  }

  void clearAddress({required WidgetRef ref}) {
    ref.watch(currLocationViewModel.notifier).clearAddress();
    addressEditingController.text = "";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final bool isAddressError = ref.watch(isAddressErrorProvider);

    return Material(
      elevation: 4,
      shadowColor: theme.colorScheme.shadow.withAlpha(100),
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: addressEditingController,
        onChanged: (_) =>
            addressFieldOnChanged(isAddressError: isAddressError, ref: ref),
        decoration: InputDecoration(
          hintText: 'Enter address (e.g., Kyrgyzstan, Chuy, Ala-Archa)',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(128),
          ),
          prefixIcon: IconButton(
            onPressed: () => clearAddress(ref: ref),
            icon: Icon(Icons.close),
            color: theme.colorScheme.primary,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAddressError)
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
              IconButton(
                icon: Icon(Icons.search, color: theme.colorScheme.primary),
                tooltip: 'Search',
                onPressed: isLoading ? null : search,
                splashRadius: 24,
              ),
              IconButton(
                icon: Icon(Icons.my_location, color: theme.colorScheme.primary),
                tooltip: 'Use current location',
                onPressed: isLoading ? null : getCurrentLocation,
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
