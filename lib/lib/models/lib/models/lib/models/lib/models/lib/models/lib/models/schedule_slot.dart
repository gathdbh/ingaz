import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class ScheduleSlot extends HiveObject {
  @HiveField(0) int dayOfWeek;
  @HiveField(1) int startMin;
  @HiveField(2) int endMin;
  @HiveField(3) String subjectName;
  @HiveField(4) int colorIndex;

  ScheduleSlot({
    required this.dayOfWeek,
    required this.startMin,
    required this.endMin,
    this.subjectName = '',
    this.colorIndex = 0,
  });
}

class ScheduleSlotAdapter extends TypeAdapter<ScheduleSlot> {
  @override final int typeId = 3;
  @override
  ScheduleSlot read(BinaryReader r) => ScheduleSlot(
        dayOfWeek: r.readInt(),
        startMin: r.readInt(),
        endMin: r.readInt(),
        subjectName: r.readString(),
        colorIndex: r.readInt(),
      );
  @override
  void write(BinaryWriter w, ScheduleSlot o) {
    w.writeInt(o.dayOfWeek);
    w.writeInt(o.startMin);
    w.writeInt(o.endMin);
    w.writeString(o.subjectName);
    w.writeInt(o.colorIndex);
  }
}
