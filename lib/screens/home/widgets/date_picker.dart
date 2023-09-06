

import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:to_do_app/screens/home/widgets/date_widget.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/utils/providers/date_provider.dart';

import '../../../constants/app_theme.dart';

class DatePicker extends StatefulWidget {
  final DateTime startDate;
  final double width;
  final double height;
  final Color selectedTextColor;
  final Color selectionColor;
  final Color deactivatedColor;
  final DateTime? initialSelectedDate;
  final List<DateTime>? inactiveDates;
  final List<DateTime>? activeDates;
  final DateChangeListener? onDateChange;
  final int daysCount;
  final ItemScrollController controller;
  final ItemPositionsListener itemPositionsListener;

  DatePicker(
      this.startDate, {
        Key? key,
        this.width = 60,
        this.height = 60,
        this.selectedTextColor = AppColors.secondaryBlue,
        this.selectionColor = AppColors.secondaryBlue,
        this.deactivatedColor = Colors.transparent,
        this.initialSelectedDate,
        this.activeDates,
        this.inactiveDates,
        this.daysCount = 9861,
        this.onDateChange,
        required this.controller,
        required this.itemPositionsListener
      }) : assert(
  activeDates == null || inactiveDates == null,
  "Can't "
      "provide both activated and deactivated dates List at the same time.");

  @override
  State<StatefulWidget> createState() => new _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _currentDate;
  late final TextStyle selectedDateStyle;
  late final TextStyle selectedMonthStyle;
  late final TextStyle selectedDayStyle;

  late final TextStyle deactivatedDateStyle;
  late final TextStyle deactivatedMonthStyle;
  late final TextStyle deactivatedDayStyle;

  @override
  void initState() {
    _currentDate = widget.initialSelectedDate;
    super.initState();
  }
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  @override
  Widget build(BuildContext context) {
    DateProvider dateProvider = Provider.of<DateProvider>(context);
    _currentDate = dateProvider.selectedDate;
    //widget.controller.jumpTo(index: DateTime.now().difference(DateTime(2023,1,1)).inDays,);
    return Container(
      height: widget.height,
      width: 37*8,
      child: ScrollablePositionedList.builder(
        itemCount: widget.daysCount,
        initialScrollIndex: (DateTime.now().difference(DateTime(2023,1,1)).inDays - 4),
        scrollDirection: Axis.horizontal,
        itemScrollController: widget.controller,
        scrollOffsetController: scrollOffsetController,
        itemPositionsListener: widget.itemPositionsListener,
        scrollOffsetListener: scrollOffsetListener,
        itemBuilder: (context, index) {
          DateTime date;
          DateTime _date = widget.startDate.add(Duration(days: index));
          date = DateTime(_date.year, _date.month, _date.day);

          bool isDeactivated = false;

          if (widget.inactiveDates != null) {
//            print("Inside Inactive dates.");
            for (DateTime inactiveDate in widget.inactiveDates!) {
              if (_compareDate(date, inactiveDate)) {
                isDeactivated = true;
                break;
              }
            }
          }

          if (widget.activeDates != null) {
            isDeactivated = true;
            for (DateTime activateDate in widget.activeDates!) {
              // Compare the date if it is in the
              if (_compareDate(date, activateDate)) {
                isDeactivated = false;
                break;
              }
            }
          }

          bool isSelected =
          _currentDate != null ? _compareDate(date, _currentDate!) : false;
          return DateWidget(
            date: date,
            selectionColor:
            isSelected ? AppColors.primaryBlue : Colors.transparent,
            textColor:
            isSelected ? AppColors.mainWhite : AppColors.secondaryBlue,
            onDateSelected: (selectedDate) {
              // Don't notify listener if date is deactivated
              if (isDeactivated) return;

              // A date is selected
              if (widget.onDateChange != null) {
                widget.onDateChange!(selectedDate);
              }
              setState(() {
                _currentDate = selectedDate;
              });
            },
          );
        },
      ),
    );
  }

  /// Helper function to compare two dates
  /// Returns True if both dates are the same
  bool _compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}