import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/providers/date_provider.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

import '../../../constants/app_theme.dart';

class DatePopUp extends StatefulWidget {
  const DatePopUp({Key? key}) : super(key: key);

  @override
  State<DatePopUp> createState() => _DatePopUpState();
}

class _DatePopUpState extends State<DatePopUp> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DatePickerWidget(
          looping: false,
          firstDate: DateTime.now(),
          dateFormat: "dd/MMMM/yyyy",
          onChange: (DateTime newDate, _) {
            setState(() {
              selectedDate = newDate;
            });
          },
          pickerTheme: const DateTimePickerTheme(
            backgroundColor: Colors.transparent,
            itemTextStyle:
            TextStyle(color: AppColors.mainWhite, fontSize: 19),
            dividerColor: Colors.transparent,
          ),
        ),

        const SizedBox(height: 10,),
        GestureDetector(
            onTap:() {
              context.read<DateProvider>().setDate(selectedDate);
              Navigator.pop(context);
            },
            child: const Card(
              color: AppColors.primaryBlue,
              child: SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("Set Date", style: TextStyle(fontSize: 15,),),
                  )
              ),
            )
        ),
      ],
    );
  }
}
