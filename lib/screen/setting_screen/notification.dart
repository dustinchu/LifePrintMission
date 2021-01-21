import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/state/setting_status.dart';

import 'sure.dart';
import 'widget.dart';

class SettingNotification extends StatefulWidget {
  SettingNotification({Key key}) : super(key: key);

  @override
  _SettingNotificationState createState() => _SettingNotificationState();
}

class _SettingNotificationState extends State<SettingNotification> {
  @override
  Widget build(BuildContext context) {
    var textEditingController = TextEditingController();
    var maskFormatter = new MaskTextInputFormatter(
        mask: '##:##', filter: {"#": RegExp(r'[0-9]')});

    var settingState = Provider.of<SettingStatus>(context);
    @override
    void initState() {
      super.initState();
    }

    if (settingState.getEditStatus) {
      if (settingState.getNotificationTime == "") {
        textEditingController.text = "09:00";
      } else
        textEditingController.text = settingState.getNotificationTime;
      Provider.of<SettingStatus>(context, listen: false).setEditStatus();
    } else {
      textEditingController.text = settingState.getNotificationTime;
    }
    //尚未儲存離開
    void onSave() {
      if (settingState.getCompareStatus) {
        Provider.of<SettingStatus>(context, listen: false).updateNotification();
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
      if (settingState.getCompareStatus)
        opensheet(context);
      else
        Navigator.pop(context);
      // print("??");
      // Provider.of<SettingStatus>(context, listen: false).setRoute(0);
      // Navigator.pop(context);
      print("iconBtn");
    }

    void saveBtn() {
      //如果更改過就把更改資料存起來  輸入資料會先把text存起來
      if (settingState.getCompareStatus) {
        Provider.of<SettingStatus>(context, listen: false).updateNotification();
        Provider.of<SettingStatus>(context, listen: false).setRoute(0);
        print("saveBtn===save");
      }
      print("saveBtn");
    }

    void ontpa() {
      Provider.of<SettingStatus>(context, listen: false)
          .setEditOntapStatus(true);
      print("ontpa");
    }

    void keyboardClose(text) {
      Provider.of<SettingStatus>(context, listen: false)
          .setEditOntapStatus(false);
      Provider.of<SettingStatus>(context, listen: false)
          .setNewNotificationTime(text);
      Provider.of<SettingStatus>(context, listen: false).compare();
      print("keyboardClose====$text");
    }

    void keyboardChange(text) {
      print("keyboardChange====$text");
    }

    void amOntap() {
      Provider.of<SettingStatus>(context, listen: false)
          .setNewNotificationTimaStatus(0);
      Provider.of<SettingStatus>(context, listen: false).compare();
      print("amIntap");
    }

    void pmOntap() {
      Provider.of<SettingStatus>(context, listen: false)
          .setNewNotificationTimaStatus(1);
      Provider.of<SettingStatus>(context, listen: false).compare();
      print("pmIntap");
    }

    Widget switchNotification() {
      return FlutterSwitch(
        toggleSize: 22,
        padding: 2,
        borderRadius: 30.0,
        inactiveColor: Color.fromRGBO(0, 0, 0, 0.2),
        activeColor: AppColors.selectBackroundColor,
        width: 48.0,
        height: 26.0,
        value: settingState.getNotificationStatus == 0 ? false : true,
        onToggle: (val) {
          // print(
          //     "status===${settingState.getSettingListData[0].notificationStatus}");
          // Provider.of<SettingStatus>(context, listen: false)
          //     .updateNotificationStatus(val ? 1 : 0);

          Provider.of<SettingStatus>(context, listen: false)
              .setNewNotificationStatus(val ? 1 : 0);
          Provider.of<SettingStatus>(context, listen: false).compare();
        },
      );
    }

    Widget _rowWidget() {
      return Row(
        children: [
          SizedBox(
            width: 20,
          ),
          rowTitleText("Notification"),
          // Expanded(child: rowTitleText("Notification")),
          SizedBox(
            width: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: switchNotification(),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  " ",
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          rowBtn(saveBtn, settingState.getCompareStatus),
          SizedBox(
            width: 20,
          )
        ],
      );
    }

    Widget _textField() {
      return Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Container(
          padding: EdgeInsets.only(top: 10),
          alignment: Alignment.center,
          width: 70,
          height: 30,
          decoration: BoxDecoration(
              color: settingState.getEditOntapStatus
                  ? AppColors.settingSaveBtnTrueColor
                  : AppColors.selectBackroundColor,
              borderRadius: BorderRadius.all(Radius.circular(50.0))),
          child: TextFormField(
            scrollPadding: EdgeInsets.all(0),
            onTap: ontpa,
            style: TextStyle(
                textBaseline: TextBaseline.alphabetic,
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            inputFormatters: [maskFormatter],
            textAlign: TextAlign.center,
            controller: textEditingController,
            keyboardType: TextInputType.number,
            onChanged: keyboardChange,
            onFieldSubmitted: keyboardClose,
            maxLength: 5,
            maxLines: 1,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              counter: SizedBox.shrink(),
              // hintText: "00:00",
              // hintStyle: TextStyle(
              //     textBaseline: TextBaseline.alphabetic,
              //     color: Colors.white,
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold),
              isDense: true, // important line
              // fillColor: AppColors
              //     .selectBackroundColor, // control your hints text size
              filled: true,
              // border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(30),
              //     borderSide: BorderSide.none),
            ),
          ),
        ),
      );
    }

    Widget _ampm(String text, void ontap(), int status, int model) {
      return InkWell(
        onTap: ontap,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 4),
            width: 56,
            height: 30,
            decoration: BoxDecoration(
                color: model == 0
                    ? status == 0
                        ? AppColors.selectBackroundColor
                        : AppColors.settingTime50
                    : status == 1
                        ? AppColors.selectBackroundColor
                        : AppColors.settingTime50,
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    Widget _rowWidget2() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
          ),
          Text(
            "Time",
            style: TextStyle(
                color: AppColors.selectBackroundColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          _textField(),
          _ampm("a.m.", amOntap, settingState.newNotificationTimaStatus, 0),
          _ampm("p.m.", pmOntap, settingState.newNotificationTimaStatus, 1)
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
      height: settingState.getEditOntapStatus ? 620 : 320,
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
          _rowWidget(),
          SizedBox(
            height: 10,
          ),
          _rowWidget2()

          //     child: Text("1234"))
        ],
      ),
    );
  }
}
