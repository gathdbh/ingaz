import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0) String title;
  @HiveField(1) bool isDone;
  @HiveField(2) DateTime createdAt;

  Task({required this.title, this.isDone = false, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
}

class TaskAdapter extends TypeAdapter<Task> {
  @override final int typeId = 0;
  @override
  Task read(BinaryReader reader) => Task(
        title: reader.readString(),
        isDone: reader.readBool(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      );
  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeString(obj.title);
    writer.writeBool(obj.isDone);
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}
