import 'dart:async';
import 'dart:io';
import 'package:add_fihirana/model/hira.dart';
import 'package:add_fihirana/model/history.dart';
import 'package:add_fihirana/model/settings.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  initDb() async {
    // Construct a file path to copy database to
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "addfihirana.db");

// Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'addfihirana.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'addfihirana.db');
    var theDb = await openDatabase(databasePath);
    return theDb;
  }

  // ###### query settings #######
  Future<List<Settings>> getSettings() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM settings');
    List<Settings> settings = new List();
    for (int i = 0; i < list.length; i++) {
      settings.add(new Settings(list[i]["_id"], list[i]["modeSombre"], list[i]["fontSize"], list[i]["theme"]));
    }
    print('totalin ny settings rehetra ${settings.length}');
    return settings;
  }

  Future<int> updateModeSombre(int modeSombre) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("UPDATE settings SET modeSombre = $modeSombre WHERE _id = 0");
    if (result.length == 0) return null;
    return result.first as int;

  }

  Future<int> updateFontSize(double fontSize) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("UPDATE settings SET fontSize = $fontSize WHERE _id = 0");
    if (result.length == 0) return null;
    return result.first as int;

  }

  Future<int> updateTheme(String theme) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("UPDATE settings SET theme = '$theme'  WHERE _id = 0");
    if (result.length == 0) return null;
    return result.first as int;

  }


  // ###### query songs #######
  Future<List<Hira>> getSongs() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM table_hira');
    List<Hira> song = new List();
    for (int i = 0; i < list.length; i++) {
      song.add(new Hira(list[i]["_id"], list[i]["namelist"], list[i]["page"], list[i]["title"], list[i]["content"], list[i]["favoris"], list[i]["dateUpdate"]));
    }
    print('totalin ny hira rehetra ${song.length}');
    return song;
  }

  Future<List<Hira>> getCategorySongs(String category) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery("SELECT * FROM table_hira WHERE namelist = '$category'");
    List<Hira> song = new List();
    for (int i = 0; i < list.length; i++) {
      song.add(new Hira(list[i]["_id"], list[i]["namelist"], list[i]["page"], list[i]["title"], list[i]["content"], list[i]["favoris"], list[i]["dateUpdate"]));
    }
    print('totalin ny hira rehetra ${song.length}');
    return song;
  }

  Future<List<String>> getTitleSongs() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM table_hira');
    List<String> song = new List();
    for (int i = 0; i < list.length; i++) {
      song.add(list[i]["title"]);
    }
    // print('totalin ny hira titre ${song}');
    return song;
  }

  // ###### query history #######
  Future<List<History>> getHistory() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM history ORDER BY _id DESC');
    List<History> history = new List();
    for (int i = 0; i < list.length; i++) {
      history.add(new History(list[i]["_id"], list[i]["title"], list[i]["id_table_hira"], list[i]["date"]));
    }
    print('history rehetra ${history.length}');
    return history;
  }
  
  setHistory(History history) async {

    var dbClient = await db;
    int res = await dbClient.insert("history", history.toMap());
    // var result = await dbClient.rawQuery("INSERT history (_id, title, id_table_hira, date) VALUES ('', $history, $idHira, datetime('now'))");
    print(res);
    return res;
  }

  //deletion
  Future<int> deleteHistory(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("DELETE FROM history WHERE _id = $id");
    if (result.length == 0) return null;
    return result.first as int;
  }

  Future<int> deleteAllHistory() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("DELETE FROM history WHERE _id > 0");
    if (result.length == 0) return null;
    return result.first as int;
  }

  // ###### query favoris #######

  Future<int> setFavoris(int id, int favoris, String dateUpdate) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("UPDATE table_hira SET favoris = $favoris, dateUpdate = '$dateUpdate'  WHERE _id = $id");
    if (result.length == 0) return null;
    return result.first as int;

  }

  Future<int> deleteAllFavoris() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("UPDATE table_hira SET favoris = null WHERE favoris = 1");
    if (result.length == 0) return null;
    return result.first as int;
  }

  Future<List<Hira>> getFavoris() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM table_hira WHERE favoris = 1 ORDER BY dateUpdate DESC');
    List<Hira> favoris = new List();
    for (int i = 0; i < list.length; i++) {
      favoris.add(new Hira(list[i]["_id"], list[i]["namelist"], list[i]["page"], list[i]["title"], list[i]["content"], list[i]["favoris"], list[i]["dateUpdate"]));
    }
    print('favoris rehetra ${favoris.length}');
    return favoris;
  }


  

}
