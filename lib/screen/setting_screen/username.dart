import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/state/setting_status.dart';

import 'sure.dart';
import 'widget.dart';

class Username extends StatefulWidget {
  Username({Key key}) : super(key: key);

  @override
  _UsernameState createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  TextEditingController usernameTextEditingController;
  bool iconStatus = true;
  double h = 320;
  @override
  void initState() {
    usernameTextEditingController = TextEditingController();
    super.initState();
  }

  void textFieldOntap() {
    // Provider.of<SettingStatus>(context, listen: false).updateUsernameStatus(0);
    setState(() {
      h = 600;
    });
    print("intap");
  }

  void keyboardClose(text) {
    setState(() {
      h = 320;
    });
    print("keyboardClose  text====$text");
  }

  void textChange(String text) {
    //有值顯示紅色
    if (text.length > 0) {
      Provider.of<SettingStatus>(context, listen: false)
          .updateUsernameStatus(1);
      Provider.of<SettingStatus>(context, listen: false).setUsernameText(text);
    } else
      Provider.of<SettingStatus>(context, listen: false)
          .updateUsernameStatus(0);
  }

  @override
  Widget build(BuildContext context) {
    var settingState = Provider.of<SettingStatus>(context);

    void saveBtn() {
      //如果更改過就把更改資料存起來  輸入資料會先把text存起來
      if (settingState.getSettingListData[0].saveStatus == 1) {
        Provider.of<SettingStatus>(context, listen: false).updateUsernameText();
        Provider.of<SettingStatus>(context, listen: false).setRoute(0);
      }
      print("saveBtn");
    }

    void onSave() {
      if (settingState.getSettingListData[0].saveStatus == 1) {
        Provider.of<SettingStatus>(context, listen: false).updateUsernameText();
        Navigator.pop(context);
        Provider.of<SettingStatus>(context, listen: false).setRoute(0);
      }
    }

    void opensheet(BuildContext context) async {
      showModalBottomSheet(
          context: (context),
          enableDrag: true,
          isDismissible: true,
          builder: (context) {
            return Sure(
              onSave: onSave,
            );
          });
    }

    void iconBtn() {
      if (settingState.getSettingListData[0].saveStatus == 1) {
        opensheet(context);
      } else {
        Provider.of<SettingStatus>(context, listen: false).setRoute(0);
      }
      // Provider.of<SettingStatus>(context, listen: false).setRoute(0);
      // Navigator.pop(context);
      print("iconBtn");
    }

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        height: h,
        width: double.maxFinite,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                popIcon(iconBtn),
                title(),
              ],
            ),
            line(),
            _rowWidget(saveBtn, settingState),
            // FlatButton(
            //     onPressed: () {
            //       opensheet(context);
            //     },
            //     child: Text("1234"))
          ],
        ));
  }

  Widget _rowWidget(saveBtn, settingState) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Expanded(child: rowTitleText("Username")),
        Expanded(
            child: _textField(textFieldOntap, keyboardClose, settingState)),
        rowBtn(saveBtn, settingState.getSettingListData[0].saveStatus == 1),
        SizedBox(
          width: 15,
        )
      ],
    );
  }

  Widget _textField(void ontpa(), void keyboardClose(text), settingState) {
    return TextFormField(
      onTap: ontpa,
      controller: usernameTextEditingController,
      // contentPadding: EdgeInsets.all(10.0),
      style: TextStyle(
          textBaseline: TextBaseline.alphabetic,
          color: AppColors.settingTextBodyColor,
          fontSize: 20,
          fontWeight: FontWeight.bold),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent, //边线颜色为黄色
          ),
        ),
        contentPadding: EdgeInsets.all(0),
        disabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        counterText: '',
        hintText: settingState.getSettingListData[0].username == null
            ? "username"
            : settingState.getSettingListData[0].username == ""
                ? "username"
                : settingState.getSettingListData[0].username,
        hintStyle: TextStyle(
            color: AppColors.settingTime50,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      onChanged: textChange,
      onFieldSubmitted: keyboardClose,
      maxLength: 10,
      maxLines: 1,
      // controller: titleClickController,
    );
  }
}
