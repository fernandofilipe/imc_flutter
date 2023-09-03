import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/controllers/imc_controller.dart';
import 'package:imc_flutter/models/imc.dart';
import 'package:imc_flutter/models/imc_validator.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/pages/add_imc_page.dart';
import 'package:imc_flutter/services/theme_services.dart';
import 'package:imc_flutter/shared/colors.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:imc_flutter/shared/widgets/alert_validation.dart';
import 'package:imc_flutter/shared/widgets/custom_bottom_sheet_button.dart';
import 'package:imc_flutter/shared/widgets/custom_datepicker.dart';
import 'package:imc_flutter/shared/widgets/feedback_dialog.dart';
import 'package:imc_flutter/shared/widgets/imc_tile.dart';
import 'package:imc_flutter/shared/widgets/input_form_field.dart';
import 'package:imc_flutter/shared/widgets/number_input.dart';
import 'package:imc_flutter/shared/widgets/string_input.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:imc_flutter/shared/utils/number_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final startDate = DateTime(2023, 01, 01);
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedEditingDate = DateTime.now();
  final _datePickerController = DatePickerController();

  final TextEditingController _calendarInputFieldController =
      TextEditingController(text: "");

  final TextEditingController _weightController =
      TextEditingController(text: "");
  final TextEditingController _heightController =
      TextEditingController(text: "");
  final ImcController _imcController = Get.put(ImcController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _datePickerController.animateToDate(_selectedDate));
    _refreshImcList();
  }

  @override
  void dispose() {
    _imcController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _calendarInputFieldController.dispose();
    super.dispose();
  }

  Future<void> _refreshImcList() async {
    debugPrint("------------------ ATUALIZOU!!! ---------------------");
    ImcResponse response = await _imcController
        .getImcs(DateFormat.yMd(Constants.appLocale).format(_selectedDate));

    if (response.error) {
      await Get.dialog(FeedBackDialog(response: response));
    }

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _datePickerController.animateToDate(_selectedDate));
  }

  _updateImc(Imc imc) async {
    imc.height = NumberFormat().parse(_heightController.text).toDouble();
    imc.weight = NumberFormat().parse(_weightController.text).toDouble();
    imc.measuredAt =
        DateFormat.yMd(Constants.appLocale).format(_selectedEditingDate);
    imc.updatedAt = DateFormat.yMd(Constants.appLocale).format(DateTime.now());

    ImcResponse response = await _imcController.updateImc(imc);
    _refreshImcList();
    await Get.dialog(FeedBackDialog(response: response));
    if (!response.error) Get.back();
  }

  _deleteImc(Imc imc) async {
    ImcResponse response = await _imcController.delete(imc);
    _refreshImcList();
    await Get.dialog(FeedBackDialog(response: response));
    if (!response.error) Get.back();
  }

  bool _validateEditForm(Imc imc) {
    var height = _heightController.text;
    var weight = _weightController.text;
    ImcResponse validation = ImcValidator()
        .validate(height: height, weight: weight, isEditing: true);

    if (validation.error) {
      AlertValidation.showCustomSnackbar(
        title: validation.title,
        message: validation.message,
      );

      return false;
    }

    _updateImc(imc);
    Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _showAppBar(context, "FR"),
        body: Column(
          children: [
            _showAppHeader(),
            _showCalendarFilter(),
            const SizedBox(height: 10),
            _showImcList(),
          ],
        ),
        floatingActionButton: _showAddImcButton(),
      ),
    );
  }

  _showAppBar(BuildContext context, String initial) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Transform.rotate(
          angle: 315 * math.pi / 180,
          child: Get.isDarkMode
              ? const Icon(Icons.wb_sunny_outlined, size: 20)
              : const Icon(
                  Icons.nightlight_outlined, //wb_sunny_outlined
                  size: 20,
                  color: AppColors.darkGreyClr,
                ),
        ),
      ),
      actions: [
        CircleAvatar(
          child: Text(initial),
        ),
        const SizedBox(width: 20)
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
        controller: _datePickerController,
        onDateChanged: (date) {
          _selectedDate = date;
          _refreshImcList();
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

  _showAddImcButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Get.to(
          () => const AddImcPage(),
          preventDuplicates: true,
        );
        _refreshImcList();
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
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
                  _heightController.text = imc.height.toString();
                  _weightController.text = imc.weight.toString();
                  _calendarInputFieldController.text = imc.measuredAt;
                });
                _showEditDialog(context, imc);
              },
            ),
            CustomBottomSheetButton(
              label: "Remover Medida",
              color: Colors.red[300]!,
              context: context,
              onTap: () {
                _deleteImc(imc);
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
    NumberUtils.formatToNumberTextEditingText(_heightController);
    NumberUtils.formatToNumberTextEditingText(_weightController);

    return Get.dialog(
      AlertDialog(
        title: Text(
          "Alterar Medidas",
          style: headingStyle,
        ),
        content: Wrap(
          children: [
            Text(
              imc.user,
              style: subHeadingStyle,
            ),
            InputFormField(
              title: "Altura",
              widget: NumberInput(
                hint: "Digite sua altura em Metros.",
                controller: _heightController,
              ),
            ),
            InputFormField(
              title: "Peso",
              widget: NumberInput(
                hint: "Digite seu peso em Kg.",
                controller: _weightController,
              ),
            ),
            InputFormField(
              title: "Data",
              widget: StringInput(
                hint: DateFormat.yMd(Constants.appLocale)
                    .format(_selectedEditingDate),
                readOnly: true,
                controller: _calendarInputFieldController,
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
                var isValidated = _validateEditForm(imc);
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
      initialDate: _selectedEditingDate,
      firstDate: startDate,
      lastDate: DateTime.now(),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedEditingDate = pickerDate;
        _calendarInputFieldController.text =
            DateFormat.yMd(Constants.appLocale).format(_selectedEditingDate);
      });
    } else {
      debugPrint("Erro... Data inválida.");
    }
  }
}
