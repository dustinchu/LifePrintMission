import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:text_print_3d/model/list_data.dart';
import 'package:text_print_3d/util/sql.dart';

class CalendarStatus extends ChangeNotifier {
  TodoProvider _sql = TodoProvider();
  bool lodding = false;
  var calendarMarkMap = <DateTime, List>{};
  List<ListDataModel> listData;
  String calendarYear = '';
  DateTime initialSelectedDay = DateTime.now();
  DateTime selectDate = DateTime.now();
  DateTime saveDate = DateTime.now();

  List<ListDataModel> get getListData => listData;
  bool get getloddingStatus => lodding;
  get gatCalendarMarkMap => calendarMarkMap;
  String get gatYearString => calendarYear;
  DateTime get getInitialDay => initialSelectedDay;
  DateTime get getSelectDate => selectDate;

  void setClickSave() {
    selectDate = saveDate;
    notifyListeners();
  }

  void setSaveDate(DateTime dt) {
    saveDate = dt;
    notifyListeners();
  }

  void setSelectDate(DateTime dt) async{
    print("DT$dt");
    selectDate = dt;
    notifyListeners();
  }

  void setInitialSelectDay(DateTime dt) {
    initialSelectedDay = dt;
    notifyListeners();
  }

  void setYear(String year) {
    calendarYear = year;
    notifyListeners();
  }

  void getAllListData() async {
    lodding = true;
    notifyListeners();


    String toDay =
        new DateFormat("MMM", "en_US").format(selectDate).toUpperCase() +
            ". " +
            new DateFormat("d", "en_US").format(selectDate).toUpperCase() +
            ", " +
            new DateFormat("y", "en_US").format(selectDate).toUpperCase();

    await _sql.open();
    await _sql.getTodo(toDay).then((value) {
      listData = value;
    });

    // print("ListData=====${listData[2].key}");
    // notifyListeners();
    // await _sql.close();

    lodding = false;
    notifyListeners();
  }

  void getAllMark() async {
    calendarMarkMap.clear();
    await _sql.open();
    await _sql.selectAll().then((value) {
      if (value != null) {
        List.generate(value.length, (i) {
          //將日期寫進去 給日曆mark使用
          calendarMarkMap[
              DateTime.fromMicrosecondsSinceEpoch(value[i].insertDatetime)] = [
            'New Year\'s Day'
          ];
        });
      }
      //如果＝null給個隨便的日期讓他不要空值
      else {
        calendarMarkMap[DateTime(2012, 11, 25)] = ['New Year\'s Day'];
      }
    });

    notifyListeners();
    // await _sql.close();
  }

  //查詢區間 給時間區間
  void getIntervalData(int old, int news) async {
    lodding = true;
    notifyListeners();

    await _sql.open();
    await _sql.getCalendarInterval(old, news).then((value) {
      listData = value;
    });

    notifyListeners();
    // await _sql.close();

    lodding = false;
    notifyListeners();
  }

  void selectAll() async {
    await _sql.open();
    await _sql.selectAll();
    // await _sql.close();
  }

  void listDataDeleteEvent(int id) async {
    await _sql.open();
    await _sql.delete(id);
    notifyListeners();
    // await _sql.close();
  }
}
