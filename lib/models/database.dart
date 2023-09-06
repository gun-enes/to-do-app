import 'package:isar/isar.dart';
part 'database.g.dart';

@Collection()
class TodoItem {
  Id id = Isar.autoIncrement;
  late String title;
  late DateTime date;
  late DateTime alarm;
  late bool isDone;
  late bool isAlarmSet;
  late String repeat;
  late int count;
  late List<bool> daysOfWeek;
}
