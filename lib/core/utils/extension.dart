import 'package:intl/intl.dart';
import 'package:task_manager/core/utils/enum.dart';

extension Capitailize on String {
  String get capitalizeFist =>'${this[0].toUpperCase()}${substring(1)}';
}

extension DateStringExtensation on String {
  DateTime convertStringToDate(DateFormats currentDateFormat) => DateFormat(currentDateFormat.format).parse(this);

  String formatDate(DateFormats fromFormat, DateFormats toFormat) {
    DateTime date = convertStringToDate(fromFormat);

    return DateFormat(toFormat.format).format(date);
  }

  String formatIosDate(DateFormats toFormat) {
    DateTime date = DateTime.parse(this);

    return DateFormat(toFormat.format).format(date);
  }
}

extension IntExtension on int {
  DateTime get convertMillSecondToDate  {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(this);

    String date = dateTime.formatDate(DateFormats.YYYY_MM_DD_HH_MM_SS);

    return date.convertStringToDate(DateFormats.YYYY_MM_DD_HH_MM_SS);
  }


}

extension DateTimeExtensation on DateTime {
  String formatDate(DateFormats toFormat) => DateFormat(toFormat.format).format(this);
}
