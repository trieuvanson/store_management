import 'package:intl/intl.dart';

class DateUtils {
  String getFormattedDateByCustom(DateTime date, String format) {
    return DateFormat(format).format(date);
  }



}

final dateUtils = DateUtils();