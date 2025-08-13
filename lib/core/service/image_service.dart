import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

class ImageService {
  final _imagePicker = ImagePicker();

  Future<String> saveImage(File image) async {
    final appDocDir = await syspath.getApplicationDocumentsDirectory();
    final copiedImage = await image.copy(
      "${DateTime.now()}${appDocDir.path}/${path.basename(image.path)}",
    );

    return copiedImage.path;
  }

  Future<File?> pickImage(ImageSource imageSource) async {
    final pickedImage = await _imagePicker.pickImage(source: imageSource);

    if (pickedImage == null) {
      return null;
    }

    return File(pickedImage.path);
  }
}

final imageServiceProvider = Provider((ref) => ImageService());
