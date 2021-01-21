import 'package:flutter/material.dart';

class SettingSqlModel {
  static final String tableName = 'setting';
  static final String columnId = '_id';
  static final String columnUsername = 'username';
  static final String columnSavaStatus = 'saveStatus';
  static final String columnTime = 'notificationTime';
  static final String columnTimeStatus = 'notificationTimeStatus';
  static final String columnNotificationStatus = 'notificationStatus';
  static final String columnNotificationSaveStatus = 'notificationSaveStatus';

  static final String columnBluetoothStatus = 'bluetoothStatus';
  int id;
  String username;
  int saveStatus;
  String notificationTime;
  int notificationTimeStatus;
  int notificationStatus;
  int bluetoothStatus;
  int notificationSaveStatus;
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnUsername: username,
      columnSavaStatus: saveStatus,
      columnTime: notificationTime,
      columnTimeStatus: notificationTimeStatus,
      columnNotificationStatus: notificationStatus,
      columnBluetoothStatus: bluetoothStatus,
      columnNotificationSaveStatus: notificationSaveStatus
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  SettingSqlModel(
      {this.id,
      this.username,
      this.saveStatus,
      this.notificationTime,
      this.notificationTimeStatus,
      this.notificationStatus,
      this.bluetoothStatus,
      this.notificationSaveStatus});

  SettingSqlModel.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    username = map[columnUsername];
    saveStatus = map[columnSavaStatus];
    notificationTime = map[columnTime];
    notificationTimeStatus = map[columnTimeStatus];
    notificationStatus = map[columnNotificationStatus];
    notificationSaveStatus = map[columnNotificationSaveStatus];
    bluetoothStatus = map[columnBluetoothStatus];
  }
  @override
  toString() =>
      '{id:$id,username:$username,saveStatus: $saveStatus,notificationTime:$notificationTime,notificationTimeStatus:$notificationTimeStatus,notificationStatus:$notificationStatus}';
}
