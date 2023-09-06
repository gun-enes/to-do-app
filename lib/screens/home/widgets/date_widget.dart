import 'package:flutter/material.dart';

import '../../../constants/app_theme.dart';

typedef DateSelectionCallback = void Function(DateTime selectedDate);
typedef DateChangeListener = void Function(DateTime selectedDate);

class DateWidget extends StatelessWidget {
  final DateTime date;
  final Color selectionColor;
  final Color textColor;
  final DateSelectionCallback? onDateSelected;

  const DateWidget({super.key,
    required this.textColor,
    required this.selectionColor,
    required this.date,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        width: 38,
        child: CircleAvatar(
          backgroundColor: selectionColor,
          child: Text(date.day.toString(), // Date
            style: TextStyle(color: textColor,fontSize: 17),),
        ),
      ),
      onTap: () {
        if (onDateSelected != null) {
          onDateSelected!(date);
        }
      },
    );
  }
}
