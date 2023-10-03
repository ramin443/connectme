import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../datamodels/user_model.dart';

class UserDatabaseHelper {
  late Database _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, bio TEXT, avatarIndex INTEGER, username TEXT)',
        );
      },
      version: 1,
    );
  }
  Future<void> insertUser(User user) async {
    print("Inserting here");
    await _database.insert(
      'users',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<User>> getAllUsers() async {
    final List<Map<String, dynamic>> userMaps = await _database.query('users',
    orderBy: "id DESC");
    return List.generate(userMaps.length, (i) {
      return User(
        name: userMaps[i]['name'] as String,
        bio: userMaps[i]['bio'] as String,
        avatarIndex: userMaps[i]['avatarIndex'] as int,
        username: userMaps[i]['username'] as String,
      );
    });
  }

  /*Future<int> updateUser(User user) async {
    return await _database.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    await _database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }*/

  Future<void> close() async {
    await _database.close();
  }
}


