import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/database/db_helper.dart';
import 'package:imc_flutter/models/imc.dart';
import 'package:imc_flutter/models/response.dart';

class ImcController extends GetxController {
  var imcList = <Imc>[].obs;

  Future<ImcResponse> add({Imc? imc}) async {
    return await DBHelper.insert(imc!);
  }

  Future<ImcResponse> getImcs(String date) async {
    ImcResponse response = await DBHelper.query(date);
    List<Map<String, dynamic>> imcs = response.error ? [] : response.data;
    imcList.assignAll(imcs.map((data) => Imc.fromJson(data)).toList());

    return response;
  }

  void delete(Imc imc) {
    var response = DBHelper.delete(imc);
    debugPrint(response.toString());
  }

  Future<int> updateImc(Imc imc) async {
    var response = await DBHelper.update(imc);
    debugPrint(response.toString());
    return response;
  }
}
