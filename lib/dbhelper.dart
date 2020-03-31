import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'todo_model.dart';

final String TableName = 'Todos';

class DBHelper {
  //singletone createor
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    //path 패키지의 join 함수를 사용하는 것이
    //각 플랫폼 별 경로가 제대로 생성되도록 보장할 수 있는 가장 좋은 방법이다.
    String path = join(await getDatabasesPath(), 'MyTodos.db');
    //db 생성
    return await openDatabase(path, version: 8, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $TableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT,
            checked INTEGER DEFAULT 0,
            delkey INTEGER DEFAULT 0
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < newVersion) {
        db.execute(
            '''ALTER TABLE $TableName ADD COLUMN delkey INTEGER DEFAULT 0''');
      }
    });
  }

//  void alterTable() async {
//    final db = await database;
//    await db.execute(
//        '''ALTER TABLE $TableName ADD COLUMN delkey INTEGER DEFAULT 0''');
//    debugPrint('alter!!!!');
//  }

  //Create
  createData(String content) async {
    final db = await database;

    var res = await db
        .rawInsert('INSERT INTO $TableName(content) VALUES(?)', [content]);
    return res;
  }

  //Read
  getTodos(int id) async {
    final db = await database;

    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    if (res.isNotEmpty)
      debugPrint(Todos().content);
    else
      debugPrint('There is no content');
    return res.isNotEmpty
        ? Todos(
            id: res.first['id'],
            content: res.first['content'],
            checked: res.first['checked'],
            delkey: res.first['delkey'])
        : Null;
  }

  //Read All
  Future<List<Todos>> getAllTodos() async {
    final db = await database;

    var res = await db.rawQuery('SELECT * FROM $TableName');
    // select 문의 결과가 비어있는지 체크 후 List로 변환
    if (res.isNotEmpty)
      debugPrint('There is some content');
    else
      debugPrint('There is no content');
    List<Todos> list = res.isNotEmpty
        ? res
            .map((c) => Todos(
                id: c['id'],
                content: c['content'],
                checked: c['checked'],
                delkey: c['delkey']))
            .toList()
        : [];
    return list;
  }

  Future<int> getCheck() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE delkey = 0');
    if (res.isNotEmpty)
      debugPrint('There is some content');
    else
      debugPrint('There is no content');
    int result = res.isNotEmpty ? 1 : 0;
    return result;
  }

  //Update
  updateTodos(Todos todos) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE $TableName SET content = ?, checked = ?,delkey=? WHERE id = ?',
        [todos.content, todos.checked, todos.delkey, todos.id]);
    return res;
  }

  //Update all
  updateAllDel(int del) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE $TableName SET delkey=? WHERE id IS NOT NULL', [del]);
    return res;
  }

  //Delete
  deleteTodos(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

  //Delete
  deleteList() async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE delkey=1');
    return res;
  }

  //Delete All
  deleteAllTodos() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
    var res = db.rawUpdate(
        'UPDATE SQLITE_SEQUENCE SET seq = 0 WHERE name = \'$TableName\'');
  }
}
