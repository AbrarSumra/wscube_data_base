import 'package:wscube_data_base/AppData/app_data.dart';

class NoteModel {
  NoteModel({
    required this.user_id,
    required this.note_id,
    required this.note_title,
    required this.note_desc,
  });

  int user_id;
  int note_id;
  String note_title;
  String note_desc;

  ///fromMap --> Model
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      user_id: map[AppDataBase.COLUMN_USER_ID],
      note_id: map[AppDataBase.COLUMN_NOTE_ID],
      note_title: map[AppDataBase.COLUMN_NOTE_TITLE],
      note_desc: map[AppDataBase.COLUMN_NOTE_DESC],
    );
  }

  ///Model --> toMap
  Map<String, dynamic> toMap() {
    return {
      AppDataBase.COLUMN_USER_ID: user_id,
      AppDataBase.COLUMN_NOTE_TITLE: note_title,
      AppDataBase.COLUMN_NOTE_DESC: note_desc,
    };
  }
}
