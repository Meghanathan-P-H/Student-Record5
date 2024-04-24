import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login_sample/stdmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

ValueNotifier<List<Students>> studentListNotifier = ValueNotifier([]);
late Database _db;

Future<void> initializeDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  log(documentsDirectory.uri.toString());
  String path = join(documentsDirectory.path, "student.db");
  _db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      db.execute('''
    CREATE TABLE $studentsTable (
      ${StudentsFields.id} INTEGER PRIMARY KEY AUTOINCREMENT ,
      ${StudentsFields.name} TEXT,
      ${StudentsFields.age} INTEGER NOT NULL,
      ${StudentsFields.email} TEXT,
      ${StudentsFields.domain} TEXT,
      ${StudentsFields.image} TEXT
    )
  ''');
    },
  );
}

Future<void> addStudents(Students student, BuildContext ctx) async {
  await _db.rawInsert(
      'INSERT INTO $studentsTable (${StudentsFields.name},${StudentsFields.age},${StudentsFields.email},${StudentsFields.domain},${StudentsFields.image}) VALUES (?,?,?,?,?)',
      [
        student.name,
        student.age,
        student.email,
        student.domain,
        student.image
      ]);
  studentListNotifier.value.add(student);
  studentListNotifier.notifyListeners();
}

Future<void> getAllStudent() async {
  final result = await _db.rawQuery('SELECT * FROM $studentsTable');
  List<Students> studentsList =
      result.map((row) => Students.fromMap(row)).toList();
  studentListNotifier.value = studentsList;
  studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(int id) async {
  // Students student =
  //     studentListNotifier.value.firstWhere((element) => element.id == id);
  // studentListNotifier.value.remove(student);
  await _db.delete(studentsTable, where: 'id = ?', whereArgs: [id]);
  // await _db.rawDelete('DELETE FROM $studentsTable WHERE id = ?', [id]);

  await getAllStudent();
  // studentListNotifier.notifyListeners();
}

Future<void> updateStudent(int id, String name, String email, String domain,
    String image, int age) async {
  await _db.rawUpdate(
      'UPDATE $studentsTable SET ${StudentsFields.name} = ?, ${StudentsFields.age} = ? , ${StudentsFields.email} = ?, ${StudentsFields.domain} =?, ${StudentsFields.image} =? WHERE ${StudentsFields.id} = ?',
      [
        name,
        age,
        email,
        domain,
        image,
        id,
      ]);

  getAllStudent();
}
