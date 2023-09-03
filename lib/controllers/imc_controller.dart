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

  Future<ImcResponse> delete(Imc imc) async {
    return await DBHelper.delete(imc);
  }

  Future<ImcResponse> updateImc(Imc imc) async {
    return await DBHelper.update(imc);
  }
}
