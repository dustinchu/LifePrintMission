import 'package:backdrop/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/state/calendar_status.dart';
import 'package:text_print_3d/state/calendar_tab_status.dart';
import 'package:text_print_3d/state/date_status.dart';
import 'package:text_print_3d/state/home_status.dart';
import 'package:text_print_3d/state/layer_status.dart';
import 'package:text_print_3d/util/layer_edit_state.dart';

class BottomBar extends StatelessWidget {
  BottomBar({Key key, @required this.homeState}) : super(key: key);
  var homeState;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: BottomNavigationBar(
          elevation: 0,
          // backgroundColor: Colors.white,
          showSelectedLabels: false, // <-- HERE
          showUnselectedLabels: false,
          onTap: (index) {
            click(index, context);
          }, // new
          currentIndex: homeState.getCurrentIndexStatus, // new
          items: [
            new BottomNavigationBarItem(
                icon: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new SizedBox(
                      height: 10,
                    ),
                    new SizedBox(
                      child: new IconButton(
                          icon: homeState.getCurrentIndexStatus == 0
                              ? Image.asset('assets/icon/Home_on.png')
                              : Image.asset('assets/icon/Home_off.png'),
                          onPressed: () {
                            click(0, context);
                          }),
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                title: new Text(
                  "",
                  style: new TextStyle(fontSize: 0),
                )),
            new BottomNavigationBarItem(
                icon: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new SizedBox(
                      child: new IconButton(
                          icon: Image.asset('assets/icon/Add_button.png'),
                          onPressed: () {
                            click(1, context);
                          }),
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
                title: new Text(
                  "",
                  style: new TextStyle(fontSize: 0),
                )),
            new BottomNavigationBarItem(
                icon: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    new SizedBox(
                      height: 10,
                    ),
                    new SizedBox(
                      child: new IconButton(
                          icon: homeState.getCurrentIndexStatus == 2 ||
                                  homeState.getCurrentIndexStatus == 1
                              ? Image.asset('assets/icon/Calender_on.png')
                              : Image.asset('assets/icon/Calender_off.png'),
                          onPressed: () {
                            click(2, context);
                          }),
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
                title: new Text(
                  "",
                  style: new TextStyle(fontSize: 0),
                )),
          ],
        ),
      ),
    );
  }

  void click(index, context) {
    if (index == 0)
      //bottom icon
      Provider.of<HomeStatus>(context, listen: false).setCurrentIndex(0);
    if (index == 1) {
      Backdrop.of(context).fling();

      //寫入選擇日期 紀錄 讓按鈕不能點 使用
      Provider.of<LayerStatus>(context, listen: false).setTomorrow("tomorrow");
      //編輯頁面資料初始化
      Provider.of<DateStatus>(context, listen: false).initListEdit();
      //關閉日曆
      Provider.of<LayerStatus>(context, listen: false)
          .layerStatusClick("textField");
      //打開編輯頁面edit是否要讀取provider資料
      var editState = LayerEditState.instance;
      editState.state = false;
    }

    //圖片選擇
    Provider.of<LayerStatus>(context, listen: false).layerStatusImageClick(4);
    // if (index == 2) Navigator.pushNamed(context, '/calendar');
    if (index == 2) {
      //預設月曆時間
      // Provider.of<CalendarStatus>(context, listen: false)
      //     .setInitialSelectDay(DateTime.now());
      Provider.of<CalendarStatus>(context, listen: false)
          .setSelectDate(DateTime.now());
      // setSelectDate
      //日曆mark
      Provider.of<CalendarStatus>(context, listen: false).getAllMark();
      //切換頁面得到list
      Provider.of<CalendarStatus>(context, listen: false).getAllListData();

      //tab title 年份
      Provider.of<CalendarTabStatus>(context, listen: false)
          .setYear(DateTime.now().year.toString());

      Future.delayed(const Duration(milliseconds: 100), () {
        Provider.of<HomeStatus>(context, listen: false).setCurrentIndex(2);
      });
      //bottom icon

      // Navigator.of(context).push(createRoute(CalendarScreen()));
    }
  }
}
