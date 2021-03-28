import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                leading: const Icon(CupertinoIcons.timer_fill),
                title: Text('How are you feeling?'),
                subtitle: CupertinoSlider(
                    min: 1,
                    max: 5,
                    divisions: 5,
                    value: _cupertinoSliderValue.toDouble(),
                    onChanged: (double newValue) {
                      setState(() {
                        _cupertinoSliderValue = newValue.round();
                      });
                    })),
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
                    child: Text('Save'),
                    onPressed: () {
                       _saveMentalState();
                      Navigator.pop(context);
                    },
                  ),
          ],
        )))));
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
      'state': _cupertinoSliderValue
    };
    var response = await CallApi().postRequest(data, '/mentalstates/');
    if (response['status'] == 'Success') {
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
