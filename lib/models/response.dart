import 'package:imc_flutter/models/user.dart';

abstract class GeneralResponse {
  bool error;
  String title;
  String message;
  dynamic data;

  GeneralResponse({
    this.error = false,
    this.title = "",
    this.message = "",
    this.data,
  });
}

class ImcResponse extends GeneralResponse {
  ImcResponse({
    bool error = false,
    String title = "",
    String message = "",
    dynamic data,
  }) : super(error: error, title: title, message: message, data: data);
}

class UserResponse extends GeneralResponse {
  UserResponse({
    bool error = false,
    String title = "",
    String message = "",
    List<User>? data,
  }) : super(error: error, title: title, message: message, data: data);
}
