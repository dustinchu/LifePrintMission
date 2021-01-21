import 'package:intl/intl.dart';

final String toDayString =
    new DateFormat("MMM", "en_US").format(DateTime.now()).toUpperCase() +
        ". " +
        new DateFormat("d", "en_US").format(DateTime.now()).toUpperCase() +
        ", " +
        new DateFormat("y", "en_US").format(DateTime.now()).toUpperCase();

final String tomorrow = new DateFormat("MMM", "en_US")
        .format(DateTime.now().add(new Duration(days: 1)))
        .toUpperCase() +
    ". " +
    new DateFormat("d", "en_US")
        .format(DateTime.now().add(new Duration(days: 1)))
        .toUpperCase() +
    ", " +
    new DateFormat("y", "en_US")
        .format(DateTime.now().add(new Duration(days: 1)))
        .toUpperCase();

int toTomorrow() {
  DateFormat dataFormat = DateFormat("yyyy-MM-dd");
  String bb = dataFormat
      .format(DateTime.now().add(new Duration(days: 1)))
      .toUpperCase();
  DateTime dateTime = dataFormat.parse(bb);
  return dateTime.microsecondsSinceEpoch;
}

int toDayInt() {
  DateFormat dataFormat = DateFormat("yyyy-MM-dd");
  String bb = dataFormat.format(DateTime.now()).toUpperCase();
  DateTime dateTime = dataFormat.parse(bb);
  return dateTime.microsecondsSinceEpoch;
}

int yesterdayInt() {
  DateFormat dataFormat = DateFormat("yyyy-MM-dd");
  String bb = dataFormat
      .format(DateTime.now().subtract(new Duration(days: 1)))
      .toUpperCase();
  DateTime dateTime = dataFormat.parse(bb);
  return dateTime.microsecondsSinceEpoch;
}

int monthInt() {
  DateTime nowDate = DateTime.now();
  //得到每月的一號
  DateTime month = DateTime(nowDate.year, nowDate.month, 1);

  DateFormat dataFormat = DateFormat("yyyy-MM-dd");
  //減去一天轉成string
  String bb =
      dataFormat.format(month.subtract(new Duration(days: 1))).toUpperCase();
  //轉成dateTime
  DateTime dateTime = dataFormat.parse(bb);
  return dateTime.microsecondsSinceEpoch;
}

int getDateTimeInt(DateTime dt) {
  DateFormat dataFormat = DateFormat("yyyy-MM-dd");
  //減去一天轉成string
  String bb =
      dataFormat.format(dt.subtract(new Duration(days: 1))).toUpperCase();
  //轉成dateTime
  DateTime dateTime = dataFormat.parse(bb);
  return dateTime.microsecondsSinceEpoch;
}
