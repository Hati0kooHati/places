import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/providers/places.dart';
import 'package:places/providers/selected_image.dart';
import 'package:places/widgets/input_image.dart';
import 'package:places/widgets/input_location.dart';

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
        .read(placesProvider.notifier)
        .savePlace(
          title: _titleController.text,
          image: ref.read(selectedImageProvider)!,
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
