import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'package:intl/intl.dart';

class Utils {

  // List of physical activities icons,
  // for now keys are based on strava ActivityTypes from their api
  static List<dynamic> activitiesIcons = [
    {'Run': Icon(Icons.run_circle_outlined, color: Colors.blueGrey, size: 42)},
    {'Ride': Icon(Icons.pedal_bike, color: Colors.blueGrey, size: 42)},
    {'Swim': Icon(Icons.water_damage, color: Colors.blueGrey, size: 42)},
  ];

  // List of icons for mood scale 1 - 5
  static List<Icon> moodIcons = [
    Icon(Icons.sentiment_very_dissatisfied, color: Colors.deepOrange, size: 42),
    Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size: 42),
    Icon(Icons.sentiment_neutral, color: Colors.blueGrey, size: 42),
    Icon(Icons.sentiment_satisfied, color: Colors.green, size: 42),
    Icon(Icons.sentiment_very_satisfied, color: Colors.lightGreen, size: 42)
  ];
  // Textual mood scale scale 1 - 5
  static List<String> moods = ['Awful', 'Bad', 'Neutral', 'Good', 'Amazing'];

  // Generates list of dates with no time with specified format and length
  static List<String> generateListDates(String format, int length) {
    return List<String>.generate(length, (i) {
      DateTime dateTime = DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ).subtract(Duration(days: i));
      String formattedDateTime = DateFormat(format).format(dateTime);
      return formattedDateTime;
    });
  }

  // Show Toast message
  static showMessage(String message, BuildContext context) {
    showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash.dialog(
            controller: controller,
            alignment: const Alignment(0, 1),
            margin:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 55.0),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            enableDrag: false,
            backgroundColor: Colors.black87,
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 16.0, color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(message),
              ),
            ),
          );
        });
  }
}
