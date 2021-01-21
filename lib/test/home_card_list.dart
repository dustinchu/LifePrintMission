// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:text_print_3d/common/extra/color.dart';
// import 'package:text_print_3d/screen/home_screen/listview_slidable/flutter_slidable.dart';
// import 'package:text_print_3d/screen/home_screen/listview_slidable/slidable.dart';
// import 'package:text_print_3d/state/date_status.dart';


// class SettingCard extends StatelessWidget {
//   // List<ListDataModel> _list;
//   SettingCard({Key key}) : super(key: key);
//   // LoginScreen({Key key, @required UserRepository userRepository})
//   //     : assert(userRepository != null),
//   //       _userRepository = userRepository,
//   //       super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var dateState = Provider.of<DateStatus>(context);
//     return Expanded(
//       child: Theme(
//         data: ThemeData(canvasColor: Colors.transparent),
//         child: dateState.getListData != null
//             ? ReorderableListView(
//                 children: dateState.getListData.map((item) {
//                   return Container(
//                     key: Key(item.id.toString()),
//                     height: 98,
//                     width: double.infinity,
//                     color: Colors.transparent,
//                     child: Slidable(
//                       key: ValueKey(item.id.toString()),
//                       endActionPane: ActionPane(
//                         extentRatio: 0.27,
//                         openThreshold:
//                             0.1, // A 10% sliding, will open the slidable
//                         closeThreshold: 0.1, // A 10% sli
//                         motion: ScrollMotion(),
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Container(
//                             width: 78,
//                             height: 90,
//                             child: Column(
//                               children: [
//                                 Container(
//                                   height: 38,
//                                   decoration: new BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(10.0),
//                                         topRight: Radius.circular(10.0)),
//                                   ),
//                                   width: double.infinity,
//                                   child: InkWell(
//                                     onTap: () {
//                                       Provider.of<DateStatus>(context,
//                                               listen: false)
//                                           .listDataDeleteEvent(item.id);
//                                       print(item.id.toString());
//                                     },
//                                     child: Center(
//                                       child: Text(
//                                         "Delete",
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: AppColors.selectBackroundColor,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: Container(
//                                     decoration: new BoxDecoration(
//                                       color: AppColors.selectBackroundColor,
//                                       borderRadius: BorderRadius.only(
//                                           bottomLeft: Radius.circular(10.0),
//                                           bottomRight: Radius.circular(10.0)),
//                                     ),
//                                     width: double.infinity,
//                                     child: Center(
//                                       child: Text(" Move to \ntomorrow",
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.white)),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       child: Card(
//                         shape: const RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(14.0))), //设置圆角
//                         child: Center(
//                           child: ListTile(
//                             contentPadding: EdgeInsets.only(left: 0, right: 15),
//                             title: Text(
//                               "${item.listTitle}",
//                               style: TextStyle(
//                                   fontSize: 20,
//                                   color: AppColors.selectBackroundColor,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             subtitle: Text(
//                               "${item.listBody}",
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   color: AppColors.listSubText,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             leading: SizedBox(
//                               width: 74,
//                               height: 74,
//                               child: Center(
//                                   child: item.imageStatus == 0
//                                       ? Image.asset(
//                                           'assets/icon/List_green_icon.png')
//                                       : item.imageStatus == 1
//                                           ? Image.asset(
//                                               'assets/icon/List_yello_icon.png')
//                                           : Image.asset(
//                                               'assets/icon/List_red_icon.png')),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 onReorder: (int oldIndex, int newIndex) {
//                   // setState(() {
//                   //   //交换数据
//                   //   if (newIndex > oldIndex) {
//                   //     newIndex -= 1;
//                   //   }
//                   //   final int item = list.removeAt(oldIndex);
//                   //   list.insert(newIndex, item);
//                   // });
//                 },
//               )
//             : Container(
//                 height: 98,
//                 width: double.infinity,
//                 color: Colors.transparent,
//               ),
//       ),
//     );
//   }
// }
