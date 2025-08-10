import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/core/service/image_service.dart';

class CurrImageViewModelNotifier extends AutoDisposeNotifier<File?> {
  late final ImageService _imageService;

  @override
  build() {
    _imageService = ImageService();
    return null;
  }

  Future<File?> pickImage(ImageSource imageSource) async {
    final XFile? image = await _imageService.pickImage(imageSource);

    if (image == null) {
      return null;
    }

    final File pickedImage = File(image.path);

    state = pickedImage;

    return pickedImage;
  }
}

final currImageViewModel = AutoDisposeNotifierProvider(
  CurrImageViewModelNotifier.new,
);
