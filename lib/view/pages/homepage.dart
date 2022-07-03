
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../providers/scheduleprovider.dart';
import '../../utils/colorconstants.dart';
import '../../utils/utils.dart';
import '../widgets/custom_bottomsheet.dart';
import '../widgets/dashlines.dart';

final scaffoldState = GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoad = false;
  final CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  void initState() {
    callFunc();
    super.initState();
  }

  void callFunc() {
    setState(() {
      isLoad = true;
    });
    Future.delayed(Duration.zero, () {
      Provider.of<ScheduleProvider>(context, listen: false)
          .getSchedules(DateTime.now())
          .then((value) {
        setState(() {
          isLoad = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final utils = Utils();
    final kToday = DateTime.now();
    final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              headerVisible: true,
              headerStyle: HeaderStyle(
                  titleTextFormatter: (date, locale) =>
                      DateFormat("MMMM yyyy").format(date).toUpperCase(),
                  headerPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  titleTextStyle: utils.textStyle(fontSize: 22),
                  leftChevronVisible: false,
                  rightChevronVisible: false,
                  formatButtonVisible: false),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle:
                    utils.textStyle(fontSize: 12, fontWeight: FontWeight.w400),
                weekendStyle:
                    utils.textStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
              calendarStyle: CalendarStyle(
                weekendTextStyle: utils.textStyle(),
                todayDecoration: BoxDecoration(
                    color: _selectedDay == null
                        ? const Color(0xFF2F80ED)
                        : Colors.white,
                    shape: BoxShape.circle),
                todayTextStyle: utils.textStyle(
                    color: _selectedDay == null
                        ? Colors.white
                        : const Color(0XFF000000)),
                selectedDecoration: const BoxDecoration(
                    color: Color(0xFF2F80ED), shape: BoxShape.circle),
                selectedTextStyle: utils.textStyle(color: Colors.white),
                defaultTextStyle: utils.textStyle(),
              ),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  Provider.of<ScheduleProvider>(context, listen: false)
                      .getSchedules(selectedDay);
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
            ),
            const SizedBox(height: 5),
            scheduleSection(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bottomSheet(context);
          },
          child: const Icon(
            Icons.add,
            color: floatingIconColor,
          ),
        ),
      ),
    );
  }

  Future<dynamic> bottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
        ),
        builder: (BuildContext context) {
          return ScheduleButtomSheet(date: _selectedDay);
        });
  }

  Widget scheduleSection() {
    final data = Provider.of<ScheduleProvider>(context);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        padding: const EdgeInsets.only(left: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: containerColor,
        ),
        child: isLoad
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: data.schedules.length,
                itemBuilder: (context, index) {
                  String startTime = data.schedules[index].startTime.toString();
                  String endTime = data.schedules[index].endTime.toString();
                  print(startTime);
                  return Container(
                    margin: index == 0 ? const EdgeInsets.only(top: 27) : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 77,
                              width: 55,
                              decoration: BoxDecoration(
                                  color: scheduleContainerColor,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                  child:
                                      Image.asset("assets/images/Vector.png")),
                            ),
                            index == data.schedules.length - 1
                                ? const SizedBox(
                                    height: 43,
                                  )
                                : const Dash(
                                    height: 3,
                                    width: 1.5,
                                  )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(data.timeFinder(startTime),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                  Container(
                                    height: 1,
                                    width: 5,
                                    color: Colors.black,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                  ),
                                  Text(data.timeFinder(endTime),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                  Text(
                                      "(${data.timeDifference(startTime, endTime)})",
                                      style:
                                          Theme.of(context).textTheme.headline1)
                                ],
                              ),
                              Text(
                                data.schedules[index].name!,
                                style: Utils().textStyle(
                                    color: scheduleTextColor,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
