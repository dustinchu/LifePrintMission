import 'dart:io';

import 'package:flutter/material.dart';

class ListSlidableStatus extends ChangeNotifier {
  bool listStatus = false;
  bool isOpen = true;

  bool get getBottomBStatus => listStatus;
  bool get getIsOpenStatus => isOpen;

  void setListStatus(bool status) {
    listStatus = status;
    notifyListeners();
  }

  void setClose() {
    isOpen = false;
    notifyListeners();
  }

  void setOpen() {
    isOpen = true;
    notifyListeners();
  }
}
