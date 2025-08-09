import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/core/providers/selected_image_provider.dart';

class InputImageWidget extends ConsumerStatefulWidget {
  const InputImageWidget({super.key});

  @override
  ConsumerState<InputImageWidget> createState() => _InputImageWidgetState();
}

class _InputImageWidgetState extends ConsumerState<InputImageWidget> {
  File? chosesImage;

  void takePicture() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      chosesImage = File(pickedImage.path);
    });

    ref.read(selectedImageProvider.notifier).state = chosesImage;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: takePicture,
      icon: Icon(Icons.camera),
      label: Text("Take a Picture"),
    );

    if (chosesImage != null) {
      content = GestureDetector(
        onTap: takePicture,
        child: Image.file(
          chosesImage!,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,

      margin: EdgeInsets.all(15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(229, 255, 255, 255),
        ),
      ),
      child: content,
    );
  }
}
