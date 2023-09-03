import 'package:imc_flutter/models/response.dart';
import 'package:intl/intl.dart';

class ImcValidator {
  ImcResponse validate({
    required String height,
    required String weight,
    String name = "",
    bool isEditing = false,
  }) {
    return isEditing
        ? _validateEdit(height, weight)
        : _validateAdd(height, weight, name);
  }

  ImcResponse _validateAdd(String height, String weight, String name) {
    if (!name.isNotEmpty) {
      return ImcResponse(
          error: true,
          title: "Obrigatório",
          message: "O campo NOME deve ser preenchido.");
    }

    if (!(name.trim().length >= 3)) {
      return ImcResponse(
          error: true,
          title: "Obrigatório",
          message: "O campo NOME deve conter mais de 3 caracteres.");
    }

    return _validateEdit(height, weight);
  }

  ImcResponse _validateEdit(String height, String weight) {
    if (!height.isNotEmpty) {
      return ImcResponse(
          error: true,
          title: "Obrigatório",
          message: "O campo ALTURA deve ser preenchido.");
    }

    double dobleHeight = NumberFormat().parse(height).toDouble();
    if (!(dobleHeight >= 1 && dobleHeight <= 3)) {
      return ImcResponse(
        error: true,
        title: "Obrigatório",
        message: "O campo ALTURA digitada deve estar entre 1 e 3 metros.",
      );
    }

    if (!weight.isNotEmpty) {
      return ImcResponse(
          error: true,
          title: "Obrigatório",
          message: "O campo PESO deve ser preenchido.");
    }

    double dobleWeight = NumberFormat().parse(weight).toDouble();
    if (!(dobleWeight >= 25 && dobleWeight <= 300)) {
      return ImcResponse(
          error: true,
          title: "Obrigatório",
          message:
              "O campo ALTURA digitada deve estar entre 25 e 300 quilogramas.");
    }

    return ImcResponse(
        error: false,
        title: "Sucesso!",
        message: "Campos validados com sucesso.");
  }
}
