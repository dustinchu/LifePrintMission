import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/toastInfo.dart';
import 'package:text_print_3d/common/today.dart';
import 'package:text_print_3d/screen/home_front_layer/home_front_layer_textfield.dart';
import 'package:text_print_3d/state/calendar_status.dart';
import 'package:text_print_3d/state/date_status.dart';
import 'package:text_print_3d/state/home_status.dart';
import 'package:text_print_3d/state/layer_status.dart';
import 'package:text_print_3d/util/layer_edit_state.dart';

import 'home_layer_calendar.dart';
import 'home_layer_image.dart';

class HomeFontLayerScreen extends StatefulWidget {
  HomeFontLayerScreen({Key key}) : super(key: key);

  @override
  _HomeFontLayerScreenState createState() => _HomeFontLayerScreenState();
}

class _HomeFontLayerScreenState extends State<HomeFontLayerScreen> {
  TextEditingController titleTextEditingController;
  TextEditingController bodyTextEditingController;

  @override
  void initState() {
    titleTextEditingController = TextEditingController();
    bodyTextEditingController = TextEditingController();

    super.initState();
  }

  void onChangeTitle(text) {
    Provider.of<LayerStatus>(context, listen: false).setTitle(text);
    print("title$text");
  }

  void onChangeBody(text) {
    Provider.of<LayerStatus>(context, listen: false).setBody(text);
    print("body$text");
  }

  void image0Click() =>
      Provider.of<LayerStatus>(context, listen: false).layerStatusImageClick(0);
  void image1Click() =>
      Provider.of<LayerStatus>(context, listen: false).layerStatusImageClick(1);
  void image2Click() =>
      Provider.of<LayerStatus>(context, listen: false).layerStatusImageClick(2);

  @override
  Widget build(BuildContext context) {
    var layerState = Provider.of<LayerStatus>(context);
    var dateState = Provider.of<DateStatus>(context);

    var editState = LayerEditState.instance;

    // print("DATEController${ dateState.getTextTitle}");
    if (editState.state) {
      print("Edit${dateState.getListDataID}");
      titleTextEditingController.text = dateState.getTextTitle;
      bodyTextEditingController.text = dateState.getTextBody;
      editState.state = false;
    }

    // return Container(
    //     width: double.infinity,
    //     height: double.infinity,
    //     color: AppColors.frontLayerBackroundColor,
    //     child: Column(
    //       children: [
    //         SizedBox(
    //           height: 10,
    //         ),
    //         _title(),
    //         Stack(
    //           alignment: AlignmentDirectional.center, children: <Widget>[

    //         ])
    //       ],
    //     ));
    return SimpleGestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        print("Move Tap");
      },
      onVerticalSwipe: (SwipeDirection swipeDirection) {
        if (swipeDirection == SwipeDirection.down) {
          Provider.of<DateStatus>(context, listen: false).setListDataID(0);
          titleTextEditingController.text = "";
          bodyTextEditingController.text = "";
          print("Move down");
          Backdrop.of(context).fling();
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.frontLayerBackroundColor,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                _title(),
                _statusSelect(layerState),
                HomeFrontLayerTextField(
                  textEditingController: titleTextEditingController,
                  hintText: "Titled",
                  maxLines: 1,
                  maxLength: 25,
                  supFontSize: 24,
                  hintFontSize: 24,
                  focusStatus: true,
                  onChangeText: onChangeTitle,
                ),
                HomeFrontLayerTextField(
                  textEditingController: bodyTextEditingController,
                  hintText: "Tap here to write…",
                  maxLines: 2,
                  maxLength: 100,
                  supFontSize: 20,
                  hintFontSize: 20,
                  focusStatus: false,
                  onChangeText: onChangeBody,
                ),
                SizedBox(
                  height: 20,
                ),
                // Comfrim_icon
              ],
            ),

