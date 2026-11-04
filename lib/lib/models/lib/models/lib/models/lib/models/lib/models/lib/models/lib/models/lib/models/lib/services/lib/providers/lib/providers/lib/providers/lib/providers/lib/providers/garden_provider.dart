import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/plant.dart';
import '../models/session.dart';

class GardenProvider extends ChangeNotifier {
  final _plants = Hive.box<Plant>('plants');
  final _sessions = Hive.box<Session>('sessions');
  int _lastPlantThreshold = 0;

  GardenProvider() { _sessions.watch().listen((_) => _checkNewPlant()); }
  List<Plant> get plants => _plants.values.toList()..sort((a, b) => b.plantedAt.compareTo(a.plantedAt));
  int get totalMinutes => _sessions.values.fold(0, (a, s) => a + s.durationMinutes);

  Future<void> _checkNewPlant() async {
    final threshold = totalMinutes ~/ 30;
    if (threshold <= _lastPlantThreshold) { _lastPlantThreshold = threshold; return; }
    while (_lastPlantThreshold < threshold) {
      _lastPlantThreshold++;
      await _plants.add(Plant(type: 0, plantedAt: DateTime.now(), slot: _plants.length));
    }
    notifyListeners();
  }
  void load() { _lastPlantThreshold = totalMinutes ~/ 30; notifyListeners(); }
  Future<void> reset() async { await _plants.clear(); _lastPlantThreshold = 0; notifyListeners(); }
}
