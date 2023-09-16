import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/controllers/profile_controller.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
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
  final ProfileController _profileController = Get.put(ProfileController());

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _profileController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: _profileController.saving
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
                    controller: _profileController.nameController,
                  ),
                ),
                InputFormField(
                  title: "Altura",
                  widget: NumberInput(
                    hint: "Digite sua altura em Metros.",
                    controller: _profileController.heightController,
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
                        _profileController.saving = true;
                      });

                      bool isValidated = _profileController.validateEditForm();
                      if (isValidated) {
                        _profileController.updateLoggedUser();
                      }

                      _profileController.saving = false;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
