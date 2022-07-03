
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../models/schedule_model.dart';
import '../repositories/schedule_repositories.dart';
import '../utils/colorconstants.dart';
import '../view/widgets/custom_button.dart';

class ScheduleProvider with ChangeNotifier {
  ScheduleRepository repository = ScheduleRepository();
  List<Schedule> schedules = [];
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime =
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  String time24(TimeOfDay time) {
    return '${time.hour}:${time.minute}:00';
  }

  Future<void> getSchedules(DateTime date) async {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    schedules = [];
    repository.fetchSchedules().then((value) {
      for (var element in value) {
        if (element.date == formattedDate) {
          schedules.add(element);
          notifyListeners();
        }
      }
      print(schedules);
    });
  }

  void postSchedule(BuildContext context, Schedule newSchedule) async {
    const uri = "https://alpha.classaccess.io/api/challenge/v1/save/schedule";
    final url = Uri.parse(uri);
    final response = await post(url, body: {
      "name": newSchedule.name,
      "startTime": newSchedule.startTime,
      "endTime": newSchedule.endTime,
      "date": newSchedule.date
    });
    if (response.statusCode == 200) {
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child: const ErrorDialog(),
            );
          });
    }
  }

  String timeFinder(String sTime) {
    String? time;
    if (sTime.contains("PM") || sTime.contains("AM")) {
      return sTime;
    } else {
      time = DateFormat.jm().format(DateFormat("hh:mm:ss").parse(sTime));
      return time;
    }
  }

  String timeDifference(startTime, endTime) {
    String value = '';
    var format = DateFormat("HH:mm");
    var one = format.parse(startTime);
    var two = format.parse(endTime);
    var diff = two.difference(one).toString();
    String hour = diff.split(":")[0].toString();
    String min = diff.split(":")[1].toString();
    if (hour == "0") {
      value = "${min}m";
    } else if (hour != "0" && min == "00") {
      value = "${hour}h";
    } else {
      value = "${hour}h${min}m";
    }
    return value;
  }

  void timeSelector(BuildContext context, String type) async {
    TimeOfDay selectedTime;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      selectedTime = picked;
      // ignore: use_build_context_synchronously
      type == "start" ? startTime = selectedTime : endTime = selectedTime;
      notifyListeners();
    }
  }

  void dateSelector(
    BuildContext context,
  ) async {
    final DateTime? pick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pick != null) {
      selectedDate = DateFormat('dd/MM/yyyy').format(pick);
      notifyListeners();
    } else {
      print("object");
    }
  }
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 30),
            child: const Text(
              "This overlaps with another schedule and can’t be saved.",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: errorMessageColor,
                fontFamily: 'Euclid',
              ),
              maxLines: 3,
            ),
          ),
          const Text(
            "Please modify and try again.",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Euclid',
                color: secondaryTextColor),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomButton(title: "Okay", onTap: () => Navigator.pop(context))
        ],
      ),
    );
  }
}
