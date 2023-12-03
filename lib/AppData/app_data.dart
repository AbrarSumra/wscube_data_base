import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wscube_data_base/model/note_model.dart';
import 'package:wscube_data_base/model/user_model.dart';

class AppDataBase {
  //private constructor (Singleton)

  AppDataBase._();

  static final AppDataBase instance = AppDataBase._();

  Database? myDB;

  /// Login Uid
  static final String LOGIN_UID = "uid";

  ///table
  static const String NOTE_TABLE = "notes";
  static const String USER_TABLE = "users";

  /// User Column
  static const String COLUMN_USER_ID = "uId";
  static const String COLUMN_USER_NAME = "uName";
  static const String COLUMN_USER_EMAIL = "uEmail";
  static const String COLUMN_USER_PASS = "uPass";

  ///column
  static const String COLUMN_NOTE_ID = "noteId";
  static const String COLUMN_NOTE_TITLE = "title";
  static const String COLUMN_NOTE_DESC = "desc";

  Future<Database> initDB() async {
    var docDirectory = await getApplicationDocumentsDirectory();

    var dbPath = join(docDirectory.path, "noteDb.db");

    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(
          "create table $USER_TABLE ( $COLUMN_USER_ID integer primary key autoincrement, $COLUMN_USER_NAME text, $COLUMN_USER_EMAIL text, $COLUMN_USER_PASS text )");

      ///create all your tables here
      db.execute(
          "create table $NOTE_TABLE ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_USER_ID integer, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text )");
    });
  }

  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await initDB();
      return myDB!;
    }
  }

  Future<List<NoteModel>> fetchNotes(int uid) async {
    var db = await getDB();
    List<NoteModel> arrNotes = [];

    var data = await db
        .query(NOTE_TABLE, where: "$COLUMN_USER_ID = ?", whereArgs: ["$uid"]);

    for (Map<String, dynamic> eachNote in data) {
      var noteModel = NoteModel.fromMap(eachNote);
      arrNotes.add(noteModel);
    }

    return arrNotes;
  }

  /// ADD Note
  void addNote(NoteModel newNote) async {
    var db = await getDB();

    db.insert(NOTE_TABLE, newNote.toMap());
  }

  /// UPDATE Note
  void updateNote(NoteModel updatedNote) async {
    var db = await getDB();

    /// Method 1
    db.update(
      NOTE_TABLE,
      updatedNote.toMap(),
      where: "$COLUMN_NOTE_ID = ? ",
      whereArgs: ["${updatedNote.note_id}"],
    );

    /// Method 2
    /*db.update(
      NOTE_TABLE,
      updatedNote.toMap(),
      where: "$COLUMN_NOTE_ID = ${updatedNote.note_id} ",
    );*/
  }

  ///DELETE Note
  void deleteNote(int id) async {
    var db = await getDB();

    db.delete(NOTE_TABLE, where: "$COLUMN_NOTE_ID = $id");
  }

  Future<bool> createAccount(UserModel newUser) async {
    var check = await checkIfUserAlreadyExists(newUser.user_email);

    if (!check) {
      var db = await getDB();
      db.insert(USER_TABLE, newUser.toMap());
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfUserAlreadyExists(String email) async {
    var db = await getDB();

    var data = await db
        .query(USER_TABLE, where: "$COLUMN_USER_EMAIL = ?", whereArgs: [email]);

    return data.isNotEmpty;
  }

  Future<bool> authenticate(String email, String pass) async {
    var db = await getDB();

    var data = await db.query(USER_TABLE,
        where: "$COLUMN_USER_EMAIL = ? and $COLUMN_USER_PASS = ?",
        whereArgs: [email, pass]);

    if (data.isNotEmpty) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setInt(LOGIN_UID, UserModel.fromMap(data[0]).user_id);
    }

    return data.isNotEmpty;
  }
}
