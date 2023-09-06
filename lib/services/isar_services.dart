import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/database.dart';

class IsarService {
  static late Future<Isar> db;
  IsarService() {
    db = openDB();
  }
  Future<void> addData(TodoItem newData) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.todoItems.putSync(newData));
  }

  Future<void> deleteData(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.todoItems.delete(id);
    });
  }
  Future<void> deleteItemsByObjects(List<TodoItem> items) async {
    final isar = await db;
    for (var item in items) {
      await isar.writeTxn(() async {
        await isar.todoItems.delete(item.id);
      });
    }
  }
  Future<int> findID(TodoItem todoItem) async {
    final isar = await db;
    return isar.todoItems.where().filter().dateEqualTo(todoItem.date).titleEqualTo(todoItem.title).findFirstSync()!.id;
  }

  Future<void> upgradeTodoItem(TodoItem newTodoItem, bool isDone) async {
    final isar = await db;
    //TodoItem? x = isar.todoItems.where().filter().idEqualTo(todoItem.id).findFirstSync();
    final todoItems = isar.todoItems;
    await isar.writeTxn(() async {
      final todoItem = await todoItems.where().idEqualTo(newTodoItem.id).findFirst();
      if (todoItem != null) {
        todoItem.isDone = isDone;
        await todoItems.put(todoItem);
      }
    });
  }

  Future<List<TodoItem>> findAndDelete(String title) async {
    final isar = await db;
    return isar.todoItems.where().filter().titleEqualTo(title).findAll();
  }
  Future<List<TodoItem>> findAndDelete2(String title, DateTime date) async {
    final isar = await db;
    return isar.todoItems.where().filter().titleEqualTo(title).dateGreaterThan(date).findAll();
  }
  Future<List<TodoItem>> getAllItems()async{
    final isar = await db;
    return await isar.todoItems.where().findAll();
  }

  static Future<List<TodoItem>> getAll(Isar isar) async {
    return await isar.todoItems.where().findAll();
  } /*
  Stream<List<Database>> listenToCourses() async* {
    final isar = await db;
    yield* isar.databases.where().watchLazy();
  }*/

  Stream<List<TodoItem>> listenDatabase() async* {
    final isar = await db;
    final query = isar.todoItems.where().build();

    // Perform an initial fetch and emit the current list of databases.
    final initialDatabases = await query.findAll();
    yield initialDatabases;

    // Then start watching for updates and emit the new list of databases each time.
    await for (final _ in query.watchLazy()) {
      final databases = await query.findAll();
      yield databases;
    }
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  static Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TodoItemSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
/*
  Stream<List<Database>> watchAllCourses() async* {
    final query = Isar.instance.courseDao.where().build();
    final snapshot = query.watchLazy();
    await for (final _ in snapshot) {
      final databases = await query.findAll();
      yield databases;
    }
  }
*/
/*
Future<Isar> openDB() async {
  if (Isar.instanceNames.isEmpty) {
    return await Isar.open(
      [CourseSchema, StudentSchema, TeacherSchema],
      inspector: true,
    );
  }

  return Future.value(Isar.getInstance());
}*/
