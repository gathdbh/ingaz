import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class Plant extends HiveObject {
  @HiveField(0) int type;
  @HiveField(1) DateTime plantedAt;
  @HiveField(2) int slot;

  Plant({required this.type, required this.plantedAt, required this.slot});
}

class PlantAdapter extends TypeAdapter<Plant> {
  @override final int typeId = 4;
  @override
  Plant read(BinaryReader r) => Plant(
        type: r.readInt(),
        plantedAt: DateTime.fromMillisecondsSinceEpoch(r.readInt()),
        slot: r.readInt(),
      );
  @override
  void write(BinaryWriter w, Plant o) {
    w.writeInt(o.type);
    w.writeInt(o.plantedAt.millisecondsSinceEpoch);
    w.writeInt(o.slot);
  }
}
