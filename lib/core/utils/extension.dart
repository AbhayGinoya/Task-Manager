import 'package:intl/intl.dart';
import 'package:task_manager/core/utils/enum.dart';

extension Capitailize on String {
  String get capitalizeFist =>'${this[0].toUpperCase()}${substring(1)}';
}

extension DateStringExtensation on String {
  DateTime convertStringToDate(String currentDateFormat) => DateFormat(currentDateFormat).parse(this);

  String formatDate(DateFormats fromFormat, DateFormats toFormat) {
    DateTime date = convertStringToDate(fromFormat.format);

    return DateFormat(toFormat.format).format(date);
  }

  String formatIosDate(DateFormats toFormat) {
    DateTime date = DateTime.parse(this);

    return DateFormat(toFormat.format).format(date);
  }
}

extension DateTimeExtensation on DateTime {
  String formatDate(DateFormats toFormat) => DateFormat(toFormat.format).format(this);
}
