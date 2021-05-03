import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
import '../api.dart';

class CreateMentalState extends StatefulWidget {
  static const title = 'How are your feeling?';

  @override
  _CreateMentalStateState createState() => _CreateMentalStateState();
}

class _CreateMentalStateState extends State<CreateMentalState> {
  int _cupertinoSliderValue = 3;
  DateTime _datePickerValue = DateTime.now();

  bool _isLoading = false;

  List<int> moods = [0, 1, 2, 3, 4];
  int _moodValue = 2;
  List<Icon> moodIcons = [
    Icon(Icons.sentiment_very_dissatisfied, color: Colors.deepOrange, size: 42),
    Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size: 42),
    Icon(Icons.sentiment_neutral, color: Colors.blueGrey, size: 42),
    Icon(Icons.sentiment_satisfied, color: Colors.green, size: 42),
    Icon(Icons.sentiment_very_satisfied, color: Colors.lightGreen, size: 42)
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: SafeArea(
            child: Material(
                child: Form(
                    child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.timer_fill),
              title: Text('How are you feeling?'),
            ),
            ListTile(
                title: Row(children: [
              radioMoodOption(0),
              radioMoodOption(1),
              radioMoodOption(2),
              radioMoodOption(3),
              radioMoodOption(4),
            ])),
            const Divider(
              height: 1.0,
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.calendar_today),
              title: const Text('Date and time'),
              trailing: Text(_datePickerValue.toString()),
              onTap: () => _showDatePicker(context),
            ),
            const Divider(
              height: 1.0,
            ),
            SizedBox(
              height: 10,
            ),
            _isLoading
                ? CupertinoActivityIndicator()
                : CupertinoButton.filled(
                    child: Text('Save'),
                    onPressed: () {
                      _saveMentalState();
                    },
                  ),
          ],
        )))));
  }

  Widget radioMoodOption(int index) {
    return Expanded(
        child: Column(
      children: [
        moodIcons[index],
        Radio(
            value: index,
            groupValue: _moodValue,
            onChanged: (val) {
              setState(() {
                _moodValue = val;
              });
            })
      ],
    ));
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 250,
              child: CupertinoDatePicker(
                use24hFormat: true,
                backgroundColor: CupertinoColors.white,
                onDateTimeChanged: (value) {
                  setState(() {
                    _datePickerValue = value;
                  });
                },
              ),
            ));
  }

  void _saveMentalState() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'date_time': _datePickerValue.toIso8601String(),
      'state': _moodValue
    };
    var response = await CallApi().postRequest(data, '/mentalstates/');
    if (response['status'] == 'Success') {
      Utils.showMessage('Activity successfully saved!', context);
      Navigator.pop(context);
    } else if (response['status'] == 'Error') {
      //TODO Handle status is error
    } else {
      // Handle when there is no error or no success (probably when server is not online or something)
    }

    setState(() {
      _isLoading = false;
    });
  }
}
