
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/schedule_model.dart';
import '../../providers/scheduleprovider.dart';
import '../../utils/colorconstants.dart';
import '../../utils/utils.dart';
import 'custom_button.dart';

class ScheduleButtomSheet extends StatefulWidget {
  final DateTime? date;
  const ScheduleButtomSheet({Key? key, this.date}) : super(key: key);

  @override
  State<ScheduleButtomSheet> createState() => _ScheduleButtomSheetState();
}

class _ScheduleButtomSheetState extends State<ScheduleButtomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  // final TextEditingController startTimeController = TextEditingController();
  // final TextEditingController endTimeController = TextEditingController();
  // final TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final timeprovider = Provider.of<ScheduleProvider>(context);
    final utils = Utils();
    return Form(
      key: _formKey,
      child: Container(
        padding:
            const EdgeInsets.only(left: 22, bottom: 45, right: 16, top: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(7),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start, // To make the card compact
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add Schedule",
                      style: utils.textStyle(
                          fontSize: 16, color: addScheduleTitle)),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close))
                ],
              ),
              const SizedBox(height: 15),
              Text("Name", style: Theme.of(context).textTheme.headline2),
              const SizedBox(height: 4),
              TextFormField(
                controller: nameController,
                validator: (String? val) {
                  if (val!.isEmpty) {
                    return 'Enter a schedule';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(3),
                    filled: true,
                    fillColor: const Color(0XFFE5EFFF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: BorderSide.none,
                    )),
              ),
              const SizedBox(height: 20),
              Text(
                "Date & time",
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.only(top: 2, bottom: 2, left: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: addScheduleFormFieldColor,
                ),
                child: Column(
                  children: [
                    selectionWidget(
                        title: "Start Time",
                        time: timeprovider.startTime.format(context),
                        onTap: () {
                          timeprovider.timeSelector(context, "start");
                        }),
                    divider(),
                    selectionWidget(
                        title: "End Time",
                        time: timeprovider.endTime.format(context),
                        onTap: () {
                          timeprovider.timeSelector(context, "end");
                        }),
                    divider(),
                    selectionWidget(
                        title: "Date",
                        time: timeprovider.selectedDate,
                        onTap: () {
                          timeprovider.dateSelector(context);
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 21),
              CustomButton(
                  title: "Add Schedule",
                  onTap: () {
                    final newSchedule = Schedule(
                        id: null,
                        name: nameController.text.trim(),
                        startTime: timeprovider.time24(timeprovider.startTime),
                        endTime: timeprovider.time24(timeprovider.endTime),
                        date: timeprovider.selectedDate);
                    if (_formKey.currentState!.validate()) {
                      save(context, newSchedule);
                      Navigator.pop(context);
                      timeprovider.getSchedules(widget.date!);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Divider divider() => Divider(
      thickness: 0.8,
      height: 0,
      color: const Color(0XFF000000).withOpacity(.2));

  Row selectionWidget({String? title, String? time, void Function()? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title!,
            style: Utils().textStyle(
                fontSize: 14, color: black, fontWeight: FontWeight.w400)),
        TextButton(
          onPressed: onTap,
          child: Row(
            children: [
              Text(time!,
                  style: Utils().textStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0XFF2F80ED))),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: Color(0XFF273A6B),
              ),
            ],
          ),
        )
      ],
    );
  }

  void save(BuildContext context, Schedule newSchedule) {
    Provider.of<ScheduleProvider>(context, listen: false)
        .postSchedule(context, newSchedule);
  }

  // void timeSelector(BuildContext context, TimeOfDay fromTimeController) async {
  //   TimeOfDay selectedTime;
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     selectedTime = picked;
  //     // ignore: use_build_context_synchronously
  //     setState(() {
  //       fromTimeController = selectedTime;
  //     });
  //   }
  //   setState(() {});
  // }

  // void dateSelector(
  //     BuildContext context, TextEditingController fromDateController) async {
  //   final DateTime? pick = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2100),
  //   );
  //   if (pick != null) {
  //     String formattedDate = DateFormat('yyyy-MM-dd').format(pick);

  //     fromDateController.text = formattedDate;
  //   } else {
  //     print("object");
  //   }
  // }
}
