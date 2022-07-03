

class Schedule {
  Schedule({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.date,
  });

  String? id;
  String? name;
  String? startTime;
  String? endTime;
  String? date;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["_id"],
        name: json["name"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "startTime": startTime,
        "endTime": endTime,
        "date": date,
      };
}
