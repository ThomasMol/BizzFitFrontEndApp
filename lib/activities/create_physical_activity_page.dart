import 'package:bizzfit/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api.dart';

class CreatePhysicalActivity extends StatefulWidget {
  static const title = 'Add new activity';

  @override
  _CreatePhysicalActivityState createState() => _CreatePhysicalActivityState();
}

class _CreatePhysicalActivityState extends State<CreatePhysicalActivity> {
  int _typePickerValue = 0;
  Duration _timePickerValue = Duration.zero;
  DateTime _datePickerValue = DateTime.now();
  var picker_values = [
    'Running',
    'Cycling',
    'Walking',
    'Weightlifting',
  ];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: SafeArea(
            child: Material(
                child: Form(
                    child: Column(
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.sportscourt_fill),
              title: const Text('Type'),
              trailing: Text(picker_values[_typePickerValue]),
              onTap: () => _showTypePicker(context),
            ),
            const Divider(
              height: 1.0,
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.timer_fill),
              title: const Text('Activity time'),
              trailing: Text(_timePickerValue.toString()),
              onTap: () => _showTimePicker(context),
            ),
            const Divider(
              height: 1.0,
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.calendar_today),
              title: const Text('Date and time'),
              trailing: Text(_datePickerValue.toString()),
              onTap: () => _showDatePicker(context),
            ),
            _isLoading
                ? CupertinoActivityIndicator()
                : CupertinoButton.filled(
                    child: Text('Save activity'),
                    onPressed: () {
                      _saveActivity();                      
                    },
                  ),
          ],
        )))));
  }

  void _showTypePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 250,
              child: CupertinoPicker(
                magnification: 1.2,
                backgroundColor: CupertinoColors.white,
                itemExtent: 20,
                scrollController: FixedExtentScrollController(),
                children: [
                  Text('Running'),
                  Text('Cycling'),
                  Text('Walking'),
                  Text('Weightlifting'),
                ],
                onSelectedItemChanged: (value) {
                  setState(() {
                    _typePickerValue = value;
                  });
                },
              ),
            ));
  }

  void _showTimePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 250,
              child: CupertinoTimerPicker(
                backgroundColor: CupertinoColors.white,
                onTimerDurationChanged: (value) {
                  setState(() {
                    _timePickerValue = value;
                  });
                },
              ),
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

  void _saveActivity() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'type': picker_values[_typePickerValue],
      'time': _timePickerValue.inSeconds,
      'date_time': _datePickerValue.toIso8601String()
    };
    var response = await CallApi().postRequest(data, '/physicalactivities/');
    if (response['status'] == 'Success') {
      CustomWidgets.showMessage('Activity successfully saved!', context);
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
