import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeStatus extends ChangeNotifier {
  //底部狀態
  bool bottomStatus = true;
  bool rowBackStatus = false;
  int currentIndex = 0;
  int iconIndex = 0;

  String toDay = "Today's";
  String titleYear =
      new DateFormat("MMM", "en_US").format(DateTime.now()).toUpperCase() +
          ". " +
          new DateFormat("y", "en_US").format(DateTime.now()).toUpperCase();

  int get getIconIndex => iconIndex;
  bool get getBottomStatus => bottomStatus;
  int get getCurrentIndexStatus => currentIndex;
  bool get getRowBackStatus => rowBackStatus;
  String get getToDay => toDay;
  String get getTitleYear => titleYear;

  void setIconIndex(int index) {
    iconIndex = index;
  }

  void setTitleYear(DateTime date) async {
    titleYear = new DateFormat("MMM", "en_US").format(date).toUpperCase() +
        ". " +
        new DateFormat("y", "en_US").format(date).toUpperCase();
    notifyListeners();
  }

  void setToDay(String day) async {
    toDay = day;
    notifyListeners();
  }

  void setRowBackStatus(bool status) async {
    rowBackStatus = status;
    notifyListeners();
  }

  void homeScafoldClick() async {
    //前頁點擊狀態  icon +
    bottomStatus = !bottomStatus;
    notifyListeners();
  }

  //bottom頁面切換
  void setCurrentIndex(index) {
    currentIndex = index;
    notifyListeners();
  }
}
