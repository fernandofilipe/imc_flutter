import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/database/db_helper.dart';
import 'package:imc_flutter/models/imc.dart';
import 'package:imc_flutter/models/imc_validator.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/utils/datetime_utils.dart';
import 'package:imc_flutter/shared/widgets/alert_validation.dart';
import 'package:imc_flutter/shared/widgets/feedback_dialog.dart';
import 'package:intl/intl.dart';

class ImcController extends GetxController {
  var imcList = <Imc>[].obs;
  late DatePickerController datePickerController;
  late TextEditingController calendarInputFieldController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late DateTime selectedEditingDate;

  void init(DateTime date) {
    datePickerController = DatePickerController();
    calendarInputFieldController = TextEditingController(text: "");
    weightController = TextEditingController(text: "");
    heightController = TextEditingController(text: "");
    selectedEditingDate = DateTime.now();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => datePickerController.animateToDate(date));

    getImcs(date);
  }

  Future<ImcResponse> add({Imc? imc}) async {
    if (imc == null) {
      return ImcResponse(error: true, message: "Usuário não pode ser vazio.");
    }

    ImcResponse response = await DBHelper.insert(imc);
    Imc newImc = response.data.first;
    imcList.assignAll([newImc, ...imcList]);

    return response;
  }

  Future<ImcResponse> getImcs(DateTime date) async {
    String dateString = DateTimeUtils.dateToString(date);
    ImcResponse response = await DBHelper.query(dateString);

    List<Map<String, dynamic>> imcs = response.error ? [] : response.data;
    imcList.assignAll(imcs.map((data) => Imc.fromJson(data)).toList());

    if (response.error) {
      await Get.dialog(FeedBackDialog(response: response));
    }

    return response;
  }

  Future<ImcResponse> delete(Imc imc) async {
    ImcResponse imcResponse = await DBHelper.delete(imc);

    Imc oldImc = imcResponse.data.first;
    imcList.removeWhere((Imc localImc) => localImc.id == oldImc.id);

    await Get.dialog(FeedBackDialog(response: imcResponse));
    if (!imcResponse.error) Get.back();
    return imcResponse;
  }

  Future<ImcResponse> updateImc(Imc imc) async {
    imc.height = NumberFormat().parse(heightController.text).toDouble();
    imc.weight = NumberFormat().parse(weightController.text).toDouble();
    imc.measuredAt =
        DateFormat.yMd(Constants.appLocale).format(selectedEditingDate);
    imc.updatedAt = DateFormat.yMd(Constants.appLocale).format(DateTime.now());

    ImcResponse imcResponse = await DBHelper.update(imc);

    int indexOfImc =
        imcList.indexWhere((Imc localImc) => localImc.id == imc.id);

    imcList[indexOfImc].height = imc.height;
    imcList[indexOfImc].weight = imc.weight;
    imcList[indexOfImc].measuredAt = imc.measuredAt;
    imcList[indexOfImc].updatedAt = imc.updatedAt;

    imcList.refresh();

    await Get.dialog(FeedBackDialog(response: imcResponse));
    if (!imcResponse.error) Get.back();

    return imcResponse;
  }

  bool validateEditForm(Imc imc) {
    var height = heightController.text;
    var weight = weightController.text;
    ImcResponse validation = ImcValidator()
        .validate(height: height, weight: weight, isEditing: true);

    if (validation.error) {
      AlertValidation.showCustomSnackbar(
        title: validation.title,
        message: validation.message,
      );

      return false;
    }

    updateImc(imc);
    Get.back();
    return true;
  }
}
