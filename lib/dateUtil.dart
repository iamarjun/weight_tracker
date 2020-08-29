import 'package:intl/intl.dart';

class DateUtil {
  static String getDay(String date) {
    final DateTime now = DateTime.parse(date);
    final DateFormat formatter = DateFormat('d');
    final String formatted = formatter.format(now);
    return formatted;
  }
}
