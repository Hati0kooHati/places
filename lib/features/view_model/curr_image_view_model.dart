import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:places/core/repository/app_repository.dart';

class CurrImageViewModelNotifier extends AutoDisposeNotifier<File?> {
  late final AppRepository _appRepository;

  @override
  build() {
    _appRepository = ref.read(appRepositoryProvider);
    return null;
  }

  Future<File?> pickImage(ImageSource imageSource) async {
    final File? image = await _appRepository.pickImage(imageSource);

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
