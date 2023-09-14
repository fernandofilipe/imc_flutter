import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomTextDropdown<T> extends StatelessWidget {
  final String placeholder;
  // final void Function()? onTap;
  final TextEditingController controller;
  final Widget Function(BuildContext, T) itemBuilder;
  final Function(T) onSelected;
  final FutureOr<Iterable<T>> Function(String) suggestionsCallback;
  final bool enabled;
  final Function()? clearFunction;
  final SuggestionsBoxController? suggestionsBoxController;

  const CustomTextDropdown({
    super.key,
    required this.placeholder,
    required this.controller,
    required this.itemBuilder,
    required this.onSelected,
    required this.suggestionsCallback,
    required this.enabled,
    this.suggestionsBoxController,
    this.clearFunction,
    // this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            enabled: enabled,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          suggestionsBoxController: suggestionsBoxController,
          suggestionsCallback: suggestionsCallback,
          itemBuilder: itemBuilder,
          itemSeparatorBuilder: (context, index) {
            return const Divider(
              endIndent: 16,
              indent: 16,
            );
          },
          onSuggestionSelected: onSelected,
          autoFlipDirection: true,
        ),
        if (clearFunction != null && controller.text.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: IconButton(
                onPressed: clearFunction,
                icon: const Icon(Icons.close),
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}
