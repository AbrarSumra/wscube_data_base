import 'package:wscube_data_base/AppData/app_data.dart';

class NoteModel {
  NoteModel({
    required this.notex_id,
    required this.note_title,
    required this.note_desc,
  });

  int notex_id;
  String note_title;
  String note_desc;

  ///fromMap --> Model
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      notex_id: map[AppDataBase.COLUMN_NOTE_ID],
      note_title: map[AppDataBase.COLUMN_NOTE_TITLE],
      note_desc: map[AppDataBase.COLUMN_NOTE_DESC],
    );
  }

  ///Model --> toMap
  Map<String, dynamic> toMap() {
    return {
      AppDataBase.COLUMN_NOTE_TITLE: note_title,
      AppDataBase.COLUMN_NOTE_DESC: note_desc,
    };
  }
}
