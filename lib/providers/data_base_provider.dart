import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_app/model/employee_model.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sql_app/model/todo_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'todo.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE TODO('
          'id INTEGER,'
          'userId INTEGER,'
          'title TEXT,'
          'completed TEXT)');
    });
  }

  createTodo(Todo todoModel) async {
    final db = await database;
    final res = await db.insert('TODO', todoModel.toMap());

    return res;
  }

  Future<List<TodoModel>> getTodo() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM TODO");

    List<TodoModel> list =
        res.isNotEmpty ? res.map((c) => TodoModel.fromJson(c)).toList() : [];

    return list;
  }
}
