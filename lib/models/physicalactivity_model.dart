class PhysicalActivity {
  final int points;
  final String type;
  final int time;
  final DateTime dateTime;

  PhysicalActivity({this.points, this.type, this.time, this.dateTime});

  factory PhysicalActivity.fromJson(Map<String, dynamic> json) {
    return PhysicalActivity(
      points: json['points'],
      type: json['type'],
      time: json['time_seconds'],
      dateTime: json['date_time'],
    );
  }
}