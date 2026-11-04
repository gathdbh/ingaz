import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class Note extends HiveObject {
  @HiveField(0) String text;
  @HiveField(1) DateTime createdAt;
  @HiveField(2) bool isDone;

  Note({required this.text, DateTime? createdAt, this.isDone = false})
      : createdAt = createdAt ?? DateTime.now();
}

class NoteAdapter extends TypeAdapter<Note> {
  @override final int typeId = 5;
  @override
  Note read(BinaryReader r) => Note(
        text: r.readString(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()),
        isDone: r.readBool(),
      );
  @override
  void write(BinaryWriter w, Note o) {
    w.writeString(o.text);
    w.writeInt(o.createdAt.millisecondsSinceEpoch);
    w.writeBool(o.isDone);
  }
}
