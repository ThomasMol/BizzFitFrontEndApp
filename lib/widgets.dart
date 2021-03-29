import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash.dart';

class CustomWidgets {

  // Show Toast message
  static showMessage(String message, BuildContext context) {
    showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash.dialog(
            controller: controller,
            alignment: const Alignment(0, 1),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 55.0),
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
