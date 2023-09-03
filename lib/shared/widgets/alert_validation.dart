import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertValidation {
  static showCustomSnackbar({
    required String title,
    required String message,
  }) {
    Get.closeAllSnackbars();
    return Get.snackbar(
      title,
      message,
      icon: const Icon(
        Icons.warning_amber_rounded,
      ),
      backgroundColor: !Get.isDarkMode
          ? Colors.white.withOpacity(0.6)
          : const Color(0xFF303030).withOpacity(0.5),
      overlayBlur: 2,
      shouldIconPulse: true,
    );
  }
}
