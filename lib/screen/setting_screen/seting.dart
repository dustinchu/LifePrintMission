import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/state/provider_ble.dart';
import 'package:text_print_3d/state/setting_status.dart';
import 'package:text_print_3d/util/blue.dart';

import 'widget.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingStatus = Provider.of<SettingStatus>(context);
    var bluetooth = BlueUtil.instance;
    void username() {
      //切換頁面前先將顏色改為初始
      Provider.of<SettingStatus>(context, listen: false)
          .updateUsernameStatus(0);
      Provider.of<SettingStatus>(context, listen: false).setRoute(1);
      print("username");
    }

    void notification() {
      Provider.of<SettingStatus>(context, listen: false).setRoute(2);
      Provider.of<SettingStatus>(context, listen: false).initNotification();
      print("notification");
    }

    void closeBtn() {
      Navigator.pop(context);
      print("btn");
    }

    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        height: 320,
        width: double.maxFinite,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            title(),
            line(),
            SizedBox(
              height: 10,
            ),
            _rowWidget(
                "Username",
                settingStatus.getSettingListData == null
                    ? ""
                    : settingStatus.getSettingListData[0].username == ""
                        ? "username"
                        : settingStatus.getSettingListData[0].username,
                username,
                true,
                true),
            _rowWidget(
                "Notification",
                "Time ${settingStatus.getSettingListData == null ? "0930" : settingStatus.getSettingListData[0].notificationTime} ${settingStatus.getSettingListData == null ? "a.m." : settingStatus.getSettingListData[0].notificationTimeStatus == 0 ? "a.m." : "p.m."}",
                notification,
                true,
                true),
            StreamBuilder<BluetoothState>(
                stream: FlutterBlue.instance.state,
                initialData: BluetoothState.unknown,
                builder: (c, snapshot) {
                  final state = snapshot.data;
                  if (state == BluetoothState.on) {
                    bluetooth.connectToDevice();
                    if (BluetoothDeviceState.connected == null) {
                      bluetooth.connectToDevice();
                      return _rowWidget("Bluetooth", "Disconnected",
                          notification, false, false);
                    } else {
                      return _rowWidget(
                          "Bluetooth", "Connected", notification, false, true);
                    }
                  } else {
                    return _rowWidget("Bluetooth", "turn on bluetooth.",
                        notification, false, true);
                  }
                }),
            SizedBox(
              height: 30,
            ),
            _rowBtn(closeBtn),
          ],
        ));
  }

  Widget _rowBtn(void closeBtn()) {
    return FlatButton(
      minWidth: 116,
      height: 40,
      onPressed: closeBtn,
      child: Text(
        "Close",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      color: AppColors.settingTextBodyColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(30)),
    );
  }

  Widget _rowWidget(String text, String bodyText, void onPressed(),
      bool iconStatus, bool connect) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Expanded(child: rowTitleText(text)),
        Expanded(child: _textBody(bodyText, connect)),
        iconStatus
            ? IconButton(
                iconSize: 30,
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.chevron_right,
                  color: AppColors.settingTitleColor,
                ),
                onPressed: onPressed)
            : Container(
                child: IconButton(
                    icon: Icon(Icons.chevron_right, color: Colors.transparent),
                    onPressed: () {}),
              )
      ],
    );
  }

  Widget _textBody(String text, bool connect) {
    return Text(
      text,
      style: TextStyle(
          color: connect
              ? AppColors.settingTextBodyColor
              : AppColors.defaultBackroundColor,
          fontSize: 18,
          fontWeight: FontWeight.bold),
    );
  }
}
