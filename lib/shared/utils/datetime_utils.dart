import 'package:imc_flutter/shared/constants.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String dateToString(DateTime date) {
    return DateFormat.yMd(Constants.appLocale).format(date);
  }
}
