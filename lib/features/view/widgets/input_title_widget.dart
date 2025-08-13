import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/core/providers/form_error_state.dart';

class InputTitleWidget extends ConsumerWidget {
  final TextEditingController titleController;

  const InputTitleWidget({super.key, required this.titleController});

  void titleFieldOnChanged({
    required bool isTitleError,
    required WidgetRef ref,
  }) {
    if (isTitleError) {
      ref.read(formErrorStateProvider.notifier).state = ref
          .read(formErrorStateProvider.notifier)
          .state
          .copyWith(isTitleError: false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isTitleError = ref.watch(formErrorStateProvider).isTitleError;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(90),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Theme.of(context).colorScheme.surface.withAlpha(130),
            offset: const Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: titleController,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),

        onChanged: (_) =>
            titleFieldOnChanged(isTitleError: isTitleError, ref: ref),
        decoration: InputDecoration(
          label: const Text("Title"),
          labelStyle: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant.withAlpha(170),
            fontSize: 14,
          ),
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          prefixIcon: Icon(
            Icons.edit_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          suffixIcon: isTitleError
              ? Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                )
              : null,
        ),
      ),
    );
  }
}
