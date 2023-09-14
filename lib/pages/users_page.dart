import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/controllers/user_controller.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/models/user.dart';
import 'package:imc_flutter/models/user_validator.dart';
import 'package:imc_flutter/pages/add_user_page.dart';
import 'package:imc_flutter/pages/profile_page.dart';
import 'package:imc_flutter/services/theme_services.dart';
import 'package:imc_flutter/shared/colors.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:imc_flutter/shared/utils/number_utils.dart';
import 'package:imc_flutter/shared/widgets/alert_validation.dart';
import 'package:imc_flutter/shared/widgets/custom_bottom_sheet_button.dart';
import 'package:imc_flutter/shared/widgets/feedback_dialog.dart';
import 'package:imc_flutter/shared/widgets/input_form_field.dart';
import 'package:imc_flutter/shared/widgets/number_input.dart';
import 'package:imc_flutter/shared/widgets/string_input.dart';
import 'package:imc_flutter/shared/widgets/user_tile.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UserController _userController = Get.put(UserController());
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _heightController =
      TextEditingController(text: "");

  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _refreshUsersList();
  }

  Future<void> _refreshUsersList() async {
    debugPrint("------------------ ATUALIZOU!!! ---------------------");
    UserResponse response = await _userController.getUsers();
    if (response.error) {
      await Get.dialog(FeedBackDialog(response: response));
    }
  }

  _updateUser(User user) async {
    user.name = _nameController.text;
    user.height = NumberFormat().parse(_heightController.text).toDouble();
    user.updatedAt = DateTime.now().toString();

    UserResponse response = await _userController.updateUser(user);
    _refreshUsersList();
    await Get.dialog(FeedBackDialog(response: response));
    if (!response.error) Get.back();
  }

  _deleteUser(User user) async {
    UserResponse response = await _userController.delete(user);
    _refreshUsersList();
    await Get.dialog(FeedBackDialog(response: response));
    if (!response.error) Get.back();
  }

  bool _validateEditForm(User user) {
    var height = _heightController.text;
    var name = _nameController.text;
    UserResponse validation =
        UserValidator().validate(height: height, name: name, isEditing: true);

    if (validation.error) {
      AlertValidation.showCustomSnackbar(
        title: validation.title,
        message: validation.message,
      );

      return false;
    }

    _updateUser(user);
    Get.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar(box.read('initials')),
      body: Column(
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
      ),
      floatingActionButton: _showAddUserButton(),
    );
  }

  _showAppBar(String initial) {
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
        InkWell(
          onTap: () async {
            await Get.to(
              () => const ProfilePage(),
              preventDuplicates: true,
            );
          },
          child: CircleAvatar(
            child: Text(initial),
          ),
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
                  _heightController.text = user.height.toString();
                  _nameController.text = user.name;
                });
                _showEditDialog(user);
              },
            ),
            CustomBottomSheetButton(
              label: "Remover Usuário",
              color: Colors.red[300]!,
              context: context,
              onTap: () {
                _deleteUser(user);
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
    NumberUtils.formatToNumberTextEditingText(_heightController);

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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                var isValidated = _validateEditForm(user);
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

  _showAddUserButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Get.to(
          () => const AddUserPage(),
          preventDuplicates: true,
        );
        _refreshUsersList();
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }
}
