import 'dart:io';

import 'package:expense_tracker/model/incomeexpense.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? database;
  final String DB_NAME = "dbname";
  final String db_table = "mytable";

  Future<Database?> checkdb() async {
    if (database != null) {
      return database;
    } else {
      return await initdb();
    }
  }

  Future<Database?> initdb() async {
    Directory dr = await getApplicationDocumentsDirectory();
    String path = join(dr.path, DB_NAME);
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        return await db.execute(
            'CREATE TABLE $db_table(id INTEGER PRIMARY KEY AUTOINCREMENT,note TEXT,cate TEXT,amount TEXT,date TEXT,time TEXT,status INTEGER)');
      },
    );
    return database;
  }

  Future<int> insertData(IncomeExpenseModel model) async {
    await checkdb();
    return await database!.insert('$db_table', {
      'cate': model.cate,
      'note': model.note,
      'status': model.status,
      'amount': model.amount,
      'date': model.date,
      'time': model.time
    });
  }

  Future<List<Map>> readData() async {
    database = await checkdb();
    String query = 'SELECT * FROM $db_table';
    List<Map> list = await database!.rawQuery(query);
    return list;
  }

  Future<void> deleteData(int id) async {
    database = await checkdb();
    database!.delete(db_table, where: "id=?", whereArgs: [id]);
  }

  Future<int> updateData(IncomeExpenseModel model,int id) async {
    await checkdb();
    return await database!.update(
        db_table,
        {
          'cate': model.cate,
          'note': model.note,
          'status': model.status,
          'amount': model.amount,
          'date': model.date,
          'time': model.time
        },
        where: "id=?",
        whereArgs: [id]);
  }
}
