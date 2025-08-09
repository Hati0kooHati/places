import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:places/features/models/location_info.dart';
import 'package:places/features/view/widgets/input_address_widget.dart';
import 'package:places/features/view/widgets/map_widget.dart';
import 'package:places/features/view_model/curr_location_view_model.dart';

class InputLocationWidget extends ConsumerStatefulWidget {
  const InputLocationWidget({super.key});

  @override
  ConsumerState<InputLocationWidget> createState() =>
      _InputLocationWidgetState();
}

class _InputLocationWidgetState extends ConsumerState<InputLocationWidget> {
  late final TextEditingController _addressEditingController;
  late final MapController _mapController;
  late bool isLoading;

  void getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    final result = await ref
        .watch(currLocationViewModel.notifier)
        .getCurrentLocation();

    if (result == null && mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to get current location")),
      );
    }

    setState(() {
      isLoading = false;
      _addressEditingController.text = ref.watch(currLocationViewModel).address;
    });
  }

  void search() async {
    if (_addressEditingController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await ref
        .watch(currLocationViewModel.notifier)
        .search(address: _addressEditingController.text);

    if (result == null && mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to search location")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _addressEditingController = TextEditingController();
    _mapController = MapController();
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    _addressEditingController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_addressEditingController.text.isEmpty) {
      _addressEditingController.text = ref.watch(currLocationViewModel).address;
    }

    final LocationInfo locationInfo = ref.watch(currLocationViewModel);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputAddressWidget(
              addressEditingController: _addressEditingController,
              search: search,
              getCurrentLocation: getCurrentLocation,
            ),
            const SizedBox(height: 24),

            MapWidget(
              locationInfo: locationInfo,
              mapController: _mapController,
              isLoading: isLoading,
            ),

            const SizedBox(height: 16),

            AnimatedOpacity(
              opacity: locationInfo.address.isNotEmpty ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  locationInfo.address.isNotEmpty
                      ? 'Current: ${locationInfo.address}'
                      : '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
