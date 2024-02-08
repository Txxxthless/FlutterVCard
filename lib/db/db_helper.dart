import 'package:flutter_v_card/models/contact_model.dart';
import 'package:path/path.dart' as P;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final String _createTalbeContact = '''create table $tableContact(
    $tblContactColId integer primary key autoincrement,
    $tblContactColName text,
    $tblContactColMobile text,
    $tblContactColEmail text,
    $tblContactColAddress text,
    $tblContactColCompany text,
    $tblContactColDesignation text,
    $tblContactColWebsite text,
    $tblContactColImage text,
    $tblContactColFavorite integer)''';

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = P.join(root, 'contact.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(_createTalbeContact);
      },
    );
  }

  Future<int> insertContact(ContactModel contactModel) async {
    final db = await _open();
    return db.insert(
      tableContact,
      contactModel.toMap(),
    );
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db = await _open();
    final mapList = await db.query(tableContact);
    return mapList.map((map) => ContactModel.fromMap(map)).toList();
  }

  Future<int> deleteContact(int id) async {
    final db = await _open();
    return db.delete(
      tableContact,
      where: '$tblContactColId = ?',
      whereArgs: [id],
    );
  }
}