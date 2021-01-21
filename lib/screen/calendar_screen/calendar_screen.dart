import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/widget/circularProgress.dart';
import 'package:text_print_3d/screen/calendar_screen/top_bar.dart';
import 'package:text_print_3d/state/calendar_status.dart';

import 'calendar.dart';
import 'calendar_item_card.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({Key key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var calendarState = Provider.of<CalendarStatus>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(),
              Calendar(),
              !calendarState.getloddingStatus
                  ? _body(calendarState)
                  :Container()
                  // : Center(child: progress())
            ],
          ),
        ));
  }

  Widget _body(calendarState) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
          color: AppColors.calendarTitleBackround,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Mission",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            CalendarItemCard(),
          ],
        ),
      ),
    );
  }

  // Widget _titlebar() {

  //   return Container(
  //       height: 50,
  //       width: double.infinity,
  //       color: AppColors.calendarTitleBackround,
  //       child: Row(
  //         children: [
  //           InkWell(
  //             child: Row(
  //               children: [
  //                 SizedBox(
  //                   width: 10,
  //                 ),
  //                 Icon(
  //                   Icons.chevron_left,
  //                   size: 30,
  //                   color: Colors.white,
  //                 ),
  //                 Text(
  //                   "2020",
  //                   style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 24.0,
  //                       fontWeight: FontWeight.bold),
  //                 )
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: Container(
  //               alignment: Alignment(-0.5, 0),
  //               child: Text(
  //                 "CALENDAR",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 16.0,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           )
  //         ],
  //       ));
  // }
}
