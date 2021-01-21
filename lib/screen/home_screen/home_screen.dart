// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'dart:ui';

import 'package:backdrop/app_bar.dart';
import 'package:backdrop/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/listview_sladable/widgets/slidable.dart';
import 'package:text_print_3d/common/route/bottom_to_top.dart';
import 'package:text_print_3d/common/today.dart';
import 'package:text_print_3d/common/widget/circularProgress.dart';
import 'package:text_print_3d/main.dart';
import 'package:text_print_3d/screen/calendar_screen/calendar_screen.dart';
import 'package:text_print_3d/screen/scrolling_calendar_screen/scrolling_screen.dart';
import 'package:text_print_3d/screen/setting_screen/setting_route.dart';
import 'package:text_print_3d/state/calendar_status.dart';
import 'package:text_print_3d/state/date_status.dart';
import 'package:text_print_3d/state/home_status.dart';
import 'package:text_print_3d/state/layer_status.dart';
import 'package:text_print_3d/state/list_slidable.dart';
import 'package:text_print_3d/state/provider_ble.dart';
import 'package:text_print_3d/state/search_status.dart';
import 'package:text_print_3d/state/setting_status.dart';
import 'package:text_print_3d/util/blue.dart';
import '../home_front_layer/home_front_layer_screen.dart';
import '../search_screen/search_screen.dart';
import 'bottomBar.dart';
import 'card_list.dart';
import 'fa_progress_bar.dart';
import 'row_date/date_picker_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with
        RouteAware,
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        WidgetsBindingObserver {
  DatePickerController _controller = DatePickerController();
  AnimationController animationController;
  DateTime _selectedValue = DateTime.now();

  int _currentIndex = 0;
  var bluetooth = BlueUtil.instance;
  @override
  void initState() {
    bluetooth.scan();
    // Provider.of<BluetoothStatus>(context, listen: false).scan();

    //init 要使用prodvider 要這樣使用
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DateStatus>(context, listen: false).initListData(toDayString);
      Provider.of<SettingStatus>(context, listen: false).setInsetData();
    });
    //編輯頁面動畫控制
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200), value: -1.0);
    // //前後台切換監聽
    // WidgetsBinding.instance.addObserver(this);
    //渲染完畢執行
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      _controller.animateToSelection();
      //設定撈取資料
      Provider.of<SettingStatus>(context, listen: false).getListData();
    });
    super.initState();
  }

  void backLayerConcealed() {
    print("AA");
    Provider.of<HomeStatus>(context, listen: false).homeScafoldClick();
  }

  void backLayerRevealed() {
    print("BB");
    Provider.of<HomeStatus>(context, listen: false).homeScafoldClick();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print("--" + state.toString());
  //   switch (state) {
  //     case AppLifecycleState.inactive:
  //       print("inactive"); // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
  //       break;
  //     case AppLifecycleState.resumed: // 应用程序可见，前台
  //       print("resumed");
  //       break;
  //     case AppLifecycleState.paused: // 应用程序不可见，后台
  //       print("paused");
  //       break;
  //     // case AppLifecycleState.suspending: // 申请将暂时暂停
  //     //   break;
  //   }
  // }

//頁面切換監聽訂閱
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  // @override
  // void didPush() {
  //   debugPrint("------> didPush");
  //   super.didPush();
  // }

  // @override
  // void didPop() {
  //   debugPrint("------> didPop");
  //   super.didPop();
  // }
  //頁面返回
  @override
  void didPopNext() {
    animationController.animateTo(0.5);
    debugPrint("------> didPopNext");
    super.didPopNext();
  }

  // @override
  // void didPushNext() {
  //   debugPrint("------> didPushNext");
  //   super.didPushNext();
  // }

  @override
  void dispose() {
    //前後台監聽關閉
    // WidgetsBinding.instance.removeObserver(this);
    //頁面切換監聽取消訂閱
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bluetooth.connectToDevice();
    // Provider.of<BluetoothStatus>(context, listen: false).connectToDevice();
    var homeState = Provider.of<HomeStatus>(context);
    var dateState = Provider.of<DateStatus>(context);
    var settingStatus = Provider.of<SettingStatus>(context);
    var blueStatus = Provider.of<BluetoothStatus>(context);
    return Stack(
      children: [
        BackdropScaffold(
          controller: animationController,
          //沒設定這個鍵盤打開背景會先是白色
          resizeToAvoidBottomInset: false,
          appBar: _appBar(),
          onBackLayerConcealed: backLayerConcealed,
          onBackLayerRevealed: backLayerRevealed,
          headerHeight: 0,
          // floatingActionButton: homeState.getBottomStatus
          //     ? homeState.getCurrentIndexStatus == 0
          //         ? _floatButton()
          //         : null
          //     : null,
          bottomNavigationBar: homeState.getBottomStatus
              ? BottomBar(
                  homeState: homeState,
                )
              : null,
          frontLayer: HomeFontLayerScreen(),
          backLayer: homeState.getCurrentIndexStatus == 2
              ? CalendarScreen()
              : homeState.getCurrentIndexStatus == 1
                  ? ScrollingScreen()
                  : Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _subAppBar(homeState),
                          _rowListDatetime(),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0)),
                                color: AppColors.homeBody,
                              ),
                              // imageState.getClickIndex
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _listTitle(
                                        settingStatus.getSettingListData == null
                                            ? "Hi, "
                                            : settingStatus
                                                        .getSettingListData[0]
                                                        .username ==
                                                    ""
                                                ? "Hi, username"
                                                : "Hi, ${settingStatus.getSettingListData[0].username}",
                                        20,
                                        10,
                                        20),
                                    _listTitle("${homeState.getToDay} Mission",
                                        0, 5, 24),
                                    //進度數字
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                            "${blueStatus.getBlueProgressValueText.toString()}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        Text("/3",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors
                                                    .selectBackroundColor)),
                                      ],
                                    ),
                                    //進度條
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      child: FAProgressBar(
                                        size: 16,
                                        backgroundColor:
                                            Color.fromRGBO(100, 149, 153, 1),
                                        currentValue:
                                            blueStatus.getBlueProgressValue,
                                      ),
                                    ),
                                    dateState.getListData != null
                                        ? CardList()
                                        : Container(
                                            width: double.infinity,
                                            color: Colors.transparent,
                                            child: dateState.getListDataStatus
                                                ? progress()
                                                : Stack(
                                                    children: [
                                                      Text("No mission today.",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppColors
                                                                  .noMission)),
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                          Container(
                                                            height: 262.0,
                                                            width: 343.0,
                                                            // color: Colors.pink,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                  'assets/icon/no_mission.png',
                                                                ),
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
        Positioned(
            bottom: 100,
            right: 15,
            child: homeState.getBottomStatus
                ? homeState.getCurrentIndexStatus == 0
                    ? _floatButton()
                    : Container()
                : Container())
      ],
    );
  }

  Widget _floatButton() {
    var blueStatus = Provider.of<BluetoothStatus>(context);
    var dateStatus = Provider.of<DateStatus>(context);
    return Container(
      height: 55,
      width: 126,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        color: AppColors.floatingActionButton,
        // boxShadow: [
        //   BoxShadow(
        //     color: Color.fromRGBO(182, 182, 182, 0.95),
        //     offset: Offset(4, 4),
        //     blurRadius: 14,
        //   )
        // ],
      ),
      child: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            return Material(
              child: InkWell(
                onTap: () {
                  // Slidable.of(context).close();
                  if (state == BluetoothState.on) {
                    if (dateStatus.getPrintTitle != "") {
                      bluetooth.writeBtn(dateStatus.getPrintTitle);
                      // Provider.of<BluetoothStatus>(context, listen: false)
                      //     .writeBtn(dateStatus.getPrintTitle);
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    state == BluetoothState.on
                        ? BluetoothDeviceState.connected != null
                            ? dateStatus.getPrintTitle != ""
                                ? Image.asset("assets/icon/Print_icon.png")
                                : Image.asset("assets/icon/print_icon_off.png")
                            : Image.asset("assets/icon/print_icon_off.png")
                        : Image.asset("assets/icon/print_icon_off.png"),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Print",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 24,
                          color: state == BluetoothState.on
                              ? BluetoothDeviceState.connected != null
                                  ? dateStatus.getPrintTitle != ""
                                      ? Colors.white
                                      : Colors.white38
                                  : Colors.white38
                              : Colors.white38,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _appBar() {
    return BackdropAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(
          "LIFE MISSION",
          style: TextStyle(
              fontSize: 32,
              color: AppColors.homeAppbarTitle,
              fontWeight: FontWeight.bold),
        ),
      ),
      actions: <Widget>[
        Container(
          child: Row(children: [
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {
                Provider.of<SearchStatus>(context, listen: false)
                    .setBeforeListDataNull();
                Provider.of<SearchStatus>(context, listen: false)
                    .setBeforeListDataInit(false);

                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => SearchScreen(),
                // ));
                Navigator.of(context).push(createRoute(SearchScreen(
                  animationController: animationController,
                )));
              },
              iconSize: 30,
              color: AppColors.homeAppbarIcon,
            ),
            IconButton(
                icon: Image.asset(
                  'assets/icon/Setting.png',
                  width: 22,
                  height: 24,
                ),
                onPressed: () {
                  //頁面route
                  Provider.of<SettingStatus>(context, listen: false)
                      .setRoute(0);
                  //先撈取資料
                  Provider.of<SettingStatus>(context, listen: false)
                      .getListData();
                  //將儲存頁面保持初始
                  Provider.of<SettingStatus>(context, listen: false)
                      .setNotificationSaveStatus(0);
                  //資料存一份起來比對用
                  Provider.of<SettingStatus>(context, listen: false)
                      .getOldListData();
                  opensheet(context);
                }),
            SizedBox(
              width: 20,
            ),
          ]),
        ),
      ],
    );
  }

  Widget _rowListDatetime() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: DatePicker(
        // DateTime.now(),
        DateTime.now().subtract(new Duration(days: 50)),

        width: 40,
        height: 90,
        controller: _controller,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.black,
        selectedTextColor: Colors.white,
        inactiveDates: [],

        // locale: "zh-tw",
        onDateChange: (date) {
          // print(date.year + date.month + date.day);
          print(
              "Date===${DateTime.now().year + DateTime.now().month + DateTime.now().day}");
          //讓返回今天的時候 可以今天內容點擊色
          Provider.of<HomeStatus>(context, listen: false)
              .setRowBackStatus(false);

          String toDay =
              new DateFormat("MMM", "en_US").format(date).toUpperCase() +
                  ". " +
                  new DateFormat("d", "en_US").format(date).toUpperCase() +
                  ", " +
                  new DateFormat("y", "en_US").format(date).toUpperCase();
          //false保留傳進去的值
          Provider.of<DateStatus>(context, listen: false)
              .selectedRowDateEvent(toDay, false);
          //首頁內容's Mission 的日期
          toDay = new DateFormat("MMM", "en_US").format(date).toUpperCase() +
              ". " +
              new DateFormat("d", "en_US").format(date).toUpperCase() +
              "'s ";
          var dayNow = DateTime.now();
          //是今天的話顯示Ｔoday's
          if ((date.year + date.month + date.day) ==
              (dayNow.year + dayNow.month + dayNow.day))
            Provider.of<HomeStatus>(context, listen: false).setToDay("Today's");
          else
            Provider.of<HomeStatus>(context, listen: false).setToDay(toDay);

          setState(() {
            _selectedValue = date;
          });
        },
      ),
    );
  }

  void opensheet(BuildContext context) async {
    showModalBottomSheet(
        context: (context),
        enableDrag: true,
        // isDismissible: false,
        builder: (context) {
          return SettingRoute();
        });
  }

  Widget _listTitle(String text, double t, double b, double textSize) {
    return Padding(
      padding: EdgeInsets.only(top: t, bottom: b),
      child: Text(
        text,
        style: TextStyle(
            fontSize: textSize,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _subAppBar(homeState) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              "${homeState.getTitleYear}",
              style: TextStyle(
                  fontSize: 24,
                  color: AppColors.selectBackroundColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Image.asset('assets/icon/Backtotoday_icon.png'),
                  onPressed: () {
                    //按返回鍵 當天日期主動成選中項目
                    Provider.of<HomeStatus>(context, listen: false)
                        .setRowBackStatus(true);
                    //查詢今天的資料
                    String toDay = new DateFormat("MMM", "en_US")
                            .format(DateTime.now())
                            .toUpperCase() +
                        ". " +
                        new DateFormat("d", "en_US")
                            .format(DateTime.now())
                            .toUpperCase() +
                        ", " +
                        new DateFormat("y", "en_US")
                            .format(DateTime.now())
                            .toUpperCase();
                    //false 保留傳進去的值
                    Provider.of<DateStatus>(context, listen: false)
                        .selectedRowDateEvent(toDay, false);

                    //今天改成Today
                    Provider.of<HomeStatus>(context, listen: false)
                        .setToDay("Today's");

                    _controller.animateToDate(DateTime.now());
                    setState(() {
                      _selectedValue = DateTime.now();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
