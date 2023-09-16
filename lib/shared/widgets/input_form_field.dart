import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputFormField extends StatelessWidget {
  final String title;
  final Widget? widget;
  final Widget? sufixWidget;
  const InputFormField({
    super.key,
    required this.title,
    required this.widget,
    this.sufixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.isDarkMode
                ? Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface)
                : Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          Row(
            children: [
              widget == null ? Container() : Expanded(child: widget!),
              sufixWidget == null ? Container() : Container(child: sufixWidget),
            ],
          ),
        ],
      ),
    );
  }
}
