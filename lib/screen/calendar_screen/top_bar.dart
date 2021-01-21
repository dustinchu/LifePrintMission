import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/state/calendar_status.dart';
import 'package:text_print_3d/state/calendar_tab_status.dart';
import 'package:text_print_3d/state/home_status.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var calendarTabStatus = Provider.of<CalendarTabStatus>(context);
    return Container(
        height: 50,
        width: double.infinity,
        color: AppColors.calendarTitleBackround,
        child: Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  //點擊的日期存起來
                  // Provider.of<CalendarStatus>(context, listen: false)
                  //     .setSelectDate(DateTime.now().add(Duration(days: 2)));

                  // print(calendarState.getSelectDate);
                  Provider.of<HomeStatus>(context, listen: false)
                      .setCurrentIndex(1);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.chevron_left,
                      size: 30,
                      color: Colors.white,
                    ),
                    Text(
                      calendarTabStatus.gatYearString,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment(-0.5, 0),
                child: Text(
                  "CALENDAR",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ));
  }
}
