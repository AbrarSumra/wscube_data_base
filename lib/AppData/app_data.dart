import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wscube_data_base/model/note_model.dart';

class AppDataBase {
  //private constructor (Singleton)
  AppDataBase._();

  static final AppDataBase instance = AppDataBase._();

  ///table
  static const String NOTE_TABLE = "notes";

  ///column
  static const String COLUMN_NOTE_ID = "noteId";
  static const String COLUMN_NOTE_TITLE = "title";
  static const String COLUMN_NOTE_DESC = "desc";

  Database? myDB;

  Future<Database> initDB() async {
    var docDirectory = await getApplicationDocumentsDirectory();

    var dbPath = join(docDirectory.path, "noteDb.db");

    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      //create all your tables here

      db.execute(
          "create table $NOTE_TABLE ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text )");
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

  void addNote(NoteModel newNote) async {
    var db = await getDB();

    db.insert(NOTE_TABLE, newNote.toMap());
  }

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

  void deleteNote(int id) async {
    var db = await getDB();

    db.delete(NOTE_TABLE, where: "$COLUMN_NOTE_ID = $id");
  }

  Future<List<NoteModel>> fetchNotes() async {
    var db = await getDB();
    List<NoteModel> arrNotes = [];

    var data = await db.query(NOTE_TABLE);

    for (Map<String, dynamic> eachNote in data) {
      var noteModel = NoteModel.fromMap(eachNote);
      arrNotes.add(noteModel);
    }

    return arrNotes;
  }
}
