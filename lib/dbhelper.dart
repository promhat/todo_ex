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
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $TableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            content TEXT,
            checked INTEGER DEFAULT 0
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

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
            checked: res.first['checked'])
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
                id: c['id'], content: c['content'], checked: c['checked']))
            .toList()
        : [];
    return list;
  }

  //Update
  updateTodos(Todos todos) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE $TableName SET content = ?, checked = ? WHERE id = ?',
        [todos.content, todos.checked, todos.id]);
    return res;
  }

  //Delete
  deleteTodos(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
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
