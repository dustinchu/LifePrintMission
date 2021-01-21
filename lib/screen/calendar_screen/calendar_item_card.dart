import 'package:backdrop/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/listview_sladable/flutter_slidable.dart';
import 'package:text_print_3d/common/listview_sladable/widgets/slidable.dart';
import 'package:text_print_3d/common/today.dart';
import 'package:text_print_3d/state/calendar_status.dart';
import 'package:text_print_3d/state/date_status.dart';
import 'package:text_print_3d/state/layer_status.dart';
import 'package:text_print_3d/state/list_slidable.dart';
import 'package:text_print_3d/util/layer_edit_state.dart';

class CalendarItemCard extends StatefulWidget {
  CalendarItemCard({Key key}) : super(key: key);

  @override
  _CalendarItemCardState createState() => _CalendarItemCardState();
}

class _CalendarItemCardState extends State<CalendarItemCard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    //前後台切換監聽
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive:
        print("aaaainactive"); // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed:
        Provider.of<ListSlidableStatus>(context, listen: false)
            .setOpen(); // 应用程序可见，前台
        print("raaaaesumed");
        break;
      case AppLifecycleState.paused:
        Provider.of<ListSlidableStatus>(context, listen: false)
            .setClose(); // 应用程序不可见，后台
        print("paaaaused");
        break;
      // case AppLifecycleState.suspending: // 申请将暂时暂停
      //   break;
    }
  }

  @override
  void dispose() {
    //前後台監聽關閉
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dateState = Provider.of<CalendarStatus>(context);
    var slidableReState = Provider.of<ListSlidableStatus>(context);
    return slidableReState.getIsOpenStatus
        ? Expanded(
            child: Theme(
              data: ThemeData(canvasColor: Colors.transparent),
              child: dateState.getListData != null
                  ? ListView(
                      children: dateState.getListData.map((item) {
                        return Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          key: Key(item.id.toString()),
                          height: 98,
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Slidable(
                            actionPane: SlidableStrechActionPane(),
                            key: ValueKey(item.id.toString()),
                            dismissal: SlidableDismissal(
                              child: SlidableDrawerDismissal(),
                            ),
                            secondaryActions: <Widget>[
                              Row(
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: Container(
                                        width: 20,
                                      )),
                                  Flexible(
                                    flex: 3,
                                    child: IconSlideAction(
                                      child: Container(
                                        width: 78,
                                        height: 90,
                                        decoration: new BoxDecoration(
                                          color: AppColors.selectBackroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<DateStatus>(context,
                                                    listen: false)
                                                .listDataDeleteEvent(item.id);
                                            // 刪除後再找一次
                                            Provider.of<CalendarStatus>(context,
                                                    listen: false)
                                                .getAllListData();

                                            //日曆mark
                                            Provider.of<CalendarStatus>(context,
                                                    listen: false)
                                                .getAllMark();
                                          },
                                          child: Center(
                                            child: Text(
                                              "Delete",
                                              overflow: TextOverflow
                                                  .ellipsis, // 文字显示不全样式
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            // endActionPane: ActionPane(
                            //   extentRatio: 0.27,
                            //   openThreshold:
                            //       0.1, // A 10% sliding, will open the slidable
                            //   closeThreshold: 0.1, // A 10% sli
                            //   motion: ScrollMotion(),
                            //   children: [
                            //     SizedBox(
                            //       width: 20,
                            //     ),

                            //   ],
                            // ),

                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(14.0))), //设置圆角
                              child: Center(
                                child: ListTile(
                                  onTap: () {
                                    //傳修改資料
                                    Provider.of<DateStatus>(context,
                                            listen: false)
                                        .setListEdit(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                item.insertDatetime),
                                            item.listTitle,
                                            item.listBody,
                                            item.id,
                                            item.imageDate);
                                    //圖片焦點
                                    Provider.of<LayerStatus>(context,
                                            listen: false)
                                        .layerStatusImageClick(
                                            item.imageStatus);

                                    //上一部沒關掉日曆的話 沒關閉會打開 先關閉
                                    Provider.of<LayerStatus>(context,
                                            listen: false)
                                        .layerStatusClick("close");

                                    //打開編輯頁面edit是否要讀取provider資料
                                    var editState = LayerEditState.instance;
                                    editState.state = true;
                                    //打開
                                    Backdrop.of(context).fling();
                                  },
                                  contentPadding:
                                      EdgeInsets.only(left: 0, right: 15),
                                  title: Text(
                                    "${item.imageDate}",
                                    style: TextStyle(
                                        fontSize: 24,
                                        //先判斷圖示顏色 在判斷是否過去資料 50%色度
                                        color: item.imageStatus == 0
                                            ? item.insertDatetime >= toDayInt()
                                                ? AppColors
                                                    .calendarListTitleGreen
                                                : AppColors
                                                    .searchPastContainerGreen
                                            : item.imageStatus == 1
                                                ? item.insertDatetime >=
                                                        toDayInt()
                                                    ? AppColors
                                                        .calendarListTitleYello
                                                    : AppColors
                                                        .searchPastContainerYello
                                                : item.insertDatetime >=
                                                        toDayInt()
                                                    ? AppColors
                                                        .calendarListTitleRed
                                                    : AppColors
                                                        .searchPastContainerRed,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "${item.listTitle}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: item.insertDatetime >= toDayInt()
                                            ? AppColors.selectBackroundColor
                                            : AppColors.pastColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: SizedBox(
                                    width: 74,
                                    height: 74,
                                    child: Center(
                                        child: item.imageStatus == 0
                                            ? Image.asset(
                                                'assets/icon/List_green_icon.png')
                                            : item.imageStatus == 1
                                                ? Image.asset(
                                                    'assets/icon/List_yello_icon.png')
                                                : Image.asset(
                                                    'assets/icon/List_red_icon.png')),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Container(
                      height: 98,
                      width: double.infinity,
                      color: Colors.transparent,
                    ),
            ),
          )
        : Container();
  }
}
