import 'package:flutter/material.dart';

class NumberUtils {
  static void formatToNumberTextEditingText(TextEditingController controller) {
    final String text = controller.text.replaceAll('.', ',');
    controller.value = controller.value.copyWith(
      text: text,
      selection: TextSelection(
        baseOffset: text.length,
        extentOffset: text.length,
      ),
      composing: TextRange.empty,
    );
  }

  static String numberToString(double value) {
    return value.toString().replaceAll(".", ",");
  }
}
