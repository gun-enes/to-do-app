import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:to_do_app/utils/providers/date_provider.dart';

import '../../../constants/app_theme.dart';
class Agenda extends StatefulWidget {
  const Agenda({Key? key}) : super(key: key);

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  @override
  Widget build(BuildContext context) {
    DateProvider dateProvider = Provider.of<DateProvider>(context);
    return SfDateRangePicker(
      headerStyle: DateRangePickerHeaderStyle(
        textStyle: TextStyle(
            color: AppColors.secondaryBlue,
            fontSize: 20,
            fontWeight: FontWeight.w800),
        textAlign: TextAlign.center,
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        textStyle: TextStyle(color: AppColors.mainWhite, fontSize: 15)
      ),
      monthViewSettings: const DateRangePickerMonthViewSettings(
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
          textStyle: TextStyle(color: Colors.white)
        )
      ),
      view: DateRangePickerView.month,
      onSelectionChanged: (args) {
        DateTime selectedDate = args.value;
        dateProvider.setSelectedDate(selectedDate);
      },
    );
  }
}
