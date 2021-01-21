//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:text_print_3d/common/calendar/table_calendar.dart';
import 'package:text_print_3d/common/extra/color.dart';
import 'package:text_print_3d/common/extra/style.dart';
import 'package:text_print_3d/state/calendar_status.dart';
import 'package:text_print_3d/state/date_status.dart';
import 'package:text_print_3d/state/layer_status.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 12, 25): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class HomeLayerCalendar extends StatefulWidget {
  HomeLayerCalendar({Key key}) : super(key: key);

  @override
  _HomeLayerCalendarState createState() => _HomeLayerCalendarState();
}

class _HomeLayerCalendarState extends State<HomeLayerCalendar>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    //將選擇日期暫時先存起來 有可能會頁面關閉
    Provider.of<CalendarStatus>(context, listen: false).setSaveDate(day);
    String selectedDay =
        new DateFormat("MMM", "en_US").format(day).toUpperCase() +
            ". " +
            new DateFormat("d", "en_US").format(day).toUpperCase() +
            ", " +
            new DateFormat("y", "en_US").format(day).toUpperCase();
    print(selectedDay);
    //寫入選擇日期 紀錄 讓按鈕不能點 使用
    Provider.of<LayerStatus>(context, listen: false).setTomorrow(selectedDay);
    
    Provider.of<DateStatus>(context, listen: false)
        .setAddDate(selectedDay, day.microsecondsSinceEpoch);
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var dateState = Provider.of<DateStatus>(context);
    return Container(
        height: 330,
        width: width,
        color: Colors.white,
        child: _buildTableCalendarWithBuilders(dateState.selectDate));
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders(selectDate) {
    return TableCalendar(
      rowHeight: 40,
      locale: 'en_US',
      calendarController: _calendarController,
      events: _events,
      // holidays: _holidays,
      initialSelectedDay: selectDate,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      // availableCalendarFormats: const {
      //   CalendarFormat.month: '',
      //   CalendarFormat.week: '',
      // },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        //隔月或前月平日
        outsideStyle: outsideWeekendStyle,
        //隔月或前月假日
        outsideWeekendStyle: outsideWeekendStyle,
        //平日
        weekdayStyle: weekdayStyle,
        //假日
        weekendStyle: weekdayStyle,
        // holidayStyle:
        //     TextStyle().copyWith(color: Color.fromRGBO(100, 149, 153, 1)),
      ),
      //假日標題
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: weekdayStyle,
        weekendStyle: weekdayStyle,
      ),
      //年越標題日期
      headerStyle: HeaderStyle(
        titleTextStyle: weekdayStyle,
        centerHeaderTitle: true,
        formatButtonVisible: false,
        leftChevronMargin: EdgeInsets.symmetric(horizontal: 0),
        leftChevronIcon: Icon(
          Icons.arrow_left,
          color: AppColors.frontLayerTextFiedColor,
        ),
        rightChevronMargin: EdgeInsets.symmetric(horizontal: 0),
        rightChevronIcon: Icon(
          Icons.arrow_right,
          color: AppColors.frontLayerTextFiedColor,
        ),
      ),

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

              width: 50,
              height: 50,
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
}
