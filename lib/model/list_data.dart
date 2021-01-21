import 'package:flutter/material.dart';

class ListDataModel {
  static final String tableTodo = 'list_data_1';
  static final String columnId = '_id';
  static final String columnIndex = 'list_index';
  static final String columnTitle = 'list_title';
  static final String columnBody = 'list_body';
  static final String columnDate = 'image_date';
  static final String columnImageStatus = 'image_status';
  static final String columnInsertDatetime = 'insertDatetime';
  int id;
  int listIndex;
  String listTitle;
  String listBody;
  String imageDate;
  int imageStatus;
  int insertDatetime;
  Key key;
  bool listViewStatus;
  bool title;
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnIndex: listIndex,
      columnTitle: listTitle,
      columnBody: listBody,
      columnDate: imageDate,
      columnImageStatus: imageStatus,
      columnInsertDatetime: insertDatetime
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  ListDataModel(
      {this.id,
      this.listTitle,
      this.listBody,
      this.listIndex,
      this.imageDate,
      this.imageStatus,
      this.insertDatetime,
      this.key,
      this.listViewStatus,
      this.title});

  ListDataModel.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    listIndex = map[columnIndex];
    listTitle = map[columnTitle];
    listBody = map[columnBody];
    imageDate = map[columnDate];
    imageStatus = map[columnImageStatus];
    insertDatetime = map[columnInsertDatetime];
  }
  @override
  toString() =>
      '{id:$id,listIndex:$listIndex,listTitle: $listTitle,listBody:$listBody,imageDate:$imageDate,imageStatus:$imageStatus,insertDatetime:$insertDatetime}';
}
