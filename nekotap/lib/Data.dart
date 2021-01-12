import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'AppBackground.dart';

class Data extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DataState();
  }
}

class _DataState extends State<Data> {
  DateTime _currentDate = DateTime.now();

  void onDayPressed(DateTime date, List<Event> events) {
    this.setState(() => _currentDate = date);
    Fluttertoast.showToast(msg: date.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("今までの記録"),
        ),
        body: Stack(children: [
          AppBackground(),
          Container(
            child: CalendarCarousel<Event>(
                onDayPressed: onDayPressed,
                weekendTextStyle: TextStyle(color: Colors.red),
                thisMonthDayBorderColor: Colors.grey,
                weekFormat: false,
                height: 420.0,
                selectedDateTime: _currentDate,
                daysHaveCircularBorder: false,
                customGridViewPhysics: NeverScrollableScrollPhysics(),
                markedDateShowIcon: true,
                markedDateIconMaxShown: 2,
                todayTextStyle: TextStyle(
                  color: Colors.blue,
                ),
                markedDateIconBuilder: (event) {
                  return event.icon;
                },
                todayBorderColor: Colors.green,
                markedDateMoreShowTotal: false),
          ),
        ]));
  }
}