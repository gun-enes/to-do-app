import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/constants/app_theme.dart';
import 'package:to_do_app/screens/add_task/widgets/alarm_popup.dart';
import 'package:to_do_app/screens/add_task/widgets/date_popup.dart';
import 'package:to_do_app/screens/add_task/widgets/repeat_popup.dart';
import 'package:to_do_app/screens/home/home_screen.dart';
import 'package:to_do_app/utils/providers/date_provider.dart';
import 'package:to_do_app/models/database.dart';
import 'package:to_do_app/utils/providers/alarm_provider.dart';
import 'package:to_do_app/utils/providers/program_provider.dart';
import 'package:to_do_app/utils/providers/repeat_provider.dart';
import '../../main.dart';
import '../../notifications/notifications.dart';
import '../../services/isar_services.dart';

class AddTask extends StatefulWidget {
  final IsarService service;
  const AddTask(this.service, {Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  final formGlobalKey = GlobalKey < FormState > ();
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<AlarmProvider>(context, listen: false).setReset(true);
      Provider.of<DateProvider>(context, listen: false).setDate(DateTime.now());
      Provider.of<RepeatProvider>(context, listen: false).setData("None");
    });
  }
  @override
  Widget build(BuildContext context) {
    AlarmProvider alarmProvider = Provider.of<AlarmProvider>(context);
    DateProvider dateProvider = Provider.of<DateProvider>(context);
    ProgramProvider programProvider = Provider.of<ProgramProvider>(context);
    RepeatProvider repeatProvider = Provider.of<RepeatProvider>(context);
    FocusNode focus = FocusNode();
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: formGlobalKey,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(" New Task",
                        style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 30,
                            fontWeight: FontWeight.w900)),
                    SizedBox(
                      height: 50,
                      width: 70,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Center(
                            child: Card(
                              elevation: 0,
                              color: AppColors.mainBlue,
                              child: Text("Cancel",
                                  style: TextStyle(
                                      color: AppColors.blue, fontSize: 18)),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This area should be filled';
                    }
                    return null;
                  },
                  cursorColor: Colors.grey[800],
                  focusNode: focus,
                  textCapitalization: TextCapitalization.sentences,
                  controller: titleController,
                  style: const TextStyle(color: AppColors.secondaryBlue, fontSize: 30),
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Write your task",
                    errorStyle: const TextStyle(color: AppColors.buttonColor),
                    hintStyle: TextStyle(
                        color: Colors.grey[800], fontWeight: FontWeight.w200),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  focus.unfocus();
                  showDialog<String>(

                          context: context,
                          builder: (BuildContext context) => RepeatPopUp());
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: SizedBox(
                    height: 80,
                    child: Card(
                      color: AppColors.deepButtonColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: ListTile(
                            title: const Text(
                              "Repeat",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffdadaf0),
                              ),
                            ),
                            trailing: Text(repeatProvider.data,
                                style: const TextStyle(
                                    fontSize: 13, color: Color(0xff6f6fa0))),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  focus.unfocus();
                  showModalBottomSheet(
                      backgroundColor: AppColors.mainBlue,
                      context: context,
                      builder: (context) {
                        return const SizedBox(height: 250, child: DatePopUp());
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: SizedBox(
                    height: 80,
                    child: Card(
                      color: AppColors.deepButtonColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: ListTile(
                            title: const Text("Date",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xffdadaf0),
                                )),
                            trailing: compare(dateProvider.date, DateTime.now())
                                ? const Text("Today",
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xff6f6fa0)))
                                : Text(
                                    DateFormat.yMMMd()
                                        .format(dateProvider.date)
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 13, color: Color(0xff6f6fa0))),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  focus.unfocus();
                  showModalBottomSheet(
                      backgroundColor: AppColors.mainBlue,
                      context: context,
                      builder: (context) {
                        return const SizedBox(height: 330, child: AlarmPopUp());
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: SizedBox(
                    height: 80,
                    child: Card(
                      color: AppColors.deepButtonColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: ListTile(
                            title: const Text(
                              "Alarm",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffdadaf0),
                              ),
                            ),
                            trailing: alarmProvider.reset
                                ? const Text("None",
                                    style: TextStyle(
                                        fontSize: 13, color: Color(0xff6f6fa0)))
                                : Text(
                                    DateFormat.Hm()
                                        .format(alarmProvider.alarm)
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 13, color: Color(0xff6f6fa0))),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 8,4),
                child: OpenContainer(
                  closedElevation: 0,
                  closedColor: AppColors.mainBlue,
                  transitionDuration: Duration(milliseconds: 300),
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedBuilder: (_, openContainer) {
                    return GestureDetector(
                        onTap: () async {
                          if (formGlobalKey.currentState!.validate()) {
                            final newItem = TodoItem()
                              ..alarm = alarmProvider.alarm
                              ..title = titleController.text
                              ..date = dateProvider.date
                              ..isDone = false
                              ..isAlarmSet = alarmProvider.reset
                              ..count = repeatProvider.count
                              ..daysOfWeek = repeatProvider.days
                              ..repeat = repeatProvider.data;
                            programProvider.addTodoItem(newItem);
                            //Noti.showBigTextNotification(title: "Your message", body: "Long body", fln: flutterLocalNotificationsPlugin);
                            Navigator.pop(context);
                            alarmProvider.setAlarm(DateTime.now());
                            dateProvider.setDate(DateTime.now());
                          }
                        },
                        child: const Card(
                          elevation: 0,
                          color: AppColors.buttonColor,
                          child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Add Task",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              )),
                        ));
                  },
                  openBuilder: (_, closeContainer) {
                    return const MyHomePage();
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  bool compare(DateTime first, DateTime second) {
    if (first.day == second.day &&
        first.month == second.month &&
        first.year == second.year) {
      return true;
    } else {
      return false;
    }
  }
}