            layerState.getBottomBStatus
                ? Positioned(
                    bottom: 0,
                    child: HomeLayerCalendar(),
                  )
                : Container(),
            _comfirm(dateState),
            // Container()
          ],
        ),
      ),
    );
  }

  Widget _comfirm(dateState) {
    var layerState = Provider.of<LayerStatus>(context);
    return Builder(
      builder: (context) => Positioned(
        // bottom: 30,
        bottom: layerState.getBottomBStatus ? 360 : 30,
        child: new Material(
          color: Colors.transparent,
          //INK可以实现装饰容器
          child: new Ink(
            //用ink圆角矩形
            // color: Colors.red,
            decoration: new BoxDecoration(
              //不能同时”使用Ink的变量color属性以及decoration属性，两个只能存在一个
              color: layerState.getBody == "" ||
                      layerState.getTitle == "" ||
                      layerState.getClickIndex == 4 ||
                      dateState.getCalendarSelectDate == "tomorrow"
                  ? AppColors.defaultBackroundColor
                  : AppColors.selectBackroundColor,
              //设置圆角
              borderRadius: new BorderRadius.all(new Radius.circular(25.0)),
            ),
            child: new InkWell(
              borderRadius: new BorderRadius.circular(25.0),
              //设置点击事件回调
              onTap: () {
                print("刪除ＩＤ＝＝${dateState.getListDataID}");
                print(
                    "Title ${layerState.getTitle} body${layerState.getBody} index ${layerState.getClickIndex} tomorrow =${dateState.getCalendarSelectDate}");
                if (layerState.getBody == "" ||
                    layerState.getTitle == "" ||
                    layerState.getClickIndex == 4 ||
                    dateState.getCalendarSelectDate == "tomorrow") {
                      
                } else {
                  print("刪除ＩＤ＝＝1111    ${dateState.getListDataID}");
                  // // print("id===${dateState.getListDataID}");
                  Provider.of<CalendarStatus>(context, listen: false)
                      .setClickSave();

                  //新增
                  Provider.of<DateStatus>(context, listen: false).setAddData(
                      titleTextEditingController.text.toString(),
                      bodyTextEditingController.text.toString(),
                      layerState.getClickIndex,
                      context);
                  print("刪除ＩＤ＝＝${dateState.getListDataID}");
                  //！0代表是編輯的資料 是編輯的資料要刪除
                  if (dateState.getListDataID != 0) {
                    Provider.of<DateStatus>(context, listen: false)
                        .deleteId(dateState.getListDataID);
                  }
                  //讀取首頁上次點擊的日期查詢
                  Provider.of<DateStatus>(context, listen: false)
                      .selectedRowDateEvent("", true);

                  //切換頁面得到list
                  Provider.of<CalendarStatus>(context, listen: false)
                      .getAllListData();

                  Future.delayed(const Duration(milliseconds: 100), () {
                    //日曆mark
                    Provider.of<CalendarStatus>(context, listen: false)
                        .getAllMark();
                  });

                  Provider.of<HomeStatus>(context, listen: false)
                      .setCurrentIndex(2);

                  //新增修改完資料把id改0
                  Provider.of<DateStatus>(context, listen: false)
                      .setListDataID(0);
                  //bottom icon

                  // Provider.of<CalendarStatus>(context, listen: false)
                  //             .setSelectDate();
                  //清空輸入框內容
                  titleTextEditingController.text = "";
                  bodyTextEditingController.text = "";
                }
              },
              child: new Container(
                height: 50,
                width: 188,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    layerState.getBody == "" ||
                            layerState.getTitle == "" ||
                            layerState.getClickIndex == 4 ||
                            dateState.getCalendarSelectDate == "tomorrow"
                        ? Image.asset('assets/icon/Comfrim_icon_off.png')
                        : Image.asset('assets/icon/Comfrim_icon.png'),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Confirm",
                        style: TextStyle(
                            // Colors.white54
                            color: layerState.getBody == "" ||
                                    layerState.getTitle == "" ||
                                    layerState.getClickIndex == 4 ||
                                    dateState.getCalendarSelectDate ==
                                        "tomorrow"
                                ? Color.fromRGBO(255, 255, 255, 0.3)
                                : Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusSelect(imageState) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        color: Colors.white,
        height: 106,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeLayerImage(
                backround: imageState.getClickIndex == 0,
                onTap: image0Click,
                imgPath: 'assets/icon/List_green_icon.png',
                text: "1 sec"),
            SizedBox(
              width: 25,
            ),
            HomeLayerImage(
                backround: imageState.getClickIndex == 1,
                onTap: image1Click,
                imgPath: 'assets/icon/List_yello_icon.png',
                text: "2 sec"),
            SizedBox(
              width: 25,
            ),
            HomeLayerImage(
                backround: imageState.getClickIndex == 2,
                onTap: image2Click,
                imgPath: 'assets/icon/List_red_icon.png',
                text: "3 sec"),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    var dateState = Provider.of<DateStatus>(context);
    return Row(
      children: [
        Builder(
          builder: (context) => IconButton(
            icon: Image.asset('assets/icon/Close_icon.png'),
            onPressed: () {
              Provider.of<DateStatus>(context, listen: false).setListDataID(0);
              titleTextEditingController.text = "";
              bodyTextEditingController.text = "";
              Backdrop.of(context).fling();
            },
          ),
        ),
        Expanded(
          child: Container(),
        ),
        //
        InkWell(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              color: Colors.white,
            ),
            child: Text(
              dateState.getCalendarSelectDate == ""
                  ? "Tomorrow"
                  : dateState.getCalendarSelectDate,
              style: TextStyle(
                  fontSize: 20,
                  color: AppColors.selectBackroundColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Future.delayed(const Duration(milliseconds: 200), () {
              Provider.of<LayerStatus>(context, listen: false)
                  .layerStatusClick("event");
            });
          },
        ),

        SizedBox(
          width: 50,
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}
