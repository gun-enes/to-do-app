import 'package:flutter/material.dart';
import 'package:to_do_app/models/database.dart';
import 'package:to_do_app/services/isar_services.dart';

import '../../main.dart';
import '../../notifications/notifications.dart';

class ProgramProvider extends ChangeNotifier {
  final List<TodoItem> _allTodoItemsList = [];
  bool _isAgenda = false;
  bool get isAgenda => _isAgenda;
  List<TodoItem> get allTodoItemsList => _allTodoItemsList;

  void setIsDone(TodoItem todoItem, bool newValue){
    todoItem.isDone = newValue;
    IsarService().upgradeTodoItem(todoItem, newValue);
    notifyListeners();
  }

  void moveToEnd(TodoItem todoItem){
    _allTodoItemsList.remove(todoItem);
    _allTodoItemsList.add(todoItem);
  }

  void moveToStart(TodoItem todoItem){
    _allTodoItemsList.remove(todoItem);
    _allTodoItemsList.insert(0,todoItem);
  }

  void deleteAllEvents(TodoItem todoItem) async {
    List<TodoItem> listToDelete= await IsarService().findAndDelete(todoItem.title);
    IsarService().deleteItemsByObjects(listToDelete);
    IsarService().deleteData(todoItem.id);
    List<TodoItem> newTodoItems = _allTodoItemsList.where((element) {
      return element.title != todoItem.title;
    }).toList();
    changeTodoItemList(newTodoItems);
    notifyListeners();
  }

  void deleteFutureEvents(TodoItem todoItem) async {
    List<TodoItem> listToDelete = await IsarService().findAndDelete2(todoItem.title,todoItem.date);
    IsarService().deleteItemsByObjects(listToDelete);
    List<TodoItem> newTodoItems = _allTodoItemsList.where((element) {
      return element.title != todoItem.title || (element.title == todoItem.title && (element.date.year < todoItem.date.year) || (element.date.year == todoItem.date.year && element.date.month < todoItem.date.month) || (element.date.year == todoItem.date.year && element.date.month == todoItem.date.month && element.date.day <= todoItem.date.day));
    }).toList();
    changeTodoItemList(newTodoItems);
    notifyListeners();
  }

  bool isRepeatSet(TodoItem todoItem){
    if(todoItem.repeat == "None"){
      return false;
    }
    else {
      return true;
    }
  }

  void changeTodoItemList(List<TodoItem> todoItems, {bool notify = true}) {
    _allTodoItemsList.clear();
    _allTodoItemsList.addAll(todoItems);
    if (notify) {
      notifyListeners();
    }
  }
  void deleteTodoItem(TodoItem todoItem) {
    if(todoItem.isAlarmSet)
      Noti.cancelNotification(id: todoItem.id);
    _allTodoItemsList.remove(todoItem);
    IsarService().deleteData(todoItem.id);
    notifyListeners();
  }
  void upgradeTodoItem(TodoItem oldData, TodoItem newData) {
    deleteTodoItem(oldData);
    if(oldData.isAlarmSet)
      Noti.cancelNotification(id: oldData.id);
    addTodoItem(newData);
  }

