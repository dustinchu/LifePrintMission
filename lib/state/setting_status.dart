import 'dart:io';

import 'package:flutter/material.dart';
import 'package:text_print_3d/model/setting_sql.dart';
import 'package:text_print_3d/util/setting_sql.dart';

class SettingStatus extends ChangeNotifier {
  SettingSql _sql = SettingSql();
  List<SettingSqlModel> settingListData;
  List<SettingSqlModel> notificationOldListData;

  int route = 0;
  // bool settingUsernameBtnStatus = false;
  bool usernameSaveStatus = false;
  String usernameText = "";
  int notificationSaveStatus = 0;
  bool editOntapStatus = false;
  bool editStatus = true;

  bool compareNotification = false;

  int newNotificationStatus = 0;
  int newNotificationTimaStatus = 0;
  String newNotificationTime = "09:30";
  //路由
  get getRoute => route;
  // username save button
  // get getBtnStatus => settingUsernameBtnStatus;
  //返回上一頁判斷
  get getSaveStatus => usernameSaveStatus;
  //設定頁資料
  List<SettingSqlModel> get getSettingListData => settingListData;

  int get getNotificationSaveStatus => notificationSaveStatus;
  bool get getEditOntapStatus => editOntapStatus;
  bool get getCompareStatus => compareNotification;
  int get getNotificationStatus => newNotificationStatus;
  int get getNotificationTimaStatus => newNotificationTimaStatus;
  String get getNotificationTime => newNotificationTime;
  bool get getEditStatus => editStatus;

  void setEditStatus() {
    editStatus = false;
  }

  void setNewNotificationStatus(int status) {
    newNotificationStatus = status;
    notifyListeners();
  }

  void setNewNotificationTimaStatus(int status) {
    newNotificationTimaStatus = status;
    print(
        "am pm    1===$newNotificationStatus  2===$newNotificationTimaStatus  3===$newNotificationTime");
    notifyListeners();
  }

  void setNewNotificationTime(String time) {
    print("edit == $time");
    newNotificationTime = time;
    notifyListeners();
  }

  void compare() {
    // print("看一下edit${notificationOldListData[0].notificationTime}");
    if (notificationOldListData[0].notificationStatus !=
            newNotificationStatus ||
        notificationOldListData[0].notificationTimeStatus !=
            newNotificationTimaStatus ||
        notificationOldListData[0].notificationTime != newNotificationTime)
      compareNotification = true;
    else
      compareNotification = false;
    // print(
    //     "1===${notificationOldListData[0].notificationStatus}  1-1===$newNotificationStatus  2===${notificationOldListData[0].notificationTimeStatus}  2-1==$newNotificationTimaStatus");
    // print(
    //     "3===${notificationOldListData[0].notificationTime} 3-1===$newNotificationTime");
    // print(
    //     "compare====${notificationOldListData[0].notificationStatus != newNotificationStatus || notificationOldListData[0].notificationTimeStatus != newNotificationTimaStatus || notificationOldListData[0].notificationTime != newNotificationTime}");
    notifyListeners();
  }

  void setInsetData() async {
    var insetData = SettingSqlModel(
        username: "",
        saveStatus: 0,
        notificationTime: "09:30",
        notificationStatus: 0,
        notificationTimeStatus: 0,
        notificationSaveStatus: 0,
        bluetoothStatus: 0);
    await _sql.open();
    if (await _sql.selectAll() == null) {
      await _sql.insert(insetData);
    }
  }

  void setEditOntapStatus(bool status) {
    editOntapStatus = status;
    notifyListeners();
  }

  void getListData() async {
    await _sql.open();
    await _sql.selectAll().then((value) => settingListData = value);
    notifyListeners();
  }

  void getOldListData() async {
    await _sql.open();
    await _sql.selectAll().then((value) => notificationOldListData = value);
  }

  //初始0 點擊extfiled改1儲存後改為0
  void updateUsernameStatus(int status) async {
    await _sql.open();
    await _sql.updateSaveStatus(status);
    await _sql.selectAll().then((value) => settingListData = value);
    notifyListeners();
  }

  // void setTimeStatus(int index) async {
  //   await _sql.open();
  //   await _sql.updateNotificationTimeStatus(index);
  //   await _sql.selectAll().then((value) => settingListData = value);
  //   notifyListeners();
  // }

  void initNotification() async {
    await _sql.open();
    await _sql.selectAll().then((value) {
      settingListData = value;
      notificationOldListData = value;
    });
    newNotificationStatus = settingListData[0].notificationStatus;
    newNotificationTimaStatus = settingListData[0].notificationTimeStatus;
    newNotificationTime = settingListData[0].notificationTime;
    editStatus = true;
    //儲存按鈕顏色
    compareNotification = false;
    // print(
    //     "1===$newNotificationStatus  2===$newNotificationTimaStatus  3===$newNotificationTime");
    notifyListeners();
  }

  void setRoute(int index) async {
    route = index;
    notifyListeners();
  }

  void setSaveStatos(bool status) async {
    usernameSaveStatus = status;
    notifyListeners();
  }

  void setUsernameText(String text) {
    usernameText = text;
  }

  void updateNotification() async {
    //     newNotificationStatus = settingListData[0].notificationStatus;
    // newNotificationTimaStatus = settingListData[0].notificationTimeStatus;
    // newNotificationTime = settingListData[0].notificationTime;
    await _sql.open();
    await _sql.updateNotification(
        newNotificationStatus, newNotificationTime, newNotificationTimaStatus);
    await _sql.selectAll().then((value) => settingListData = value);
    notifyListeners();
  }

  void updateUsernameText() async {
    await _sql.open();
    await _sql.updateUsernameText(usernameText);
    await _sql.selectAll().then((value) => settingListData = value);
    notifyListeners();
  }

  void updateNotificationStatus(int status) async {
    await _sql.open();
    await _sql.updateNotificationStatus(status);
    await _sql.selectAll().then((value) => settingListData = value);
    // if (settingListData[0].notificationStatus !=
    //     notificationOldListData[0].notificationStatus) {
    //   notificationSaveStatus = 1;
    // } else {
    //   notificationSaveStatus = 0;
    // }

    notifyListeners();
  }

  void setNotificationSaveStatus(int status) {
    notificationSaveStatus = status;
    notifyListeners();
  }

  // void initUsetnameStatus() async {
  //   settingUsernameBtnStatus = false;
  //   usernameSaveStatus = false;
  //   notifyListeners();
  // }
}
