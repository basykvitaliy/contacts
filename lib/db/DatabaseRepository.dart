import 'dart:async';
import 'dart:io';

import 'package:flutter_contacts/model/ContactModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseRepository {
  static final DatabaseRepository instance = DatabaseRepository._instance();
  static Database _db;
  DatabaseRepository._instance();

  String contactTable = "contact_table";
  String colId = "id";
  String colName = "name";
  String colNum = "num";
  String colNum2 = "num2";

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "db";
    final table = await openDatabase(path, version: 1, onCreate: _onCreate);
    return table;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $contactTable("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colName TEXT, "
        "$colNum TEXT, "
        "$colNum2 TEXT)");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(contactTable);
    return result;
  }

  Future<List<Contact>> getContactList() async {
    final List<Map<String, dynamic>> noteMapList = await getNoteMapList();
    final List<Contact> noteList = [];
    noteMapList.forEach((element) {
      noteList.add(Contact.fromMap(element));
    });
    return noteList;
  }

  Future<int> insert(Contact contact) async {
    Database db = await this.db;
    final result = await db.insert(contactTable, contact.toMap());
    print("Save");
    return result;
  }

  Future<int> update(Contact note) async {
    Database db = await this.db;
    final result = await db.update(contactTable, note.toMap(),
        where: "$colId = ?", whereArgs: [note.id]);
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.db;
    final result =
        await db.delete(contactTable, where: "$colId = ?", whereArgs: [id]);
    return result;
  }
}
