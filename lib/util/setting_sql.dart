import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:text_print_3d/common/today.dart';
import 'package:text_print_3d/model/list_data.dart';
import 'package:text_print_3d/model/setting_sql.dart';

class SettingSql {
  Database db;
  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'setting.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
create table ${SettingSqlModel.tableName} ( 
  ${SettingSqlModel.columnId} integer primary key autoincrement, 
  ${SettingSqlModel.columnUsername} text not null,
  ${SettingSqlModel.columnSavaStatus}  integer not null,
  ${SettingSqlModel.columnTime} text not null,
  ${SettingSqlModel.columnTimeStatus} integer not null,
  ${SettingSqlModel.columnNotificationStatus}  integer not null,
    ${SettingSqlModel.columnNotificationSaveStatus}  integer not null,
  ${SettingSqlModel.columnBluetoothStatus}  integer not null)
''');
    });
  }

  Future<SettingSqlModel> insert(SettingSqlModel todo) async {
    todo.id = await db.insert(
      SettingSqlModel.tableName,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return todo;
  }

  Future<List<SettingSqlModel>> selectAll() async {
    final List<Map<String, dynamic>> maps =
        await db.query(SettingSqlModel.tableName, orderBy: "_id");
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return SettingSqlModel(
          id: maps[i]['_id'],
          username: maps[i]['username'],
          saveStatus: maps[i]['saveStatus'],
          notificationTime: maps[i]['notificationTime'],
          notificationTimeStatus: maps[i]['notificationTimeStatus'],
          notificationStatus: maps[i]['notificationStatus'],
          bluetoothStatus: maps[i]['bluetoothStatus'],
        );
      });
    }
    return null;
  }

  //   Future<int> update(SettingSqlModel todo) async {
  //   return await db.update(SettingSqlModel.tableName, todo.toMap(),
  //       where: '$SettingSqlModel.columnId = ?', whereArgs: [todo.id]);
  // }

  Future<int> deleteAll() async {
    return await db.rawDelete("DELETE FROM ${SettingSqlModel.tableName}");
    // return await db.delete(ListDataModel.tableTodo, where: '$ListDataModel{columnId} = ?', whereArgs: [id]);
  }

//0還沒修改還沒儲存 1儲存
  Future<int> updateSaveStatus(int status) async {
    return await db.rawUpdate(
        "UPDATE ${SettingSqlModel.tableName} SET ${SettingSqlModel.columnSavaStatus}=$status  WHERE  ${ListDataModel.columnId}='1' ");
  }

  //notification
  Future<int> updateNotification(
      int switchStatus, String time, int timeStatus) async {
    return await db.rawUpdate(
        "UPDATE ${SettingSqlModel.tableName} SET ${SettingSqlModel.columnNotificationStatus}=$switchStatus ,${SettingSqlModel.columnTime}='$time' ,${SettingSqlModel.columnTimeStatus}=$timeStatus   WHERE  ${ListDataModel.columnId}='1' ");
  }

  //username text
  Future<int> updateUsernameText(String text) async {
    return await db.rawUpdate(
        "UPDATE ${SettingSqlModel.tableName} SET ${SettingSqlModel.columnUsername}='$text'  WHERE  ${ListDataModel.columnId}='1' ");
  }

  //notification Status
  Future<int> updateNotificationStatus(int status) async {
    return await db.rawUpdate(
        "UPDATE ${SettingSqlModel.tableName} SET ${SettingSqlModel.columnNotificationStatus}=$status  WHERE  ${ListDataModel.columnId}='1' ");
  }

  //notification TimeStatus
  Future<int> updateNotificationTimeStatus(int status) async {
    return await db.rawUpdate(
        "UPDATE ${SettingSqlModel.tableName} SET ${SettingSqlModel.columnTimeStatus}=$status  WHERE  ${ListDataModel.columnId}='1' ");
  }

  Future close() async => db.close();
}
