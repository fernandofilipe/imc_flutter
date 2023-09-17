import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/controllers/imc_controller.dart';
import 'package:imc_flutter/controllers/user_controller.dart';
import 'package:imc_flutter/models/imc.dart';
import 'package:imc_flutter/models/imc_validator.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/models/user.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:imc_flutter/shared/utils/number_utils.dart';
import 'package:imc_flutter/shared/utils/string_utils.dart';
import 'package:imc_flutter/shared/widgets/alert_validation.dart';
import 'package:imc_flutter/shared/widgets/custom_app_bar.dart';
import 'package:imc_flutter/shared/widgets/custom_button.dart';
import 'package:imc_flutter/shared/widgets/custom_text_dropdown.dart';
import 'package:imc_flutter/shared/widgets/feedback_dialog.dart';
import 'package:imc_flutter/shared/widgets/input_form_field.dart';
import 'package:imc_flutter/shared/widgets/number_input.dart';
import 'package:imc_flutter/shared/widgets/string_input.dart';
import 'package:intl/intl.dart';

class AddImcPage extends StatefulWidget {
  const AddImcPage({super.key});

  @override
  State<AddImcPage> createState() => _AddImcPageState();
}

class _AddImcPageState extends State<AddImcPage> {
  final ImcController _imcController = Get.put(ImcController());
  final UserController _userController = Get.put(UserController());
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _weightController =
      TextEditingController(text: "");
  final TextEditingController _heightController =
      TextEditingController(text: "");

  final TextEditingController _calendarInputFieldController =
      TextEditingController(text: "");
  final box = GetStorage();

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _calendarInputFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: const CustomAppBar(isEditingAppBar: true),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Adicionar Medidas",
                style: headingStyle,
              ),
              CustomTextDropdown<User>(
                placeholder: "Escolha um usuário...",
                controller: _nameController,
                itemBuilder: (BuildContext p0, User p1) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: Text(
                            StringUtils.getInitials(p1.name),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p1.name,
                              style: titleStyle,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.design_services_outlined,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                Text(
                                  p1.height.toString(),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                onSelected: (p0) {
                  _nameController.text = p0.name;
                  _heightController.text = p0.height.toString();
                  setState(() {});
                },
                suggestionsCallback: (p0) async {
                  final users = await _userController.getUsers();
                  return users.data.where((User user) => user.name
                      .toLowerCase()
                      .trim()
                      .startsWith(p0.toLowerCase().trim()));
                },
                clearFunction: () {
                  _nameController.clear();
                  _heightController.clear();
                  setState(() {});
                },
                enabled: true,
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
                  hint:
                      DateFormat.yMd(Constants.appLocale).format(_selectedDate),
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
              const SizedBox(
                height: 20,
              ),
              Center(
                child: CustomButton(
                  label: "Enviar",
                  width: double.infinity,
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      _validateAddForm();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateAddForm() {
    NumberUtils.formatToNumberTextEditingText(_heightController);
    var height = _heightController.text;
    var weight = _weightController.text;
    var name = _nameController.text;
    ImcResponse validation =
        ImcValidator().validate(height: height, weight: weight, name: name);

    if (validation.error) {
      AlertValidation.showCustomSnackbar(
        title: validation.title,
        message: validation.message,
      );

      return false;
    }

    _save();
  }

  _save() async {
    Imc imc = Imc(
      NumberFormat().parse(_heightController.text).toDouble(),
      NumberFormat().parse(_weightController.text).toDouble(),
      _nameController.text,
      DateFormat.yMd(Constants.appLocale).format(_selectedDate),
    );

    ImcResponse response = await _imcController.add(imc: imc);

    await Get.dialog(FeedBackDialog(response: response));
    if (!response.error) Get.back();
  }

  _getSelectedDate() async {
    DateTime? pickerDate = await showDatePicker(
      locale: const Locale('pt', 'BR'),
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
        _calendarInputFieldController.text =
            DateFormat.yMd(Constants.appLocale).format(_selectedDate);
      });
    } else {
      debugPrint("Erro... Data inválida.");
    }
  }
}
