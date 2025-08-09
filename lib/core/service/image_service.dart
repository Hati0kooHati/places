import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

class ImageService {
  Future<String> saveImage(File image) async {
    final appDocDir = await syspath.getApplicationDocumentsDirectory();
    final copiedImage = await image.copy(
      "${appDocDir.path}/${path.basename(image.path)}",
    );

    return copiedImage.path;
  }
}

final imageServiceProvider = Provider((ref) => ImageService());
