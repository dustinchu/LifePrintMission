import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:text_print_3d/model/list_data.dart';
import 'package:text_print_3d/util/sql.dart';

class CalendarTabStatus extends ChangeNotifier {
  String calendarYear = '';

  String get gatYearString => calendarYear;

  void setYear(String year) {
    calendarYear = year;
    notifyListeners();
  }
}
