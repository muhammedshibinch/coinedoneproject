import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule_model.dart';

class ScheduleRepository {
  Future<List<Schedule>> fetchSchedules() async {
    const uri = "https://alpha.classaccess.io/api/challenge/v1/schedule";
    final url = Uri.parse(uri);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<dynamic> datas = body["data"];
      List<Schedule> schedules = [];
      for (var element in datas) {
        final model = Schedule.fromJson(element);
        schedules.add(model);
      }
      //print(schedules);
      return schedules;
    } else {
      throw 'Unable to fetch';
    }
  }
}
