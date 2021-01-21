import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/listview_sladable/widgets/slidable.dart';
import 'package:text_print_3d/state/date_status.dart';
import 'package:text_print_3d/state/home_status.dart';
import 'package:text_print_3d/state/layer_status.dart';
import 'package:text_print_3d/state/search_status.dart';

class SearchList extends StatelessWidget {
  final AnimationController animationController;
  const SearchList({@required this.animationController, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String day = "";
    bool listStatus = false;
    var dateState = Provider.of<SearchStatus>(context);

    
    return Expanded(
      child: Column(
        children: [
          // FlatButton(
          //   child: Text("123"),
          //   onPressed: () {
          //     Provider.of<SearchStatus>(context, listen: false)
          //         .getAllListData();
          //   },
          // ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dateState.getafterListData != null
                      ? Expanded(
                          child: ListView(
                              padding: EdgeInsets.all(0),
                              children: dateState.getafterListData.map((item) {
                                item.imageDate != day
                                    ? listStatus = true
                                    : listStatus = false;
                                day = item.imageDate;
                                //不＝null代表是有標題
                                return item.title != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                            item.title ? "Coming" : "Past",
                                            style: TextStyle(
                                                color:
                                                    AppColors.searchListTitle,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    :
                                    // listStatus?
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _listTitleDate(item),
                                          _listContainer(
                                              item, item.listViewStatus)
                                        ],
                                      );
                                // : _listContainer(
                                //     item, item.listViewStatus);
                              }).toList()),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          //   dateState.getbeforListData != null
          //       ? Expanded(
          //           child: Container(
          //             padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text("Past",
          //                     style: TextStyle(
          //                         color: AppColors.searchListTitle,
          //                         fontSize: 24.0,
          //                         fontWeight: FontWeight.bold)),
          //                 Expanded(
          //                   child: ListView(
          //                       padding: EdgeInsets.all(0),
          //                       children: dateState.getbeforListData.map((item) {
          //                         item.imageDate != day
          //                             ? listStatus = true
          //                             : listStatus = false;
          //                         day = item.imageDate;
          //                         return listStatus
          //                             ? Column(
          //                                 crossAxisAlignment:
          //                                     CrossAxisAlignment.start,
          //                                 children: [
          //                                   _listTitleDate(item),
          //                                   _listContainer(item, false)
          //                                 ],
          //                               )
          //                             : _listContainer(item, false);
          //                       }).toList()),
          //                 )
          //               ],
          //             ),
          //           ),
          //         )
          //       : Container(
          //           // padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          //           // child: Column(
          //           //     crossAxisAlignment: CrossAxisAlignment.start,
          //           //     children: [
          //           //       Text("Past",
          //           //           style: TextStyle(
          //           //               color: AppColors.searchListTitle,
          //           //               fontSize: 24.0,
          //           //               fontWeight: FontWeight.bold)),
          //           //     ],)
          //           // child: Center(
          //           //   child: Text("NULL"),
          //           // ),
          //           ),
          //   SizedBox(
          //     height: 60,
          //   )
        ],
      ),
    );
  }

  Widget _listTitleDate(item) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10),
      child: Text(item.imageDate,
          style: TextStyle(
              color: AppColors.selectBackroundColor,
              fontSize: 16.0,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _listContainer(item, bool colorStatus) {
    return Builder(
      
      builder: (context) => InkWell(
        onTap: () {
          print(
              "id====${item.id}  datetime===${item.insertDatetime}  imgStatus ===${item.imageStatus}  title===${item.listTitle}   listBody===${item.listBody}");
          //標題
          Provider.of<LayerStatus>(context, listen: false)
              .setTitle(item.listTitle);
          //內容
          Provider.of<LayerStatus>(context, listen: false)
              .setBody(item.listBody);

          Provider.of<DateStatus>(context, listen: false).setListEdit(
              DateTime.fromMicrosecondsSinceEpoch(item.insertDatetime),
              item.listTitle,
              item.listBody,
              item.id,
              item.imageDate);
          //圖片選擇
          Provider.of<LayerStatus>(context, listen: false)
              .layerStatusImageClick(item.imageStatus);
          //上一部沒關掉日曆的話 沒關閉會打開 先關閉
          Provider.of<LayerStatus>(context, listen: false)
              .layerStatusClick("close");
          // Provider.of<DateStatus>(context, listen: false).setCal
          //             dateState.getCalendarSelectDate
          Navigator.of(context).pop();
          //bottom底部關閉
          Provider.of<HomeStatus>(context, listen: false).homeScafoldClick();
          animationController.animateTo(1.0);
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            alignment: Alignment(-1, 0),
            padding: EdgeInsets.only(left: 5),
            width: double.infinity,
            height: 30,
            decoration: new BoxDecoration(
              //判斷顏色 or 深色淺色 true =深色 false ＝淺色
              color: item.imageStatus == 0
                  ? colorStatus
                      ? AppColors.searchComingContainerGreen
                      : AppColors.searchPastContainerGreen
                  : item.imageStatus == 1
                      ? colorStatus
                          ? AppColors.searchComingContainerYello
                          : AppColors.searchPastContainerYello
                      : colorStatus
                          ? AppColors.searchComingContainerRed
                          : AppColors.searchPastContainerRed,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Text(item.listTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
