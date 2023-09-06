import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/constants/app_theme.dart';
import 'package:to_do_app/utils/providers/alarm_provider.dart';


class AlarmPopUp extends StatefulWidget {
  const AlarmPopUp( {Key? key}) : super(key: key);

  @override
  State<AlarmPopUp> createState() => _AlarmPopUpState();
}

class _AlarmPopUpState extends State<AlarmPopUp> {
  @override
  Widget build(BuildContext context) {
    AlarmProvider alarmProvider = Provider.of<AlarmProvider>(context);
    DateTime alarmTime = DateTime.now();
    return Column(
      children: [
        TimePickerSpinner(
          time: alarmProvider.alarm,
          is24HourMode: true,
          minutesInterval: 1,
          normalTextStyle: const TextStyle(
              fontSize: 24,
              color: Colors.grey
          ),
          highlightedTextStyle: const TextStyle(
              fontSize: 24,
              color: AppColors.mainWhite
          ),
          onTimeChange: (time){
            alarmTime = time;
          },
          spacing: 50,
          itemHeight: 80,
          isForce2Digits: true,
        ),
        const SizedBox(height: 10,),
        Row(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            GestureDetector(
                onTap:() {
                  alarmProvider.setReset(true);
                  Navigator.pop(context);
                },
                child: const SizedBox(
                  width: 200,
                  child: Card(
                    color: AppColors.primaryBlue,
                    child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text("Reset Alarm", style: TextStyle(fontSize: 15,),),
                        )
                    ),
                  ),
                )
            ),
            GestureDetector(
              onTap:() {
                alarmProvider.setAlarm(alarmTime);
                alarmProvider.setReset(false);
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 200,
                child: Card(
                  color: AppColors.primaryBlue,
                  child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Text("Set Alarm", style: TextStyle(fontSize: 15,),),
                      )
                  ),
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }
}
