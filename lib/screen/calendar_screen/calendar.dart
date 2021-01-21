//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/calendar/table_calendar.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/extra/style.dart';
import 'package:text_print_3d/state/calendar_status.dart';
import 'package:text_print_3d/state/calendar_tab_status.dart';

// DateFormat dataFormat = DateFormat("yyyy-MM-dd");
// String bb = dataFormat.format(DateTime.now()).toUpperCase();
// DateTime dateTime = dataFormat.parse(bb);
// Example holidays
// final Map<DateTime, List> _holidays = {
//   DateTime(2020, 12, 25): ['New Year\'s Day'],
//   DateTime(2020, 12, 25): ['Epiphany'],
//   DateTime(2020, 12, 24): ['Valentine\'s Day'],
//   DateTime(2020, 12, 23): ['Easter Sunday'],
//   DateTime(2020, 4, 22): ['Easter Monday'],
// };
var _holidays = <DateTime, List>{};

class Calendar extends StatefulWidget {
  Calendar({Key key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _selectedEvents = [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

    // var calendarState = Provider.of<CalendarStatus>(context);
    // int d = calendarState.getSelectDate.year + calendarState.getSelectDate.day;
    // if (d == DateTime.now().year + DateTime.now().day) {
    //   print(calendarState.getSelectDate);
    //   //控制選擇日期
    //   _calendarController.setSelectedDay(DateTime.now(), isProgrammatic: false);
    // } else {
    //   _calendarController.setSelectedDay(calendarState.getSelectDate,
    //       isProgrammatic: false);
    // }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');

    //點擊的日期存起來
    Provider.of<CalendarStatus>(context, listen: false).setSelectDate(day);

    Provider.of<CalendarStatus>(context, listen: false).getAllListData();
    // String selectedDay =
    //     new DateFormat("MMM", "en_US").format(day).toUpperCase() +
    //         ". " +
    //         new DateFormat("d", "en_US").format(day).toUpperCase() +
    //         ", " +
    //         new DateFormat("y", "en_US").format(day).toUpperCase();

    // Provider.of<DateStatus>(context, listen: false)
    //     .setAddDate(selectedDay, day.microsecondsSinceEpoch);
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    // print("year===${first.add(Duration(days: 7)).year.toString()}");
    //標題年份
    Provider.of<CalendarTabStatus>(context, listen: false)
        .setYear(first.add(Duration(days: 7)).year.toString());

    //月曆可見的第一天和最後一天
    // Provider.of<CalendarStatus>(context, listen: false)
    //     .getIntervalData(getDateTimeInt(first), getDateTimeInt(last));
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
        height: 330,
        width: width,
        color: Colors.white,
        child: _buildTableCalendarWithBuilders());
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    var calendarState = Provider.of<CalendarStatus>(context);
    //頁面渲染完畢執行
    WidgetsBinding.instance.addPostFrameCallback((mag) {
      DateTime dt = calendarState.getSelectDate;
      int d = dt.year + dt.day;
      if (d != DateTime.now().year + DateTime.now().day) {
        //控制選擇日期
        _calendarController.setSelectedDay(dt, isProgrammatic: false);
      }
    });

    return TableCalendar(
      rowHeight: 40,
      locale: 'en_US',
      calendarController: _calendarController,
      // events: _events,
      initialSelectedDay: calendarState.initialSelectedDay,
      holidays: calendarState.calendarMarkMap,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      // availableCalendarFormats: const {
      //   CalendarFormat.month: '',
      //   CalendarFormat.week: '',
      // },

      titleStatus: false,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideHolidayStyle: outsideWeekendStyle,
        //隔月或前月平日
        outsideStyle: outsideWeekendStyle,
        //隔月或前月假日
        outsideWeekendStyle: outsideWeekendStyle,
        //平日
        weekdayStyle: weekdayStyle,
        //假日
        weekendStyle: weekdayStyle,
        holidayStyle: weekdayStyle,
      ),
      //假日標題
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: weekdayStyle,
        weekendStyle: weekdayStyle,
      ),
      //年越標題日期
      headerStyle: HeaderStyle(
        leftChevronIcon: Icon(
          Icons.arrow_left,
          size: 30,
          color: AppColors.selectBackroundColor,
        ),
        rightChevronIcon: Icon(
          Icons.arrow_right,
          size: 30,
          color: AppColors.selectBackroundColor,
        ),
        titleTextStyle: weekdayStyle,
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      //自定義
      headerStyleMM: HeaderStyle(
        titleTextStyle: weekdayStyle,
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              decoration: new BoxDecoration(
                  border: new Border.all(
                      color: Color.fromRGBO(100, 149, 153, 0.5), width: 3),
                  borderRadius: new BorderRadius.circular((10.0))),
              margin: const EdgeInsets.only(
                left: 8.25,
                right: 8.25,
              ),
              // padding: const EdgeInsets.only(top: 5.0, left: 6.0),

              width: 70,
              height: 70,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle().copyWith(
                      fontSize: 16.0,
                      color: Color.fromRGBO(100, 149, 153, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.only(
              left: 8.25,
              right: 8.25,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Color.fromRGBO(100, 149, 153, 1),
            ),
            width: 100,
            height: 100,
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          // if (events.isNotEmpty) {
          //   children.add(
          //     Positioned(
          //       bottom: -3,
          //       child: _buildEventsMarker(date, events),
          //     ),
          //   );
          // }
          if (holidays.isNotEmpty) {
            children.add(
              Positioned.fill(
                bottom: 3,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildHolidaysMarker()),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildHolidaysMarker() {
    return Container(
      height: 7,
      width: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.calendarCircleColor,
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 50.0,
        height: 16.0,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: events
                .map((item) => new Container(
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // borderRadius: BorderRadis.all(Radius.circular(50.0)),
                        color: AppColors.calendarCircleColor,
                      ),
                    ))
                .toList()));
  }
}
