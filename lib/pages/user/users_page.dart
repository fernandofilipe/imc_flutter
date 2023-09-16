import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/controllers/user_controller.dart';
import 'package:imc_flutter/models/user.dart';
import 'package:imc_flutter/shared/colors.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:imc_flutter/shared/utils/number_utils.dart';
import 'package:imc_flutter/shared/widgets/custom_bottom_sheet_button.dart';
import 'package:imc_flutter/shared/widgets/input_form_field.dart';
import 'package:imc_flutter/shared/widgets/number_input.dart';
import 'package:imc_flutter/shared/widgets/string_input.dart';
import 'package:imc_flutter/shared/widgets/user_tile.dart';
import 'package:intl/intl.dart';

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
        _showAppHeader(),
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
                            _showBottomSheet(_userController.userList[index]);
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

  _showBottomSheet(User user) {
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
              label: "Atualizar Dados",
              color: AppColors.primaryClr,
              context: context,
              onTap: () {
                setState(() {
                  _userController.heightController.text =
                      user.height.toString();
                  _userController.nameController.text = user.name;
                });
                _showEditDialog(user);
              },
            ),
            CustomBottomSheetButton(
              label: "Remover Usuário",
              color: Colors.red[300]!,
              context: context,
              onTap: () {
                _userController.delete(user);
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
