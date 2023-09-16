import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/database/db_helper.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/models/user.dart';
import 'package:imc_flutter/models/user_validator.dart';
import 'package:imc_flutter/shared/widgets/alert_validation.dart';
import 'package:imc_flutter/shared/widgets/feedback_dialog.dart';
import 'package:intl/intl.dart';

class UserController extends GetxController {
  var userList = <User>[].obs;
  late TextEditingController nameController;
  late TextEditingController heightController;

  void init() {
    nameController = TextEditingController(text: "");
    heightController = TextEditingController(text: "");
    getUsers();
  }

  Future<UserResponse> add({User? user}) async {
    if (user == null) {
      return UserResponse(error: true, message: "Usuário não pode ser vazio.");
    }

    UserResponse response = await DBHelper.userInsert(user);
    User newUser = response.data.first;
    userList.assignAll([newUser, ...userList]);

    return response;
  }

  Future<UserResponse> getUsers() async {
    UserResponse response = await DBHelper.usersQuery();
    List<User> users = response.error ? [] : response.data;
    userList.assignAll(users);

    if (response.error) {
      await Get.dialog(FeedBackDialog(response: response));
    }

    return response;
  }

  Future<UserResponse> delete(User user) async {
    final response = await DBHelper.userDelete(user);
    User oldUser = response.data.first;
    userList.removeWhere((User localUser) => localUser.id == oldUser.id);

    await Get.dialog(FeedBackDialog(response: response));

    if (!response.error) Get.back();
    return response;
  }

  Future<UserResponse> updateUser(User user) async {
    user.name = nameController.text;
    user.height = NumberFormat().parse(heightController.text).toDouble();
    user.updatedAt = DateTime.now().toString();

    final response = await DBHelper.userUpdate(user);

    int indexOfUser =
        userList.indexWhere((User localUser) => localUser.id == user.id);

    userList[indexOfUser].name = user.name;
    userList[indexOfUser].height = user.height;
    userList[indexOfUser].updatedAt = user.updatedAt;

    userList.refresh();

    await Get.dialog(FeedBackDialog(response: response));
    if (!response.error) Get.back();

    return response;
  }

  bool validateEditForm(User user) {
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

    updateUser(user);
    Get.back();
    return true;
  }
}
