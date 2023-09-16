import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/controllers/user_controller.dart';
import 'package:imc_flutter/models/user.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:imc_flutter/shared/utils/number_utils.dart';
import 'package:imc_flutter/shared/widgets/custom_app_header.dart';
import 'package:imc_flutter/shared/widgets/edit_bottom_sheet.dart';
import 'package:imc_flutter/shared/widgets/input_form_field.dart';
import 'package:imc_flutter/shared/widgets/number_input.dart';
import 'package:imc_flutter/shared/widgets/string_input.dart';
import 'package:imc_flutter/shared/widgets/user_tile.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UserController _userController = Get.put(UserController());

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _userController.init();
  }

  @override
  void dispose() {
    super.dispose();
    _userController.heightController.dispose();
    _userController.nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomAppHeader(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Usuários",
            style: headingStyle,
          ),
        ),
        const SizedBox(height: 10),
        _showUsersList(),
      ],
    );
  }

  _showUsersList() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _userController.userList.length,
            itemBuilder: (_, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              EditBottomSheet(
                                buildContext: context,
                                editTitle: "Editar Medida",
                                deleteTitle: "Remover Medida",
                                onEditAction: () {
                                  setState(() {
                                    _userController.heightController.text =
                                        _userController.userList[index].height
                                            .toString();
                                    _userController.nameController.text =
                                        _userController.userList[index].name;
                                  });

                                  _showEditDialog(
                                      _userController.userList[index]);
                                },
                                onDeleteAction: () {
                                  _userController
                                      .delete(_userController.userList[index]);
                                },
                              ),
                            );
                          },
                          child: UserTile(
                            user: _userController.userList[index],
                          ), //Tile Goes Here!!
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

  _showEditDialog(User user) {
    NumberUtils.formatToNumberTextEditingText(_userController.heightController);

    return Get.dialog(
      AlertDialog(
        title: Text(
          "Alterar Dados",
          style: headingStyle,
        ),
        content: Wrap(
          children: [
            InputFormField(
              title: "Nome",
              widget: StringInput(
                hint: "Escreva seu nome.",
                controller: _userController.nameController,
              ),
            ),
            InputFormField(
              title: "Altura",
              widget: NumberInput(
                hint: "Digite sua altura em Metros.",
                controller: _userController.heightController,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                var isValidated = _userController.validateEditForm(user);
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
}
