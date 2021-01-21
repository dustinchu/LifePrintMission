import 'package:flutter/material.dart';
import 'package:text_print_3d/common/extra/color.dart';

Widget rowTitleText(String text) {
  return Text(
    text,
    style: TextStyle(
        color: AppColors.settingTitleColor,
        fontSize: 22,
        fontWeight: FontWeight.bold),
  );
}

Widget line() {
  return Container(
    height: 1,
    color: AppColors.settingLineColor,
  );
}

Widget title() {
  return Align(
    child: Container(
        padding: EdgeInsets.only(bottom: 10), child: rowTitleText("Setting")),
  );
}

Widget popIcon(
  void iconBtn(),
) {
  return Align(
    alignment: Alignment.topLeft,
    child: Container(
        padding: EdgeInsets.only(left: 15),
        child: InkWell(
          onTap: () {
            iconBtn();
          },
          child: Icon(
            Icons.chevron_left,
            color: AppColors.settingTitleColor,
            size: 25,
          ),
        )),
  );
}

Widget rowBtn(void closeBtn(), bool status) {
  return FlatButton(
    padding: EdgeInsets.all(5),
    minWidth: 56,
    height: 26,
    onPressed: closeBtn,
    child: Text(
      "Save",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    color: status
        ? AppColors.settingSaveBtnTrueColor
        : AppColors.settingSaveBtnFalseColor,
    textColor: Colors.white,
    shape: RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.white,
        width: 1,
      ),
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
  );
}
