import 'package:flutter/material.dart';

class AlarmProvider with ChangeNotifier {
  DateTime _alarm = DateTime.now();
  bool _reset = true;

  DateTime get alarm => _alarm;
  bool get reset => _reset;

  void setAlarm(DateTime newValue) {
    _alarm = newValue;
    notifyListeners();
  }

  void setReset(bool newValue) {
    _reset = newValue;
    notifyListeners();
  }
}
