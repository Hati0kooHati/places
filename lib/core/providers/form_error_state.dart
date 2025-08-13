import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormErrorState {
  final bool isAddressError;
  final bool isImageError;
  final bool isTitleError;

  const FormErrorState({
    required this.isAddressError,
    required this.isImageError,
    required this.isTitleError,
  });

  FormErrorState copyWith({
    bool? isAddressError,
    bool? isImageError,
    bool? isTitleError,
  }) {
    return FormErrorState(
      isAddressError: isAddressError ?? this.isAddressError,
      isImageError: isImageError ?? this.isImageError,
      isTitleError: isTitleError ?? this.isTitleError,
    );
  }
}

final formErrorStateProvider = AutoDisposeStateProvider(
  (ref) => FormErrorState(
    isAddressError: false,
    isImageError: false,
    isTitleError: false,
  ),
);
