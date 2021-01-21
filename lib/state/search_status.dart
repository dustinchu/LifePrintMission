import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:text_print_3d/common/toastInfo.dart';
import 'package:text_print_3d/common/today.dart';
import 'package:text_print_3d/model/list_data.dart';
import 'package:text_print_3d/util/sql.dart';

class SearchStatus extends ChangeNotifier {
  TodoProvider _sql = TodoProvider();
  List<ListDataModel> afterListData;
  List<ListDataModel> beforeListData;
  bool listDataStatus = false;
  bool init = true;

  bool get getListDataStatus => listDataStatus;
  bool get getInit => init;
  List<ListDataModel> get getafterListData => afterListData;
  List<ListDataModel> get getbeforListData => beforeListData;
  Map<DateTime, List> calendarMark;
  var createDoc = <DateTime, List>{};

  void setBeforeListDataNull() {
    beforeListData = null;
    afterListData = null;
    notifyListeners();
  }

  void setBeforeListDataInit(bool status) {
    init = status;
    notifyListeners();
  }

  void getAllListData(String value) async {
    listDataStatus = true;
    notifyListeners();

    await _sql.open();
    // await _sql.deleteAll();
    await _sql
        .getSearchListAllTodos(true, value)
        .then((value) => afterListData = value);
    //null 寫值會錯誤
    if (afterListData != null) {
      afterListData.insert(0, ListDataModel(title: true));
      afterListData.add(ListDataModel(title: false));
    }
    //將pats的值寫到同一個list
    await _sql.getSearchListAllTodos(false, value).then((value) {
      beforeListData = value;
      if (value != null) {
        //after null要給他一個值 add會錯誤 確保brfore有值在寫入
        if (afterListData == null) {
          afterListData = [ListDataModel(title: false)];
        }
        List.generate(value.length, (i) {
          afterListData.add(beforeListData[i]);
        });
      }
    });

    // createDoc[DateTime(2020, 12, 25)] = ['Easter Monday'];
    // print(createDoc);
    //    List.generate(value.length, (i) {
    //   calendarMark[ DateTime(2020, 12, 25)]=['New Year\'s Day'];
    // });
    // print(
    //     "listdata====${DateTime.fromMicrosecondsSinceEpoch(beforeListData[0].insertDatetime)}");
    notifyListeners();
    // await _sql.close();

    listDataStatus = false;
    notifyListeners();
  }
}
