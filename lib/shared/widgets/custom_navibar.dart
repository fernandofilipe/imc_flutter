import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';

class CustomNavibar extends StatelessWidget {
  final List<Widget> items;
  final Function(int)? onTap;
  final int index;
  const CustomNavibar({
    super.key,
    required this.onTap,
    required this.items,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: context.theme.colorScheme.background,
      color: Get.isDarkMode ? Colors.deepPurple : Colors.black87,
      items: items,
      onTap: onTap,
      index: index,
    );
  }
}
