import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:text_print_3d/common/today.dart';
import 'package:text_print_3d/model/list_data.dart';

class TodoProvider {
  Database db;
  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'print1.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
create table ${ListDataModel.tableTodo} ( 
  ${ListDataModel.columnId} integer primary key autoincrement, 
  ${ListDataModel.columnIndex} integer ,
  ${ListDataModel.columnTitle} text ,
  ${ListDataModel.columnBody} text ,
  ${ListDataModel.columnDate} text ,
  ${ListDataModel.columnImageStatus} integer ,
  ${ListDataModel.columnInsertDatetime} integer )
''');
    });
  }

  Future<ListDataModel> insert(ListDataModel todo) async {
    todo.id = await db.insert(
      ListDataModel.tableTodo,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return todo;
  }

  Future<List<ListDataModel>> getTodos() async {
    final List<Map<String, dynamic>> maps =
        await db.query(ListDataModel.tableTodo, orderBy: "_id");
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return ListDataModel(
          key: ValueKey(i),
          id: maps[i]['_id'],
          listTitle: maps[i]['list_title'],
          listIndex: maps[i]['list_index'],
          listBody: maps[i]['list_body'].toString(),
          imageDate: maps[i]['image_date'],
          imageStatus: maps[i]['image_status'],
          insertDatetime: maps[i]['insertDatetime'],
        );
      });
    }
    return null;
  }

  Future<List<ListDataModel>> getTodo(String date) async {
    final List<Map<String, dynamic>> maps = await db.query(
        ListDataModel.tableTodo,
        where: '${ListDataModel.columnDate} = ?',
        whereArgs: [date],
        orderBy: "list_index");
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return ListDataModel(
          key: ValueKey(i),
          id: maps[i]['_id'],
          listTitle: maps[i]['list_title'],
          listIndex: maps[i]['list_index'],
          listBody: maps[i]['list_body'].toString(),
          imageDate: maps[i]['image_date'],
          imageStatus: maps[i]['image_status'],
          insertDatetime: maps[i]['insertDatetime'],
        );
      });
    }
    return null;
  }

  Future<List<ListDataModel>> getSearchListAllTodos(
      bool status, String value) async {
    List<Map<String, dynamic>> maps;
    int today = toDayInt();
    // status ? today = yesterdayInt() : today = toDayInt();
    String afterQql =
        "Select * from ${ListDataModel.tableTodo} where ${ListDataModel.columnInsertDatetime} >= $today  and ${ListDataModel.columnTitle} LIKE '%$value%' order by insertDatetime";
    String beforSql =
        "Select * from ${ListDataModel.tableTodo} where ${ListDataModel.columnInsertDatetime} < $today  and ${ListDataModel.columnTitle} LIKE '%$value%' order by insertDatetime";

    status
        ? maps = await db.rawQuery(afterQql)
        : maps = await db.rawQuery(beforSql);
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return ListDataModel(
            key: ValueKey(i),
            id: maps[i]['_id'],
            listTitle: maps[i]['list_title'],
            listIndex: maps[i]['list_index'],
            listBody: maps[i]['list_body'].toString(),
            imageDate: maps[i]['image_date'],
            imageStatus: maps[i]['image_status'],
            insertDatetime: maps[i]['insertDatetime'],
            listViewStatus: status);
      });
    }
    return null;
  }

//日曆顯示開始結束區間
  Future<List<ListDataModel>> getCalendarInterval(int old, int news) async {
    List<Map<String, dynamic>> maps;
    int today = monthInt();
    String afterQql =
        "Select * from ${ListDataModel.tableTodo} where ${ListDataModel.columnInsertDatetime} > $old  and  ${ListDataModel.columnInsertDatetime} < $news order by insertDatetime";
    maps = await db.rawQuery(afterQql);
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return ListDataModel(
          key: ValueKey(i),
          id: maps[i]['_id'],
          listTitle: maps[i]['list_title'],
          listIndex: maps[i]['list_index'],
          listBody: maps[i]['list_body'].toString(),
          imageDate: maps[i]['image_date'],
          imageStatus: maps[i]['image_status'],
          insertDatetime: maps[i]['insertDatetime'],
        );
      });
    }
    return null;
  }

  //大於本月份第一天
  Future<List<ListDataModel>> getSalendarAllTodos() async {
    List<Map<String, dynamic>> maps;
    int today = monthInt();
    String afterQql =
        "Select * from ${ListDataModel.tableTodo} where ${ListDataModel.columnInsertDatetime} > $today order by insertDatetime";
    maps = await db.rawQuery(afterQql);
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return ListDataModel(
          key: ValueKey(i),
          id: maps[i]['_id'],
          listTitle: maps[i]['list_title'],
          listIndex: maps[i]['list_index'],
          listBody: maps[i]['list_body'].toString(),
          imageDate: maps[i]['image_date'],
          imageStatus: maps[i]['image_status'],
          insertDatetime: maps[i]['insertDatetime'],
        );
      });
    }
    return null;
  }

  Future<List<ListDataModel>> selectAll() async {
    List<Map<String, dynamic>> maps;
    String afterQql = "Select * from ${ListDataModel.tableTodo}";
    maps = await db.rawQuery(afterQql);
    // print("SleectAll==$maps");
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return ListDataModel(
          key: ValueKey(i),
          id: maps[i]['_id'],
          listTitle: maps[i]['list_title'],
          listIndex: maps[i]['list_index'],
          listBody: maps[i]['list_body'].toString(),
          imageDate: maps[i]['image_date'],
          imageStatus: maps[i]['image_status'],
          insertDatetime: maps[i]['insertDatetime'],
        );
      });
    }
    return null;
  }

  Future<int> selectMaxIndex(String date) async {
    var table = await db.rawQuery(
        "SELECT MAX(list_index)+1 as list_index FROM ${ListDataModel.tableTodo} where image_date='$date'");
    return table.first["list_index"];
    // return await db.delete(ListDataModel.tableTodo, where: '$ListDataModel{columnId} = ?', whereArgs: [id]);
  }

  // Future<int> deleteAll() async {
  //   return await db
  //       .delete(ListDataModel.tableTodo, where: '1 = ?', whereArgs: [1]);
  // }
  Future<int> deleteAll() async {
    return await db.rawDelete("DELETE FROM ${ListDataModel.tableTodo}");
    // return await db.delete(ListDataModel.tableTodo, where: '$ListDataModel{columnId} = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    // 刪除 id

    print("刪除ID==$id");
    return await db
        .delete(ListDataModel.tableTodo, where: '_id = ?', whereArgs: [id]);
  }

  Future<int> update(int id, int idnex) async {
    return await db.rawUpdate(
        "UPDATE ${ListDataModel.tableTodo} SET ${ListDataModel.columnIndex}=$idnex  WHERE  ${ListDataModel.columnId}=$id ");
    // return await db.update(ListDataModel.tableTodo, todo.toMap(),
    //     where: '${ListDataModel.columnDate} = ?  and ${ListDataModel.columnIndex}', whereArgs: [todo.imageDate,todo.listIndex]);
  }

  Future close() async => db.close();
}
