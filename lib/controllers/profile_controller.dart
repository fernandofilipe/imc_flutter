import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/database/db_helper.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/models/user.dart';
import 'package:imc_flutter/models/user_validator.dart';
import 'package:imc_flutter/shared/utils/number_utils.dart';
import 'package:imc_flutter/shared/utils/string_utils.dart';
import 'package:imc_flutter/shared/widgets/alert_validation.dart';
import 'package:imc_flutter/shared/widgets/feedback_dialog.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  var userList = <User>[].obs;
  late TextEditingController nameController;
  late TextEditingController heightController;
  late bool saving;
  late GetStorage box;
  late User loggedUser;

  void init() {
    box = GetStorage();
    loggedUser = box.read('userlogged');
    nameController = TextEditingController(text: loggedUser.name);
    heightController = TextEditingController(
        text: NumberUtils.numberToString(loggedUser.height));
    saving = false;
  }

  Future<UserResponse> getUser() async {
    UserResponse response = await DBHelper.usersQuery();
    List<User> users = response.error ? [] : response.data;
    userList.assignAll(users);

    if (response.error) {
      await Get.dialog(FeedBackDialog(response: response));
    }

    return response;
  }

  Future<bool> updateLoggedUser() async {
    await box.write('initials', StringUtils.getInitials(nameController.text));

    loggedUser.name = nameController.text;
    loggedUser.height = NumberFormat().parse(heightController.text).toDouble();

    await box.write('userlogged', loggedUser);

    final response = await DBHelper.userUpdate(loggedUser);
    await Get.dialog(FeedBackDialog(response: response));

    return response.error;
  }

  bool validateEditForm() {
    var height = heightController.text;
    var name = nameController.text;
    UserResponse validation =
        UserValidator().validate(height: height, name: name, isEditing: true);

    if (validation.error) {
      AlertValidation.showCustomSnackbar(
        title: validation.title,
        message: validation.message,
      );
      return false;
    }
    return true;
  }
}
