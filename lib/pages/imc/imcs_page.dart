import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/controllers/imc_controller.dart';
import 'package:imc_flutter/models/imc.dart';
import 'package:imc_flutter/shared/colors.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:imc_flutter/shared/widgets/custom_bottom_sheet_button.dart';
import 'package:imc_flutter/shared/widgets/custom_datepicker.dart';
import 'package:imc_flutter/shared/widgets/imc_tile.dart';
import 'package:imc_flutter/shared/widgets/input_form_field.dart';
import 'package:imc_flutter/shared/widgets/number_input.dart';
import 'package:imc_flutter/shared/widgets/string_input.dart';

import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:imc_flutter/shared/utils/number_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImcController _imcController = Get.put(ImcController());

  final startDate = DateTime(2023, 01, 01);
  DateTime _selectedDate = DateTime.now();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _imcController.init(_selectedDate);
  }

  @override
  void dispose() {
    super.dispose();
    _imcController.calendarInputFieldController.dispose();
    _imcController.weightController.dispose();
    _imcController.heightController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _showAppHeader(),
        _showCalendarFilter(),
        const SizedBox(height: 10),
        _showImcList(),
      ],
    );
  }

  _showAppHeader() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd(Constants.appLocale).format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                Constants.appTitle,
                style: headingStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _showCalendarFilter() {
    return Container(
      margin: const EdgeInsets.only(top: 12, left: 19),
      child: CustomDatePicker(
        startDate: startDate,
        selectedDate: _selectedDate,
        controller: _imcController.datePickerController,
        onDateChanged: (date) {
          _selectedDate = date;
          _imcController.getImcs(date);
        },
      ),
    );
  }

  _showImcList() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _imcController.imcList.length,
            itemBuilder: (_, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(
                                context, _imcController.imcList[index]);
                          },
                          child: ImcTile(
                            imc: _imcController.imcList[index],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Imc imc) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.32,
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
              label: "Atualizar Medida",
              color: AppColors.primaryClr,
              context: context,
              onTap: () {
                setState(() {
                  _imcController.heightController.text = imc.height.toString();
                  _imcController.weightController.text = imc.weight.toString();
                  _imcController.calendarInputFieldController.text =
                      imc.measuredAt ?? "";
                });
                _showEditDialog(context, imc);
              },
            ),
            CustomBottomSheetButton(
              label: "Remover Medida",
              color: Colors.red[300]!,
              context: context,
              onTap: () {
                _imcController.delete(imc);
              },
            ),
            const SizedBox(height: 20),
            CustomBottomSheetButton(
              label: "Fechar",
              color: Colors.white,
              context: context,
              isCloseButton: true,
              onTap: () {
                Get.back();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _showEditDialog(BuildContext context, Imc imc) {
    NumberUtils.formatToNumberTextEditingText(_imcController.heightController);
    NumberUtils.formatToNumberTextEditingText(_imcController.weightController);

    return Get.dialog(
      AlertDialog(
        title: Text(
          "Alterar Medidas",
          style: headingStyle,
        ),
        content: Wrap(
          children: [
            Text(
              imc.user ?? "",
              style: subHeadingStyle,
            ),
            InputFormField(
              title: "Peso",
              widget: NumberInput(
                hint: "Digite seu peso em Kg.",
                controller: _imcController.weightController,
              ),
            ),
            InputFormField(
              title: "Data",
              widget: StringInput(
                hint: DateFormat.yMd(Constants.appLocale)
                    .format(_imcController.selectedEditingDate),
                readOnly: true,
                controller: _imcController.calendarInputFieldController,
              ),
              sufixWidget: IconButton(
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _getSelectedDate();
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                var isValidated = _imcController.validateEditForm(imc);
                if (isValidated) Get.back();
              });
            },
            style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge),
            child: const Text("Atualizar"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge),
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  _getSelectedDate() async {
    DateTime? pickerDate = await showDatePicker(
      locale: const Locale('pt', 'BR'),
      context: context,
      initialDate: _imcController.selectedEditingDate,
      firstDate: startDate,
      lastDate: DateTime.now(),
    );

    if (pickerDate != null) {
      setState(() {
        _imcController.selectedEditingDate = pickerDate;
        _imcController.calendarInputFieldController.text =
            DateFormat.yMd(Constants.appLocale)
                .format(_imcController.selectedEditingDate);
      });
    }
  }
}
