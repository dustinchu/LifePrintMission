import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/screen/home_screen/home_screen.dart';

import 'screen/calendar_screen/calendar_screen.dart';
import 'screen/scrolling_calendar_screen/scrolling_screen.dart';
import 'screen/welcoom_screen/welcome1.dart';
import 'state/calendar_status.dart';
import 'state/calendar_tab_status.dart';
import 'state/date_status.dart';
import 'state/home_status.dart';
import 'state/layer_status.dart';
import 'state/list_slidable.dart';
import 'state/provider_ble.dart';
import 'state/search_status.dart';
import 'state/setting_status.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 強制豎屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

// 用于路由返回监听
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: HomeStatus()),
        ChangeNotifierProvider.value(value: LayerStatus()),
        ChangeNotifierProvider.value(value: DateStatus()),
        ChangeNotifierProvider.value(value: SearchStatus()),
        ChangeNotifierProvider.value(value: CalendarStatus()),
        ChangeNotifierProvider.value(value: SettingStatus()),
        ChangeNotifierProvider.value(value: CalendarTabStatus()),
        ChangeNotifierProvider.value(value: BluetoothStatus()),
        ChangeNotifierProvider.value(value: ListSlidableStatus()),
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        title: 'Print',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          //需設定透明bottom sheet才會有圓角
          canvasColor: Colors.transparent,
        ),
        initialRoute: "/",
        routes: {
          '/': (context) => Welcome1Screen(),
          '/calendar': (context) => CalendarScreen(),
          '/Scrolling': (context) => ScrollingScreen(),
        },
      ),
    );
  }
}
