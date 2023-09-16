import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/shared/colors.dart';
import 'package:imc_flutter/shared/widgets/custom_bottom_sheet_button.dart';

class EditBottomSheet extends StatefulWidget {
  final String? editTitle;
  final String? deleteTitle;
  final String? closeTitle;
  final Function() onEditAction;
  final Function() onDeleteAction;
  final BuildContext buildContext;
  const EditBottomSheet({
    super.key,
    required this.onEditAction,
    required this.onDeleteAction,
    required this.buildContext,
    this.editTitle = "Editar Item",
    this.deleteTitle = "Deletar Item",
    this.closeTitle = "Fechar",
  });

  @override
  State<EditBottomSheet> createState() => _EditBottomSheetState();
}

class _EditBottomSheetState extends State<EditBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4),
      height: MediaQuery.of(widget.buildContext).size.height * 0.32,
      width: double.infinity,
      color: Get.isDarkMode ? AppColors.darkGreyClr : Colors.white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
            ),
          ),
          const Spacer(),
          CustomBottomSheetButton(
            label: widget.editTitle!,
            color: AppColors.primaryClr,
            context: widget.buildContext,
            onTap: widget.onEditAction,
          ),
          CustomBottomSheetButton(
            label: widget.deleteTitle!,
            color: Colors.red[300]!,
            context: widget.buildContext,
            onTap: widget.onDeleteAction,
          ),
          const SizedBox(height: 20),
          CustomBottomSheetButton(
            label: widget.closeTitle!,
            color: Colors.white,
            context: widget.buildContext,
            isCloseButton: true,
            onTap: () {
              Get.back();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
