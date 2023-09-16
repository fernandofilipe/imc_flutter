import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final double? width;
  final double? height;
  const CustomButton(
      {super.key,
      required this.label,
      required this.onTap,
      this.width = 120,
      this.height = 45});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Get.isDarkMode
              ? Theme.of(context).colorScheme.inversePrimary
              : Theme.of(context).colorScheme.tertiary,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
