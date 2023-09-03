import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/shared/layout/theme.dart';

class CustomBottomSheetButton extends StatelessWidget {
  final Function()? onTap;
  final bool isCloseButton;
  final Color color;
  final String label;
  final BuildContext context;

  const CustomBottomSheetButton({
    super.key,
    required this.label,
    required this.color,
    required this.context,
    this.isCloseButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isCloseButton
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isCloseButton ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style: isCloseButton
                ? Get.isDarkMode
                    ? titleStyle.copyWith(color: Colors.white)
                    : titleStyle.copyWith(color: Colors.black)
                : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
