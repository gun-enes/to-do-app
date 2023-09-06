import 'package:flutter/material.dart';

class DateProvider with ChangeNotifier {
  DateTime _date = DateTime.now().toLocal();
  DateTime _selectedDate = DateTime.now().toLocal();
  ValueNotifier<DateTime> _visibleDate = ValueNotifier<DateTime>(DateTime.now().toLocal());

  DateTime get date => _date;
  DateTime get selectedDate => _selectedDate;
  ValueNotifier<DateTime> get visibleDate => _visibleDate;

  void setDate(DateTime newValue) {
    _date = newValue;
    notifyListeners();
  }

  void setSelectedDate(DateTime newValue) {
    _selectedDate = newValue;
    notifyListeners();
  }
  void setVisibleDate(DateTime newValue) {
    _visibleDate.value = newValue;
    notifyListeners();
  }

}
