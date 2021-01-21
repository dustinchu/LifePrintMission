import 'package:backdrop/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/listview_sladable/flutter_slidable.dart';
import 'package:text_print_3d/common/listview_sladable/widgets/slidable.dart';
import 'package:text_print_3d/common/listview_sladable/widgets/slidable_action_pane.dart';
import 'package:text_print_3d/model/list_data.dart';
import 'package:text_print_3d/state/date_status.dart';
import 'package:text_print_3d/state/layer_status.dart';
import 'package:text_print_3d/state/list_slidable.dart';
import 'package:text_print_3d/util/layer_edit_state.dart';

import 'reorderable_list.dart';

class CardList extends StatefulWidget {
  CardList({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;
  List<ListDataModel> listData;

  @override
  _CardListState createState() => _CardListState();
}

enum DraggingMode {
  iOS,
  Android,
}

class _CardListState extends State<CardList> with WidgetsBindingObserver {
  int draggingIndex;
  int newPositionIndex;
  // Returns index of item with given key

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

  int _indexOfKey(Key key) {
    return widget.listData.indexWhere((ListDataModel d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    draggingIndex = _indexOfKey(item);
    newPositionIndex = _indexOfKey(newPosition);

    final draggedItem = widget.listData[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPositionIndex");
      widget.listData.removeAt(draggingIndex);
      widget.listData.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = widget.listData[_indexOfKey(item)];
    Provider.of<DateStatus>(context, listen: false).updateMoveListIndex(
        widget.listData[draggingIndex].id,
        draggingIndex + 1,
        widget.listData[newPositionIndex].id,
        newPositionIndex + 1);
    debugPrint(
        "Rddeordering date ==${widget.listData[_indexOfKey(item)].imageDate}  oldid ==${widget.listData[draggingIndex].id} old ==$draggingIndex -> newID == oldid ==${widget.listData[newPositionIndex].id}  newi==$newPositionIndex");
    debugPrint("Reordering finished for ${draggedItem.imageDate}}");
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.Android;

  Widget build(BuildContext context) {
    var dateState = Provider.of<DateStatus>(context);
    var slidableReState = Provider.of<ListSlidableStatus>(context);
    widget.listData = dateState.getListData;
    //縮小刷新 讓拉開的listview重新渲染一次
    return slidableReState.getIsOpenStatus
        ? Expanded(
            child: widget.listData != null
                ? ReorderableList(
                    onReorder: this._reorderCallback,
                    onReorderDone: this._reorderDone,
                    child: CustomScrollView(
                      // cacheExtent: 3000,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Item(
                                  data: widget.listData[index],
                                  // first and last attributes affect border drawn during dragging
                                  isFirst: index == 0,
                                  isLast: index == widget.listData.length - 1,
                                  draggingMode: _draggingMode,
                                );
                              },
                              childCount: widget.listData.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          )
        : Container();
  }
}

class Item extends StatelessWidget {
  Item({
    this.data,
    this.isFirst,
    this.isLast,
    this.draggingMode,
  });

  final ListDataModel data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      decoration = BoxDecoration(color: Colors.transparent);
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration =
          BoxDecoration(color: placeholder ? null : Colors.transparent);
    }

    Widget content = Builder(
      builder: (context) => InkWell(
        onTap: () {
          print(
              "id====${data.id}  datetime===${data.insertDatetime}  imgStatus ===${data.imageStatus}  title===${data.listTitle}   listBody===${data.listBody}");
          Provider.of<DateStatus>(context, listen: false).setListEdit(
              DateTime.fromMicrosecondsSinceEpoch(data.insertDatetime),
              data.listTitle,
              data.listBody,
              data.id,
              data.imageDate);
          //圖片選擇
          Provider.of<LayerStatus>(context, listen: false)
              .layerStatusImageClick(data.imageStatus);
          //上一部沒關掉日曆的話 沒關閉會打開 先關閉
          Provider.of<LayerStatus>(context, listen: false)
              .layerStatusClick("close");
          Backdrop.of(context).fling();
          //打開編輯頁面edit是否要讀取provider資料
          var editState = LayerEditState.instance;
          editState.state = true;
        },
        child: Container(
          decoration: decoration,
          key: Key(data.id.toString()),
          height: 98,
          width: double.infinity,
          // color: Colors.transparent,
          child: Opacity(
            // hide content for placeholder
            //隱藏移動的時候 背景
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: Slidable(
              actionPane: SlidableStrechActionPane(),
              key: ValueKey(data.id.toString()),
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
              ),
              secondaryActions: <Widget>[
                // IconSlideAction(
                //     child: SizedBox(
                //       width: 10,
                //         child: Container(
                //   color: Colors.pink,
                // ))),
                IconSlideAction(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          flex: 1,
                          child: Container(
                            width: 20,
                          )),
                      Flexible(
                        flex: 3,
                        child: Container(
                          width: 78,
                          height: 90,
                          child: Column(
                            children: [
                              Container(
                                height: 38,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0)),
                                ),
                                width: double.infinity,
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<DateStatus>(context,
                                            listen: false)
                                        .listDataDeleteEvent(data.id);
                                    print(data.id.toString());
                                  },
                                  child: Center(
                                    child: Text(
                                      "Delete",
                                      overflow:
                                          TextOverflow.ellipsis, // 文字显示不全样式
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.selectBackroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: AppColors.selectBackroundColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0)),
                                  ),
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(" Move to \ntomorrow",
                                        overflow:
                                            TextOverflow.ellipsis, // 文字显示不全样式
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // endActionPane: ActionPane(
              //   extentRatio: 0.27,
              //   openThreshold: 0.1, // A 10% sliding, will open the slidable
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
                    borderRadius:
                        BorderRadius.all(Radius.circular(14.0))), //设置圆角
                child: Center(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 0, right: 15),
                    title: Text(
                      "${data.listTitle}",
                      style: TextStyle(
                          fontSize: 20,
                          color: AppColors.selectBackroundColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${data.listBody}",
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.listSubText,
                          fontWeight: FontWeight.bold),
                    ),
                    leading: SizedBox(
                      width: 74,
                      height: 74,
                      child: Center(
                          child: data.imageStatus == 0
                              ? Image.asset('assets/icon/List_green_icon.png')
                              : data.imageStatus == 1
                                  ? Image.asset(
                                      'assets/icon/List_yello_icon.png')
                                  : Image.asset(
                                      'assets/icon/List_red_icon.png')),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}
