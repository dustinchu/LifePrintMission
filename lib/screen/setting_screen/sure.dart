import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/state/setting_status.dart';

class Sure extends StatelessWidget {
  const Sure({@required this.onSave, Key key}) : super(key: key);
  final onSave;

  @override
  Widget build(BuildContext context) {
    void onLeave() {
      Navigator.pop(context);
      Provider.of<SettingStatus>(context, listen: false).setRoute(0);
      print("onLeave");
    }

    // void onSave() {
    //   print("onSave");
    // }

    return Container(
      color: Color.fromRGBO(166, 213, 205, 1),
      height: 220,
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          _title(),
          _body(),
          SizedBox(
            height: 10,
          ),
          _btnRow(
            onSave,
            onLeave,
          ),
        ],
      ),
    );
  }

  Widget _btnRow(void onSave(), void onLeave()) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _sureBtn("Leave", false, onLeave),
        SizedBox(
          width: 10,
        ),
        _sureBtn("Save", true, onSave)
      ],
    );
  }

  Widget _sureBtn(String text, bool colorStatus, void onBtn()) {
    return FlatButton(
      minWidth: 116,
      height: 40,
      onPressed: onBtn,
      child: Text(
        text,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      color: colorStatus
          ? AppColors.settingSaveBtnTrueColor
          : AppColors.settingTextBodyColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  Widget _body() {
    return Text(
      "Do you want to save the change\nbefore you leave? ",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(31, 56, 58, 1)),
    );
  }

  Widget _title() {
    return Text(
      "Are you sure?",
      style: TextStyle(
          fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
