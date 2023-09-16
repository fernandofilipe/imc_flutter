import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:imc_flutter/database/db_helper.dart';
import 'package:imc_flutter/imc_flutter.dart';
import 'package:imc_flutter/models/user.dart';
import 'package:imc_flutter/services/login_services.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/utils/number_utils.dart';
import 'package:imc_flutter/shared/utils/string_utils.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.init();
  await GetStorage.init();

  final box = GetStorage();

  //Simula Login
  User user = await LoginServices.getLoggedUser();
  box.write('userlogged', user);
  box.write('initials', StringUtils.getInitials(user.name));
  box.write('height', NumberUtils.numberToString(user.height));
  Intl.defaultLocale = Constants.appLocale;
  initializeDateFormatting(Constants.appLocale);
  runApp(const IMCFlutter());
}
