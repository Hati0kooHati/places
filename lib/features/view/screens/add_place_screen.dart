import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:places/core/providers/is_address_error_provider.dart';
import 'package:places/core/providers/is_image_error_provider.dart';
import 'package:places/core/providers/is_title_error_provider.dart';
import 'package:places/features/view/widgets/input_title_widget.dart';
import 'package:places/features/view_model/curr_image_view_model.dart';
import 'package:places/features/view_model/curr_location_view_model.dart';
import 'package:places/features/view_model/places_view_model.dart';
import 'package:places/features/view/widgets/input_image_widget.dart';
import 'package:places/features/view/widgets/input_location_widget.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
  }

  void addPlace() {
    if (_titleController.text.trim().isEmpty ||
        ref.watch(currImageViewModel) == null ||
        ref.watch(currLocationViewModel).address == "") {
      if (_titleController.text.trim().isEmpty) {
        ref.watch(isTitleErrorProvider.notifier).state = true;
      }

      if (ref.watch(currImageViewModel) == null) {
        ref.watch(isImageErrorProvider.notifier).state = true;
      }

      if (ref.watch(currLocationViewModel).address == "") {
        ref.watch(isAddressErrorProvider.notifier).state = true;
      }

      return;
    }

    ref
        .watch(placesViewModel.notifier)
        .addPlace(
          title: _titleController.text,
          image: ref.watch(currImageViewModel)!,
          locationInfo: ref.watch(currLocationViewModel),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Place", style: GoogleFonts.caveat(fontSize: 30)),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(50),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            top: 20,
            bottom: 150,
          ),
          child: Column(
            children: [
              InputTitleWidget(titleController: _titleController),
              const SizedBox(height: 20),
              InputImageWidget(),
              const SizedBox(height: 30),
              InputLocationWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: AddPlaceButton(addPlace: addPlace),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AddPlaceButton extends StatelessWidget {
  final void Function() addPlace;

  const AddPlaceButton({super.key, required this.addPlace});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(90),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: addPlace,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 56),
          backgroundColor: Colors.transparent,
          foregroundColor: theme.colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        label: const Text(
          "Add Place",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_circle_outline, size: 24),
      ),
    );
  }
}
