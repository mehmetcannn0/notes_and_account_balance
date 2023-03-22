import 'dart:io';
import 'package:flutter/services.dart';
import 'package:notes/models/category.dart';
import 'package:notes/models/kalem.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/turler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/settingsdb.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }
  DatabaseHelper.internal();
  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, "notes.db");
    bool exists = await databaseExists(path);
    if (!exists) {
      print("Assetden yeni bir kopya oluşturuluyor");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "notes.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
      addNote(Note(
          1,
          "Kullanıcıya mesaj",
          "Uygulama hakkında ki öneri ve şikayetlerinizi bana bildirmeniz beni mutlu eder mehmetceraslan@gmail.com",
          DateTime.now().toString(),
          1,
          0));
    } else {
      // await createArchiveTable();
      print("olan db acılıyor");
    }
    return await openDatabase(path, readOnly: false);
  }
/*
  void createArchiveTable() async {
    Database db = await _getDatabase();
    db.rawQuery('''CREATE TABLE [IF NOT EXISTS] "archive" (
	"id"	INTEGER NOT NULL,
	"categoryID"	INTEGER NOT NULL DEFAULT 1,
	"noteTitle"	TEXT NOT NULL,
	"context"	TEXT,
	"time"	TEXT NOT NULL DEFAULT 'CURRENT_TIMESTAMP',
	"priority"	INTEGER NOT NULL DEFAULT 1,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("categoryID") REFERENCES "category"("categoryID") ON DELETE CASCADE ON UPDATE CASCADE
);''');
    print("archive table olusturuldu");
  }*/

  Future<SettingsDb> getSettings() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> settingsMapList =
        await db.rawQuery("SELECT * FROM settings");
    return SettingsDb.fromMap(settingsMapList[0]);
  }

  Future<List<Category>> getCategoryList() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> categoryMapList = await db.query("category");
    List<Category> categoryList = [];
    for (Map map in categoryMapList) {
      categoryList.add((Category.fromMap(map)));
    }
    return categoryList;
  }

  Future<List<Turler>> getTurList() async {
    print("get tur liist içi");

    Database db = await _getDatabase();
    List<Map<String, dynamic>> turMapList = await db.query("turler");
    List<Turler> turList = [];
    print("get tur liist içi for oncesi");
    for (Map map in turMapList) {
      print("get tur list for map içi");
      turList.add((Turler.fromMap(map)));
    }
    return turList;
  }

  Future<int> addCategory(Category category) async {
    Database db = await _getDatabase();
    int sonuc = await db.insert("category", category.toMap());
    return sonuc;
  }

  Future<int> addtur(Turler turler) async {
    Database db = await _getDatabase();
    int sonuc = await db.insert("turler", turler.toMap());
    return sonuc;
  }

  Future<int> deleteCategory(int categoryID) async {
    Database db = await _getDatabase();
    await db.delete("note", where: "categoryID = ?", whereArgs: [categoryID]);
    int sonuc = await db
        .delete("category", where: "categoryID = ?", whereArgs: [categoryID]);
    return sonuc;
  }

  Future<int> deletetur(int tur) async {
    Database db = await _getDatabase();
    await db.delete("kalem", where: "tur = ?", whereArgs: [tur]);
    int sonuc = await db.delete("turler", where: "tur= ?", whereArgs: [tur]);
    return sonuc;
  }

  Future<int> updateCategory(Category category) async {
    Database db = await _getDatabase();
    int sonuc = await db.update("category", category.toMap(),
        where: "categoryID = ?", whereArgs: [category.id]);
    return sonuc;
  }

  Future<int> updateTur(Turler turler) async {
    Database db = await _getDatabase();
    int sonuc = await db.update("turler", turler.toMap(),
        where: "tur = ?", whereArgs: [turler.tur]);
    return sonuc;
  }

  String dateFormat(DateTime dt) {
    String month;
    switch (dt.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylül";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }
    return month + " " + dt.day.toString() + ", " + dt.year.toString();
  }

  Future<int> isThereAnyTodayNotes(String suan) async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> sonuc =
        await db.rawQuery("SELECT COUNT() FROM note WHERE time LIKE '$suan%';");
    // print("sonuc : " + sonuc.toString());
    return sonuc[0]["COUNT()"];
  }

  Future<int> isThereAnyKalem(String buay) async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> sonuc = await db
        .rawQuery("SELECT COUNT() FROM kalem WHERE time LIKE '$buay%';");
    ////////////////////////////////////////////////////// yıl ve ay gonderılmelı 2022-12
    // print("sonuc : " + sonuc.toString());
    return sonuc[0]["COUNT()"];
  }

  Future<int> updateSort(String sort) async {
    Database db = await _getDatabase();
    //"update settings set sort =$sort"
    return await db.rawUpdate("UPDATE settings Set sort=?", [sort]);
  }

  Future<int> updateVisibility(int visibility) async {
    Database db = await _getDatabase();
    return await db.rawUpdate("UPDATE settings Set visibility=?", [visibility]);
  }

  Future<int> addNote(Note note) async {
    Database db = await _getDatabase();
    return await db.insert("note", note.toMap());
  }

  Future addNoteAtArchive(int noteID) async {
    Database db = await _getDatabase();
    await db.rawQuery("UPDATE note SET archive=1 WHERE id == $noteID");
    // return await db.insert("archive", note.toMap());
  }

  Future<int> addKalem(Kalem kalem) async {
    Database db = await _getDatabase();
    return await db.insert("kalem", kalem.toMap());
  }

  Future updateNote(Note note) async {
    Database db = await _getDatabase();
    print(note.toMap());

    return await db
        .update("note", note.toMap(), where: "id=?", whereArgs: [note.id]);
  }

  Future<List<Note>> getSortNoteList(String suan, int archive) async {
    Database db = await _getDatabase();
    List<String> sortList = (await getSettings()).sort.split("/");
    int sortBy = int.parse(sortList[0]);
    int orderBy = int.parse(sortList[1]);

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    String query =
        "Select * From note Inner Join category on category.categoryID = note.categoryID Where archive == $archive AND time Like '$suan%' order by ";
    switch (sortBy) {
      case 0:
        query += "categoryTitle";
        break;
      case 1:
        query += "noteTitle";
        break;
      case 2:
        query += "content";
        break;
      case 3:
        query += "time";
        break;
      case 4:
        query += "priority";
        break;
    }
    if (orderBy == 0) {
      query += " ASC;";
    } else {
      query += " DESC;";
    }
    List<Map<String, dynamic>> noteMapList = await db.rawQuery(query);
    List<Note> noteList = [];
    for (Map map in noteMapList) {
      noteList.add(Note.fromMap(map));
    }
    return noteList;
  }

  Future<List<Kalem>> getSortKalemList(String selectedDayStart,
      String selectedDayEnd, int sortBy, int orderBy) async {
    Database db = await _getDatabase();
//!!!!!!Where tarih Like '$buAy%'

    String query;
    if (selectedDayEnd == null || selectedDayStart == null) {
      query = "Select * From kalem order by ";
    } else {
      query =
          "Select * From kalem where tarih >= '$selectedDayStart' AND tarih <= '$selectedDayEnd' order by ";
    }
    switch (sortBy) {
      case 0:
        query += "tur";
        break;
      case 1:
        query += "baslik";
        break;
      case 2:
        query += "miktar";
        break;
      case 3:
        query += "tarih";
        break;
    }
    if (orderBy == 0) {
      // print("asc içi"); // 1

      query += " ASC;";
    } else {
      // print("desc içi"); // 1

      query += " DESC;";
    }
    // print("query olustu \n $query"); //1

    List<Map<String, dynamic>> kalemMapList = await db.rawQuery(query);
    List<Kalem> kalemList = [];
    for (Map map in kalemMapList) {
      kalemList.add(Kalem.fromMap(map));
    }
    return kalemList;
  }

  Future<int> deleteNote(int noteID) async {
    Database db = await _getDatabase();
    return await db.delete("note", where: "id = ? ", whereArgs: [noteID]);
  }

  Future<int> deleteKalem(int kalemID) async {
    Database db = await _getDatabase();
    return await db.delete("kalem", where: "id = ? ", whereArgs: [kalemID]);
  }

  Future deleteNoteAtArchive(int noteID) async {
    Database db = await _getDatabase();
    //    // return await db.rawUpdate("UPDATE settings Set sort=?", [sort]);
    // return await db.update("note", where: "id = ? ", whereArgs: [noteID]);
    //////UPDATE personel SET bolum='Veri Güvenliği' WHERE bolum='Bilgi İşlem'
// "note", note.toMap(), where: "id=?", whereArgs: [note.id]
    // return
    await db.rawQuery("UPDATE note SET archive=0 WHERE id == $noteID");
//
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  }

  Future<List<Note>> getNoteList(int archive) async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> noteMaplist = await db.rawQuery(
        "Select * From note Inner Join category on category.categoryID = note.categoryID Where archive == $archive Order By id Asc;");
    List<Note> noteList = [];
    for (Map map in noteMaplist) {
      noteList.add(Note.fromMap(map));
    }
    return noteList;
  }

  Future<List<Kalem>> getKalemList() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> kalemMaplist = await db.rawQuery(
        "Select * From kalem Inner Join turler on turler.tur = kalem.tur Order By tarih Desc;");
    List<Kalem> kalemList = [];
    for (Map map in kalemMaplist) {
      // print("db içi print ${map["tarih"]}");
      kalemList.add(Kalem.fromMap(map));
    }
    return kalemList;
  }

  Future<List<Note>> getSearchNoteList(String search) async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> noteMapList = await db.rawQuery(
        "Select * From note Inner Join category on category.categoryID =note.categoryID Where note.noteTitle Like '%$search%' Or note.content Like '%$search%' Or note.time Like '%$search%' Order By id Desc;");
    List<Note> noteList = [];
    for (Map map in noteMapList) {
      noteList.add(Note.fromMap(map));
    }
    return noteList;
  }

  Future<int> updatePassword(String newPassword) async {
    Database db = await _getDatabase();
    return await db.rawUpdate("Update settings Set password =?", [newPassword]);
  }

  Future<int> updateTheme(String newTheme) async {
    Database db = await _getDatabase();
    return await db.rawUpdate("Update settings Set theme = ? ", [newTheme]);
  }

  Future<int> lenghtAllNotes() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> sonuc =
        await db.rawQuery("Select Count() From note Where archive == 0;");
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    return sonuc[0]["Count()"];
  }

  Future<int> lenghtAllKalem() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> sonuc =
        await db.rawQuery("Select Count() From kalem ;");
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    return sonuc[0]["Count()"];
  }

  Future<int> lenghtCategoryNotes(int categoryID) async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> sonuc = await db.rawQuery(
        "Select Count() From note Where categoryID == $categoryID AND archive == 0 ;");
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //burada "= ?",["categoryID"]   yapabılırdık kı zaten guvenlık ıcın boyle olması gerek ama bız bu degerı kullanıcıdan degılde sıstemden aldıgımız ıcın gerek gormedık
    return sonuc[0]["Count()"];
  }

  Future<List<Note>> getCategoryNotesList(int categoryID, int archive) async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> noteMaplist = await db.rawQuery(
        "Select * From note Inner Join category on category.categoryID = note.categoryID Where note.categoryID = $categoryID AND archive==$archive Order By id Desc;");
    List<Note> noteList = [];
    for (Map map in noteMaplist) {
      noteList.add(Note.fromMap(map));
    }
    return noteList;
  }

  Future<List<Note>> getNote(int noteID) async {
    Database db = await _getDatabase();

    List<Map<String, dynamic>> noteMaplist = await db.rawQuery(
      "Select * From note Inner Join category on category.categoryID = note.categoryID Where id ==$noteID;",
    );
    print(
        "arşivlenmek istenilen note1 : \n " + noteMaplist.toString() + "\n \n");

    List<Note> noteList = [];
    for (Map map in noteMaplist) {
      noteList.add(Note.fromMap(map));
    }
    print("arşivlenmek istenilen note2 : \n " + noteList.toString() + "\n \n");
    return noteList;
  }

  Future<int> lenghtAllNotesAtArchive() async {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> sonuc =
        await db.rawQuery("Select Count() From note Where archive == 1;");
    return sonuc[0]["Count()"];
  }
}
