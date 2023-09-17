import 'package:imc_flutter/database/db_helper.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/models/user.dart';

class LoginServices {
  static Future<User> getLoggedUser() async {
    UserResponse response = await DBHelper.usersQuery();
    List<User> users = response.data;
    if (users.isEmpty) {
      UserResponse response = await DBHelper.userInsert(User(
        "Fernando Reis",
        1.83,
      ));

      return response.data.first;
    }

    return users.first;
  }
}
