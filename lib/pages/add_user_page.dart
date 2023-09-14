import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/controllers/user_controller.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/models/user.dart';
import 'package:imc_flutter/models/user_validator.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:imc_flutter/shared/widgets/alert_validation.dart';
import 'package:imc_flutter/shared/widgets/custom_button.dart';
import 'package:imc_flutter/shared/widgets/feedback_dialog.dart';
import 'package:imc_flutter/shared/widgets/input_form_field.dart';
import 'package:imc_flutter/shared/widgets/number_input.dart';
import 'package:imc_flutter/shared/widgets/string_input.dart';
import 'package:intl/intl.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final UserController _userController = Get.put(UserController());
  final _nameController = TextEditingController(text: "");
  final _heightController = TextEditingController(text: "");
  final box = GetStorage();

  bool saving = false;

  @override
  void initState() {
    super.initState();
  }

  Future<UserResponse> getUsers() async {
    UserResponse userResponse = await _userController.getUsers();
    return userResponse;
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
                    "Novo Usuário",
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
    User user = User(
      _nameController.text,
      NumberFormat().parse(_heightController.text).toDouble(),
    );

    UserResponse response = await _userController.add(user: user);

    await Get.dialog(FeedBackDialog(response: response));

    setState(() {
      saving = false;
    });
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
