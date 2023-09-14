import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/models/user_validator.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:imc_flutter/shared/utils/string_utils.dart';
import 'package:imc_flutter/shared/widgets/alert_validation.dart';
import 'package:imc_flutter/shared/widgets/custom_button.dart';
import 'package:imc_flutter/shared/widgets/input_form_field.dart';
import 'package:imc_flutter/shared/widgets/number_input.dart';
import 'package:imc_flutter/shared/widgets/string_input.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final box = GetStorage();
  final _nameController = TextEditingController(text: "");
  final _heightController = TextEditingController(text: "");

  bool saving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = box.read('username');
    _heightController.text = box.read('height');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: saving
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Text(
                    "Perfil",
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
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CustomButton(
                      label: "Salvar",
                      width: double.infinity,
                      onTap: () {
                        setState(() {
                          setState(() {
                            saving = false;
                          });
                          _validateForm();
                        });
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _validateForm() {
    var name = _nameController.text;
    var height = _heightController.text;
    UserResponse validation =
        UserValidator().validate(height: height, name: name);

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
    setState(() {
      saving = true;
    });

    final box = GetStorage();
    await box.write('username', _nameController.text);
    await box.write('initials', StringUtils.getInitials(_nameController.text));
    await box.write('height', _heightController.text);

    setState(() {
      saving = false;
    });

    Get.back();
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
      actions: [
        CircleAvatar(
          child: Text(box.read('initials')),
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }
}
