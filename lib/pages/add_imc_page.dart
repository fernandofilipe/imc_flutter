import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:imc_flutter/controllers/imc_controller.dart';
import 'package:imc_flutter/models/imc.dart';
import 'package:imc_flutter/models/imc_validator.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:imc_flutter/shared/widgets/alert_validation.dart';
import 'package:imc_flutter/shared/widgets/custom_button.dart';
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
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _weightController =
      TextEditingController(text: "");
  final TextEditingController _heightController =
      TextEditingController(text: "");

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(context),
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
              InputFormField(
                title: "Nome",
                widget: StringInput(
                  hint: "Escreva seu nome.",
                  controller: _nameController,
                ),
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
                  hint:
                      DateFormat.yMd(Constants.appLocale).format(_selectedDate),
                  readOnly: true,
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
      user: _nameController.text,
      measuredAt: DateFormat.yMd(Constants.appLocale).format(_selectedDate),
    );

    ImcResponse response = await _imcController.add(imc: imc);

    await Get.dialog(FeedBackDialog(response: response));
    if (!response.error) Get.back();
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back, //wb_sunny_outlined
          size: 20,
        ),
      ),
      actions: const [
        CircleAvatar(
          child: Text("FR"),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _getSelectedDate() async {
    debugPrint(Intl.defaultLocale);
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
      });
    } else {
      debugPrint("Erro... Data inválida.");
    }
  }
}
