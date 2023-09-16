import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/services/theme_services.dart';
import 'package:imc_flutter/shared/colors.dart';
import 'dart:math' as math;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isEditingAppBar;
  const CustomAppBar({super.key, this.isEditingAppBar = false});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 50);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: widget.isEditingAppBar
          ? null
          : GestureDetector(
              onTap: () {
                ThemeService().switchTheme();
              },
              child: Transform.rotate(
                angle: 315 * math.pi / 180,
                child: Get.isDarkMode
                    ? const Icon(Icons.wb_sunny_outlined, size: 20)
                    : const Icon(
                        Icons.nightlight_outlined,
                        size: 20,
                        color: AppColors.darkGreyClr,
                      ),
              ),
            ),
      actions: [
        InkWell(
          onTap: () async {
            // await Get.to(
            //   () => const ProfilePage(),
            //   preventDuplicates: true,
            // );
          },
          child: CircleAvatar(
            child: Text(box.read('initials')),
          ),
        ),
        const SizedBox(width: 20)
      ],
    );
  }
}
