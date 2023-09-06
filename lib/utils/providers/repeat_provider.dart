import 'package:flutter/material.dart';

import '../../constants/app_theme.dart';

class RepeatProvider with ChangeNotifier {
  String _data = "";
  List<Color> _colors = [
    AppColors.mainBlue,
    AppColors.mainBlue,
    AppColors.mainBlue,
    AppColors.mainBlue,
    AppColors.mainBlue,
    AppColors.mainBlue,
    AppColors.mainBlue,
  ];
  int _count = 0;
  List<bool> _days = [false,false,false,false,false,false,false,];

  get count => _count;
  get days => _days;
  get data => _data;
  get colors => _colors;

  void setCount(int newValue){
    _count = newValue;
    notifyListeners();
  }
  void setColor(Color newValue, int index){
    _colors[index] = newValue;
    notifyListeners();
  }

  void setDay(int index){
    _days[index]  = true;
    notifyListeners();
  }
  void unsetDay(int index){
    _days[index] = false;
    notifyListeners();
  }

  void setData(String newValue) {
    _data = newValue;
    notifyListeners();
  }
}
