import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'violator.dart';

class DBHelper {
  static Future<Database> initDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'covid_protocols_surveillance.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    const sql = '''CREATE TABLE violators(
      id INTEGER PRIMARY KEY,
      name TEXT,
      mobileNumber TEXT
    )''';

    await db.execute(sql);
  }

  static Future<int> reportViolator(Violator details) async {
    Database db = await DBHelper.initDB();

    return await db.insert('violators', details.toJson());
  }

  static Future<List<Violator>> readViolator() async {
    Database db = await DBHelper.initDB();
    var violator = await db.query('violators', orderBy: 'name');

    List<Violator> violatorList = violator.isNotEmpty
        ? violator.map((details) => Violator.fromJson(details)).toList()
        : [];

    return violatorList;
  }

  static Future<int> updateViolator(Violator details) async {
    Database db = await DBHelper.initDB();

    return await db.update('violators', details.toJson(),
        where: 'id = ?', whereArgs: [details.id]);
  }

  static Future<int> deleteViolator(int id) async {
    Database db = await DBHelper.initDB();

    return await db.delete('violators', where: 'id = ?', whereArgs: [id]);
  }
}
