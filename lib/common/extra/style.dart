import 'color.dart';
import 'package:flutter/material.dart';
import 'dimen.dart';

const TextStyle defaultMonthTextStyle = TextStyle(
  color: AppColors.defaultMonthColor,
  fontSize: Dimen.monthTextSize,
  fontWeight: FontWeight.w500,
);

const TextStyle defaultDateTextStyle = TextStyle(
  color: AppColors.defaultDateColor,
  fontSize: Dimen.dateTextSize,
  fontWeight: FontWeight.w500,
);

const TextStyle defaultDayTextStyle = TextStyle(
  color: AppColors.defaultDayColor,
  fontSize: Dimen.dayTextSize,
  fontWeight: FontWeight.w500,
);

const TextStyle outsideWeekendStyle = TextStyle(
    color: Color.fromRGBO(100, 149, 153, 0.5),
    fontSize: 16.0,
    fontWeight: FontWeight.bold);
const TextStyle weekdayStyle = TextStyle(
    color: Color.fromRGBO(100, 149, 153, 1),
    fontSize: 16.0,
    fontWeight: FontWeight.bold);
const TextStyle weekdaySupStyle = TextStyle(
    color: Color.fromRGBO(166, 213, 205, 1),
    fontSize: 16.0,
    fontWeight: FontWeight.bold);

const TextStyle welcomeTitle = TextStyle(
    decoration: TextDecoration.none,
    color: Color.fromRGBO(138, 212, 209, 1),
    fontSize: 36.0,
    fontWeight: FontWeight.bold);
const TextStyle welcomeBody = TextStyle(
    decoration: TextDecoration.none,
    color: Color.fromRGBO(150, 150, 150, 1),
    fontSize: 14.0,
    fontWeight: FontWeight.bold);
