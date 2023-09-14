import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/database/db_helper.dart';
import 'package:imc_flutter/imc_flutter.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.init();
  await GetStorage.init();

  final box = GetStorage();

  //Simulando que esses dados vieram de login
  box.write('username', 'Fernando Reis');
  box.write('initials', 'FR');
  box.write('height', '1,83');

  Intl.defaultLocale = Constants.appLocale;
  initializeDateFormatting(Constants.appLocale);
  runApp(const IMCFlutter());
}
