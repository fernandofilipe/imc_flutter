import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNavibarItem extends StatelessWidget {
  final IconData icon;
  final double size;
  const CustomNavibarItem({super.key, required this.icon, this.size = 30.0});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color:
          Get.isDarkMode ? Colors.white : Theme.of(context).primaryColorLight,
    );
  }
}
