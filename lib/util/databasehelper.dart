import 'package:notekeeper/model/notes.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';



class DatabaseHelper {
  var tableName='notes';
  var colId = 'id';
  var colTitle = 'title';
  var colDescription = 'description';
  var colDate = 'date';
  var colPriority = 'priority';



  Future<Database> _getDatabase() async {
    var path= join(await getDatabasesPath(),'note_record.db');
    Database database = await openDatabase(
      path,
      onCreate:(db,version){
        _createDatabase(db, version);
      },
      version: 1
    );
    return database;
  }

  _createDatabase(Database db, int version){
    return db.execute(
        'CREATE TABLE $tableName('
            '$colId INTEGER PRIMARY KEY AUTOINCREMENT '
            ',$colTitle TEXT'
            ',$colDate TEXT'
            ',$colPriority INTEGER'
            ',$colDescription TEXT)'
    );
  }

  Future<List<Note>> getNoteData() async {
    final Database db = await _getDatabase();
    final List<Map<String,dynamic>> maps = await db.query(tableName);
    return List.generate(
        maps.length, (index){
        return Note.fromId(
          id: maps[index][colId],
          title:maps[index][colTitle],
          date: maps[index][colDate],
          priority:maps[index][colPriority],
          description: maps[index][colDescription]
        );
      }
    );
  }

  Future<void> insertNoteData(Note note) async {
    final Database  db = await _getDatabase();
    await db.insert(
        tableName, note.toMap() ,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<void> deleteNoteData(int id ) async {
    final db = await _getDatabase();
    await db.rawDelete('DELETE FROM $tableName WHERE id=$id');
  }
}