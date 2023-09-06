import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/database.dart';
import 'package:to_do_app/services/isar_services.dart';
import 'package:to_do_app/utils/providers/alarm_provider.dart';
import 'package:to_do_app/screens/home/home_screen.dart';
import 'package:to_do_app/utils/providers/date_provider.dart';
import 'package:to_do_app/utils/providers/program_provider.dart';
import 'package:to_do_app/utils/providers/repeat_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notifications/notifications.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  /*final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'), // <- Default icon for Android
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);*/
  Noti.initialize(flutterLocalNotificationsPlugin);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProgramProvider()),
    ChangeNotifierProvider(create: (_) => AlarmProvider()),
    ChangeNotifierProvider(create: (_) => DateProvider()),
    ChangeNotifierProvider(create: (_) => RepeatProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> getNecessaryData(context) async {
    var programProvider = Provider.of<ProgramProvider>(context, listen: false);
    try {
      Isar localTodoItems = await IsarService.openDB();
      List<TodoItem> allItems = await IsarService.getAll(localTodoItems);
      programProvider.changeTodoItemList(allItems);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
          future: getNecessaryData(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return const MyHomePage();
              } else {
                return const Center(child: Text("Error"));
              }
            }
            return Container();
          }),
    );
  }
}
