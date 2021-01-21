import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_print_3d/common/toastInfo.dart';
import 'package:text_print_3d/model/list_data.dart';
import 'package:text_print_3d/util/sql.dart';

class LayerStatus extends ChangeNotifier {
  //底部狀態
  bool calendarStatus = false;
  int index;
  String tomorrow = "tomorrow";
  String title = "";
  String body = "";

  bool get getBottomBStatus => calendarStatus;
  int get getClickIndex => index;
  String get getTomorrow => tomorrow;
  String get getTitle => title;
  String get getBody => body;

  void layerStatusClick(String type) async {
    //日曆開啟狀態
    if (type == 'textField')
      calendarStatus = false;
    else if (type == 'close') {
      calendarStatus = false;
    } else
      calendarStatus = !calendarStatus;
    notifyListeners();
  }

  void layerStatusImageClick(int i) async {
    //點哪一張圖片
    index = i;
    notifyListeners();
  }

  void setTomorrow(String text) {
    tomorrow = text;
    notifyListeners();
  }

  void setTitle(String text) {
    title = text;
    notifyListeners();
  }

  void setBody(String text) {
    body = text;
    notifyListeners();
  }

  void setInit() {
    tomorrow = "tomorrow";
    title = "";
    body = "";
    notifyListeners();
  }
}
