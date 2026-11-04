import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Subject extends HiveObject {
  @HiveField(0) String name;
  @HiveField(1) int colorIndex;

  Subject({required this.name, required this.colorIndex});
}

class SubjectAdapter extends TypeAdapter<Subject> {
  @override final int typeId = 2;
  @override
  Subject read(BinaryReader r) => Subject(name: r.readString(), colorIndex: r.readInt());
  @override
  void write(BinaryWriter w, Subject o) {
    w.writeString(o.name);
    w.writeInt(o.colorIndex);
  }
}
