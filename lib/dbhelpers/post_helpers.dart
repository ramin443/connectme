import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../datamodels/textPost_Model.dart';
class DatabaseHelper {
  late Database _database;

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final pathToDatabase = path.join(dbPath, 'text_post.db');

    _database = await openDatabase(
      pathToDatabase,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE text_posts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            userFullName TEXT,
            userAvatar INTEGER,
            datetime TEXT,
            postText TEXT,
            likeCount INTEGER,
            commentCount INTEGER,
            shareCount INTEGER
          )
          ''',
        );
      },
    );
  }

  Future<void> insertTextPost(TextPost textPost) async {
    print("Inserting here");
    await _database.insert(
      'text_posts',
      {
        'username': textPost.username,
        'userFullName': textPost.userFullName,
        'userAvatar': textPost.userAvatar,
        'datetime': textPost.datetime,
        'postText': textPost.postText,
        'likeCount': textPost.likeCount,
        'commentCount': textPost.commentCount,
        'shareCount': textPost.shareCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  void deleteData(TextPost textPost)async{
    await _database.delete(
      'text_posts',
      where: 'postText = ? AND datetime = ?', // Replace with your column names
      whereArgs: [textPost.postText, textPost.datetime], // Replace with your values
    );

  }
  Future<List<TextPost>> getAllTextPosts() async {
    await initDatabase();
    final List<Map<String, dynamic>> postMaps = await _database.query('text_posts',
      orderBy: 'datetime DESC',

    );
    return List.generate(postMaps.length, (index) {
      return TextPost.fromJson(postMaps[index]);
    });
  }



}
