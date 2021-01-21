import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/state/setting_status.dart';

import 'notification.dart';
import 'seting.dart';
import 'username.dart';

class SettingRoute extends StatefulWidget {
  @override
  _SettingRouteState createState() => _SettingRouteState();
}

class _SettingRouteState extends State<SettingRoute> {
  List<Widget> pages;

  @override
  void initState() {
    pages = [
      SettingScreen(),
      Username(),
      SettingNotification(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var settingState = Provider.of<SettingStatus>(context);
    return pages[settingState.getRoute];
  }
}
