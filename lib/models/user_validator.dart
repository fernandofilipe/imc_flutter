import 'package:imc_flutter/models/response.dart';
import 'package:intl/intl.dart';

class UserValidator {
  UserResponse validate({
    required String height,
    String name = "",
    bool isEditing = false,
  }) {
    return isEditing ? _validateEdit(height) : _validateAdd(height, name);
  }

  UserResponse _validateAdd(String height, String name) {
    if (!name.isNotEmpty) {
      return UserResponse(
          error: true,
          title: "Obrigatório",
          message: "O campo NOME deve ser preenchido.");
    }

    if (!(name.trim().length >= 3)) {
      return UserResponse(
          error: true,
          title: "Obrigatório",
          message: "O campo NOME deve conter mais de 3 caracteres.");
    }

    return _validateEdit(height);
  }

  UserResponse _validateEdit(String height) {
    if (!height.isNotEmpty) {
      return UserResponse(
          error: true,
          title: "Obrigatório",
          message: "O campo ALTURA deve ser preenchido.");
    }

    double dobleHeight = NumberFormat().parse(height).toDouble();
    if (!(dobleHeight >= 1 && dobleHeight <= 3)) {
      return UserResponse(
        error: true,
        title: "Obrigatório",
        message: "O campo ALTURA digitada deve estar entre 1 e 3 metros.",
      );
    }

    return UserResponse(
        error: false,
        title: "Sucesso!",
        message: "Campos validados com sucesso.");
  }
}