  void addTodoItem(TodoItem todoItem) async {
    if(todoItem.repeat == "Once a day"){
      DateTime newDate = todoItem.date;
      for(int i = 1; i < 2557; i++){
        newDate = newDate.add(Duration(days: todoItem.count));
        TodoItem a = TodoItem()
          ..alarm = todoItem.alarm
          ..title = todoItem.title
          ..date = newDate
          ..isDone = todoItem.isDone
          ..daysOfWeek = todoItem.daysOfWeek
          ..count = todoItem.count
          ..isAlarmSet = todoItem.isAlarmSet
          ..repeat = todoItem.repeat;
        _allTodoItemsList.add(a);
        IsarService().addData(a);
        if(a.isAlarmSet){
          int id = await IsarService().findID(a);
          Noti.showScheduledNotification(
              id: id,
              title: a.title,
              body: "Have you done this task?",
              fln: flutterLocalNotificationsPlugin,
              scheduledDate: DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                a.alarm.hour,
                a.alarm.minute,
              ));
        }
      }
      notifyListeners();
    }
    else if(todoItem.repeat == "Once in a week"){
      DateTime newDate = todoItem.date;
      for(int j = 0; j < 7; j++) {
        print(newDate.weekday);
        print(todoItem.daysOfWeek[j]);
        if(todoItem.daysOfWeek[j]) {
          print(newDate);
          print(j + 8 - newDate.weekday);
          int k = j + 1- newDate.weekday>=0 ? j + 1 - newDate.weekday : j + 8 - newDate.weekday;
          newDate = DateTime(
              newDate.year,
              newDate.month,
              newDate.day+k
          );
          print(k);
          print(j + 1- newDate.weekday>=0 ? j + 1 - newDate.weekday : j +1- newDate.weekday+7);
          print(newDate);
          print(newDate.weekday);
          for (int i = 1; i < 2557; i = i + 7) {
            TodoItem a = TodoItem()
              ..alarm = todoItem.alarm
              ..title = todoItem.title
              ..date = newDate
              ..isDone = todoItem.isDone
              ..isAlarmSet = todoItem.isAlarmSet
              ..daysOfWeek = todoItem.daysOfWeek
              ..count = todoItem.count
              ..repeat = todoItem.repeat;
            _allTodoItemsList.add(a);
            IsarService().addData(a);
            if(!a.isAlarmSet) {
              int id = await IsarService().findID(a);
              Noti.showScheduledNotification(
                  id: id,
                  title: a.title,
                  body: "Have you done this task?",
                  fln: flutterLocalNotificationsPlugin,
                  scheduledDate: DateTime(
                    newDate.year,
                    newDate.month,
                    newDate.day,
                    a.alarm.hour,
                    a.alarm.minute,
                  )
              );
            }
            newDate = newDate.add(Duration(days: 7 * todoItem.count));
          }
        }
      }
      notifyListeners();
    }
    else if(todoItem.repeat == "Once in a month"){
      DateTime newDate = todoItem.date;
      for(int i = 1; i < 2557; i = i + 30){
        newDate = DateTime(
            newDate.year,
            newDate.month + todoItem.count,
            newDate.day
        );
        TodoItem a = TodoItem()
          ..alarm = todoItem.alarm
          ..title = todoItem.title
          ..date = newDate
          ..isDone = todoItem.isDone
          ..isAlarmSet = todoItem.isAlarmSet
          ..repeat = todoItem.repeat
          ..daysOfWeek = todoItem.daysOfWeek
          ..count = todoItem.count;
        _allTodoItemsList.add(a);
        IsarService().addData(a);
        if(!a.isAlarmSet) {
          int id = await IsarService().findID(a);
          Noti.showScheduledNotification(
              id: id,
              title: a.title,
              body: "Have you done this task?",
              fln: flutterLocalNotificationsPlugin,
              scheduledDate: DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                a.alarm.hour,
                a.alarm.minute,
              )
          );
        }
      }
      notifyListeners();
    }
    else if(todoItem.repeat == "Once in a year"){
      DateTime newDate = todoItem.date;
      for(int i = 1; i < 2557; i = i + 365){
        newDate = DateTime(
            newDate.year + todoItem.count,
            newDate.month,
            newDate.day
        );
        TodoItem a = TodoItem()
          ..alarm = todoItem.alarm
          ..title = todoItem.title
          ..date = newDate
          ..isDone = todoItem.isDone
          ..isAlarmSet = todoItem.isAlarmSet
          ..daysOfWeek = todoItem.daysOfWeek
          ..count = todoItem.count
          ..repeat = todoItem.repeat;
        _allTodoItemsList.add(a);
        IsarService().addData(a);
        if(!a.isAlarmSet) {
          int id = await IsarService().findID(a);
          Noti.showScheduledNotification(
              id: id,
              title: a.title,
              body: "Have you done this task?",
              fln: flutterLocalNotificationsPlugin,
              scheduledDate: DateTime(
                newDate.year,
                newDate.month,
                newDate.day,
                a.alarm.hour,
                a.alarm.minute,
              )
          );
        }
      }
      notifyListeners();
    }
    else {
      _allTodoItemsList.add(todoItem);
      IsarService().addData(todoItem);
      int id = await IsarService().findID(todoItem);
      print(todoItem.isAlarmSet);
      if (!todoItem.isAlarmSet) {
        Noti.showScheduledNotification(
            id: id,
            title: todoItem.title,
            body: "Have you done this task?",
            fln: flutterLocalNotificationsPlugin,
            scheduledDate: DateTime(
              todoItem.date.year,
              todoItem.date.month,
              todoItem.date.day,
              todoItem.alarm.hour,
              todoItem.alarm.minute,
            )
        );
        notifyListeners();
      }
    }
  }

  bool isAlarmSet(TodoItem todoItem){
    return todoItem.isAlarmSet;
  }

  List<TodoItem> getTodoItemsByDate(DateTime date) {
    List<TodoItem> dayItems = _allTodoItemsList.where((todoItem) {
      return todoItem.date.day == date.day &&
          todoItem.date.month == date.month &&
          todoItem.date.year == date.year;
    }).toList();
    return dayItems;
  }

  void toggleIsAgenda(bool newValue) {
    _isAgenda = newValue;
    notifyListeners();
  }
}
