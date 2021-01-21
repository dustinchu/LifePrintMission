import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/today.dart';
import 'package:text_print_3d/state/calendar_status.dart';
import 'package:text_print_3d/state/calendar_tab_status.dart';
import 'package:text_print_3d/state/home_status.dart';

import 'scrolling_calendar/scrolling_years_calendar.dart';

class ScrollingScreen extends StatelessWidget {
  const ScrollingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ScrollingYearsCalendar(
          // Required parameters
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 1 * 365)),
          lastDate: DateTime.now(),
          currentDateColor: Color.fromRGBO(100, 149, 153, 1),
          monthNames: const <String>[
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec',
          ],
          onMonthTap: (int year, int month) {

            Provider.of<CalendarStatus>(context, listen: false).setSelectDate(DateTime.now());
            //日曆頁 標題年份
            Provider.of<CalendarTabStatus>(context, listen: false)
                .setYear(year.toString());
            //月曆頁預設日期
            Provider.of<CalendarStatus>(context, listen: false)
                .setInitialSelectDay(DateTime(year, month, 1));
            //月曆頁月份的資料
            Provider.of<CalendarStatus>(context, listen: false)
                .getIntervalData(getDateTimeInt(DateTime(year,month,1)), getDateTimeInt(DateTime(year,month+1,1)));
            //頁面切換
            Provider.of<HomeStatus>(context, listen: false).setCurrentIndex(2);
            print('Tapped $month/$year');
          },
          monthTitleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(100, 149, 153, 1),
          ),
        ),
      ),
    );
  }
}
