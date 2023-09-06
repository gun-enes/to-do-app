import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/constants/app_theme.dart';
import 'package:to_do_app/screens/add_task/add_task_screen.dart';
import 'package:to_do_app/screens/home/widgets/agenda.dart';
import 'package:to_do_app/screens/home/widgets/home_header.dart';
import 'package:to_do_app/models/database.dart';
import 'package:to_do_app/screens/home/widgets/listtile.dart';
import 'package:to_do_app/services/isar_services.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/screens/home/widgets/date_picker.dart';
import 'package:to_do_app/utils/providers/date_provider.dart';
import 'package:to_do_app/utils/providers/program_provider.dart';
import 'package:animations/animations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../main.dart';
import '../../notifications/notifications.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final service = IsarService();
  ItemScrollController controller = ItemScrollController();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 100));
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  int? lastFirstIndex;
  @override
  void initState(){
    super.initState();
    itemPositionsListener.itemPositions.addListener(_scrollListener);
    //Noti.initialize(flutterLocalNotificationsPlugin);
  }
  @override
  void dispose(){
    itemPositionsListener.itemPositions.removeListener(_scrollListener);
    super.dispose();
  }
  _scrollListener() {
    _debouncer(() {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        final firstIndex = positions.first.index;
        if (lastFirstIndex != null) {
          if (firstIndex > lastFirstIndex!) {
            Provider.of<DateProvider>(context, listen: false).setVisibleDate(DateTime(itemPositionsListener.itemPositions.value.toList()[4].index ~/365+2023, itemPositionsListener.itemPositions.value.toList()[4].index % 365 ~/ 30 + 1));
          } else if (firstIndex < lastFirstIndex!) {
            Provider.of<DateProvider>(context, listen: false).setVisibleDate(DateTime(itemPositionsListener.itemPositions.value.toList()[4].index ~/365+2023, itemPositionsListener.itemPositions.value.toList()[4].index % 365 ~/ 30 + 1));
          }
        }
        lastFirstIndex = firstIndex;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    DateProvider dateProvider = Provider.of<DateProvider>(context);
    ProgramProvider programProvider = Provider.of<ProgramProvider>(context);
    //controller.scrollTo(index: DateTime.now().difference(DateTime(2023,1,1)).inDays, duration: Duration(seconds: 0));
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      /*appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.mainBlue,
        elevation: 0,
        flexibleSpace: const SafeArea(
          minimum: EdgeInsets.only(top: 40),
          child: HomeHeader(),
        ),
      ),*/
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              SizedBox(
              width: 50,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Tooltip(
                    message: "To Do App: A beautifully designed task manager to simplify and organize your daily life. Created with passion and dedication by Enes Gün for FutureTea.",
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: Duration(seconds: 3),
                    child: Icon(
                      Icons.info_outline,
                      color: AppColors.mainWhite,
                    ),
                  ),
                ),
              ),
            ),
                SizedBox(
                  width: 50,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if(programProvider.isAgenda) {
                        programProvider.toggleIsAgenda(false);
                      } else {
                        programProvider.toggleIsAgenda(true);
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Icon(
                        Icons.calendar_month,
                        color: AppColors.mainWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (!programProvider.isAgenda) Column(
              children: [
                ValueListenableBuilder<DateTime>(
                    valueListenable: Provider.of<DateProvider>(context, listen: false).visibleDate,
                    builder: (context, datetime, child) {
                      return Text(
                        DateFormat.yMMMM()
                            .format(datetime)
                            .toString(),
                        style: const TextStyle(
                            color: AppColors.secondaryBlue,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      );
                    }
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 39,
                      child: IconButton(onPressed: (){
                        controller.scrollTo(index: (DateTime.now().difference(DateTime(2023,1,1)).inDays - 4), duration: const Duration(milliseconds: 1500), curve: Curves.decelerate);
                        dateProvider.setSelectedDate(DateTime.now());
                      }, icon: const Icon(Icons.arrow_back_ios, color: AppColors.mainWhite,)),
                    ),
                    DatePicker(
                      DateTime(2023, 1, 1),
                      selectionColor: AppColors.mainWhite,
                      onDateChange: (date) {
                        dateProvider.setSelectedDate(date);
                      },
                      controller: controller,
                      itemPositionsListener: itemPositionsListener,
                    ),
                    SizedBox(
                      width: 39,
                      child: IconButton(onPressed: (){
                        controller.scrollTo(index: (DateTime.now().difference(DateTime(2023,1,1)).inDays - 4), duration: const Duration(milliseconds: 1500), curve: Curves.ease);
                        dateProvider.setSelectedDate(DateTime.now());
                      }, icon: const Icon(Icons.arrow_forward_ios, color: AppColors.mainWhite,)),
                    )
                  ],
                ),
              ],
            )
             else const Agenda(),
            const Divider(
              color: AppColors.blue,
              indent: 32,
              endIndent: 32,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Consumer<DateProvider>(
                builder: (context, date, child){
                  return Text(
                    DateFormat.yMMMMd()
                        .format(date.selectedDate)
                        .toString(),
                    style: const TextStyle(
                        color: AppColors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  );
                }
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return const LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      AppColors.mainBlue
                    ],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: Consumer<ProgramProvider>(
                  builder: (context, program, child) {
                    return Consumer<DateProvider>(
                      builder: (context,date,child) {
                        return ListView.builder(
                          itemCount: program
                              .getTodoItemsByDate(date.selectedDate).length,
                          itemBuilder: (context, index){
                            List<TodoItem> todoItems = program
                                .getTodoItemsByDate(date.selectedDate);
                            return Column(
                              children: [
                                ListTileHomePage(todoItem: todoItems[index]),
                                index == todoItems.length - 1
                                    ? const SizedBox(
                                  height: 100,
                                )
                                    : const SizedBox(),
                              ],
                            );
                            },
                        );
                      }
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: OpenContainer(
        openShape: const RoundedRectangleBorder(),
        closedShape: const CircleBorder(),
        closedColor: AppColors.mainBlue,
        transitionDuration: const Duration(milliseconds: 300),
        transitionType: ContainerTransitionType.fade,
          closedBuilder: (_, openContainer) {
          return FloatingActionButton(
            backgroundColor: AppColors.primaryBlue,
            onPressed: openContainer,
            child: const Icon(
              Icons.add,
              size: 30,
              color: AppColors.mainWhite,
            ),
          );
        },
        openBuilder: (_, closeContainer) {
          return AddTask(service);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}