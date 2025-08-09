import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/features/view_model/curr_location_view_model.dart';
import 'package:places/features/view_model/places_view_model.dart';
import 'package:places/core/providers/selected_image_provider.dart';
import 'package:places/features/view/widgets/input_image_widget.dart';
import 'package:places/features/view/widgets/input_location_widget.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  late final TextEditingController _titleController;

  String errorText = "";

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

  void savePlace() {
    if (_titleController.text.trim().isEmpty ||
        ref.read(selectedImageProvider) == null) {
      setState(() {
        errorText = "Enter title";
      });
      return;
    }

    setState(() {
      errorText = "";
    });

    ref
        .watch(placesViewModel.notifier)
        .savePlace(
          title: _titleController.text,
          image: ref.watch(selectedImageProvider)!,
          locationInfo: ref.watch(currLocationViewModel),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new Place")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _titleController,
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                decoration: InputDecoration(
                  label: const Text("Title"),
                  errorText: errorText.isNotEmpty ? errorText : null,
                ),
              ),
            ),

            InputImageWidget(),

            InputLocationWidget(),

            ElevatedButton.icon(
              onPressed: savePlace,
              style: ElevatedButton.styleFrom(minimumSize: const Size(140, 50)),
              label: const Text("Add Place"),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
