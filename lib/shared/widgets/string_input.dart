import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/shared/layout/theme.dart';

class StringInput extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final bool readOnly;
  const StringInput({
    super.key,
    required this.hint,
    this.controller,
    this.widget,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      autofocus: false,
      cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
      controller: controller,
      style: subTitleStyle,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: subTitleStyle,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: context.theme.colorScheme.background,
            width: 0,
          ),
        ),
      ),
    );
  }
}
