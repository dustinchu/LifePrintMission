import 'dart:io';

import 'package:backdrop/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/toastInfo.dart';
import 'package:text_print_3d/common/today.dart';
import 'package:text_print_3d/model/list_data.dart';
import 'package:text_print_3d/util/sql.dart';

import 'calendar_status.dart';
import 'layer_status.dart';

class DateStatus extends ChangeNotifier {
  String addDate = "";
  int addIntDate = 0;
  String rowSelectedDate = "";
  TodoProvider _sql = TodoProvider();
  List<ListDataModel> listData;
  bool listDataStatus = false;
  bool instartState = false;

  //listVise編輯資料儲存用
  DateTime selectDate = DateTime.now();
  String textTitle = "";
  String textBody = "";
  int listDataID = 0;
  String editDate = "";
  bool editState = false;
  String printTitle = "";

  String get getPrintTitle => printTitle;
  bool get getEditState => editState;
  String get getEditDate => editDate;
  bool get getInstartState => instartState;
  bool get getListDataStatus => listDataStatus;
  List<ListDataModel> get getListData => listData;
  String get getCalendarSelectDate => addDate;
  //ListView編輯資料使用
  DateTime get getSelectDate => selectDate;
  String get getTextTitle => textTitle;
  String get getTextBody => textBody;
  int get getListDataID => listDataID;

  void setEditState(bool state) {
    editState = state;
    notifyListeners();
  }

  void setEditDate(String date) {
    editDate = date;
    notifyListeners();
  }

  void deleteId(int id) async {
    await _sql.open();
    await _sql.delete(id);
    // await _sql.close();
  }

  void setListDataID(int id) {
    listDataID = id;
  }

  void initListEdit() async {
    selectDate = DateTime.now();
    textTitle = "";
    textBody = "";
    addDate = "";
    textTitle = "";
    textBody = "";
    listDataID = 0;
    notifyListeners();
  }

  void setListEdit(
      DateTime dt, String title, String body, int id, String dateStr) async {
    print("seart add id $listDataID");
    selectDate = dt;
    textTitle = title;
    textBody = body;
    listDataID = id;
    addDate = dateStr;
    print("end add id $listDataID");
    notifyListeners();
  }

  void setAddDate(String date, int intDate) async {
    //date  選擇後日期  組成字串
    //intDate 選擇的日期 yyyy-mm-dd 轉成int
    addDate = date;
    addIntDate = intDate;
    notifyListeners();
  }

  void updateMoveListIndex(int oldID, int old, int newID, int newi) async {
    await _sql.open();
    await _sql.update(oldID, old);
    await _sql.update(newID, newi);
    // await _sql.selectAll();
    // await _sql.close();
  }

  void listDataDeleteEvent(int id) async {
    await _sql.open();
    await _sql.delete(id);
    //一啟動刪除當天list資料的話會沒日期 把今天日期寫進去
    if (rowSelectedDate == "") {
      rowSelectedDate = toDayString;
    }
    await _sql.getTodo(rowSelectedDate).then((value) => listData = value);
    notifyListeners();
    // await _sql.close();
  }

  void selectedRowDateEvent(String toDay, bool save) async {
    if (!save) rowSelectedDate = toDay;
    listDataStatus = true;
    notifyListeners();

    await _sql.open();
    // await _sql.deleteAll();
    printTitle = "";
    await _sql.getTodo(toDay).then((value) {
      listData = value;
      //有緊急的存起來 給藍芽print判斷 只列印緊急的資料
      if (value != null) {
        for (var list in value) {
          if (list.imageStatus == 2) {
            printTitle = list.listTitle;
          }
        }
      }
    });
    // await _sql.selectAll().then((value) => print("listData===$value"));

    // await _sql.close();

    listDataStatus = false;
    notifyListeners();
  }

  void initListData(String toDay) async {
    listDataStatus = true;
    notifyListeners();

    await _sql.open();
    // await _sql.deleteAll();
    await _sql.getTodo(toDay).then((value) {
      listData = value;
      //有緊急的存起來
      if (value != null) {
        for (var list in value) {
          if (list.imageStatus == 2) {
            printTitle = list.listTitle;
          }
        }
      }
    });
    notifyListeners();
    // await _sql.close();

    listDataStatus = false;
    notifyListeners();
  }

  void selectAll() async {
    await _sql.open();
    print(await _sql.selectAll());
    // await _sql.getTodo(102).then((value) => print(value.listTitle));
    // await _sql.close();
  }

  //測試查詢資料
  void selectIndex(String date) async {
    await _sql.open();
    print(await _sql.selectMaxIndex(date));
    // await _sql.getTodo(102).then((value) => print(value.listTitle));
    // await _sql.close();
  }

  void setAddData(String title, String body, int selectedIndex,
      BuildContext context) async {
    bool status = false;
    String msg = "";
    if (title == '') {
      status = true;
      msg = "title is null pls check.";
    }
    if (!status) {
      if (body == '') {
        status = true;
        msg = "body is null pls check.";
      }
    }
    if (!status) {
      if (selectedIndex == null) {
        status = true;
        msg = "pls select your image.";
      }
    }
    //寫入時沒選擇日曆 也可寫入 把當天日期存起來
    if (addDate == "") {
      // Provider.of<CalendarStatus>(context, listen: false)
      //     .setSelectDate(DateTime.now().add(new Duration(days: 1)));
      addDate = tomorrow;
    }

    if (status)
      toastInfo(msg);
    else {
      //沒選日期將明天寫進去
      if (addIntDate == 0) {
        addIntDate = toTomorrow();
        //沒選日期寫入的話將明天日期存起來  跳到日曆頁選擇顯示用
        Provider.of<CalendarStatus>(context, listen: false)
            .setSelectDate(DateTime.now().add(new Duration(days: 1)));
      }
      await _sql.open();
      // insert sql
      var sqlData = ListDataModel(
          listIndex: await _sql.selectMaxIndex(addDate) == null
              ? 1
              : await _sql.selectMaxIndex(addDate),
          listTitle: title,
          listBody: body,
          imageDate: addDate,
          imageStatus: selectedIndex,
          insertDatetime: addIntDate);
      // 剛登入 沒點擊過ROW日期 把當日期存起來
      if (rowSelectedDate == "") rowSelectedDate = toDayString;
      print("insertData=====$sqlData");
      await _sql.insert(sqlData);
      await _sql.getTodo(rowSelectedDate).then((value) => listData = value);
      notifyListeners();
      // await _sql.getTodo(102).then((value) => print(value.listTitle));

      //寫入順便查詢一下日曆以防日曆頁面開啟儲存
      Provider.of<CalendarStatus>(context, listen: false).getAllListData();
      //圖片焦點清除
      Provider.of<LayerStatus>(context, listen: false).layerStatusImageClick(4);
      //以防選擇其他天日期 下次近來沒選日期 會沒寫到今天 將日期改成今天
      Provider.of<DateStatus>(context, listen: false)
          .setAddDate(toDayString, toDayInt());

      // await _sql.close();
      //寫入玩 視窗隱藏
      Backdrop.of(context).fling();
    }
  }

  // calendar

}
