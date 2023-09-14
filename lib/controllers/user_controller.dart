import 'package:get/get.dart';
import 'package:imc_flutter/database/db_helper.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/models/user.dart';

class UserController extends GetxController {
  var userList = <User>[].obs;

  Future<UserResponse> add({User? user}) async {
    return await DBHelper.userInsert(user!);
  }

  Future<UserResponse> getUsers() async {
    UserResponse response = await DBHelper.usersQuery();
    List<User> users = response.error ? [] : response.data;
    userList.assignAll(users);

    return response;
  }

  Future<UserResponse> delete(User user) async {
    return await DBHelper.userDelete(user);
  }

  Future<UserResponse> updateUser(User user) async {
    return await DBHelper.userUpdate(user);
  }
}
