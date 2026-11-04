import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/session.dart';

class StatsProvider extends ChangeNotifier {
  final Box<Session> _box = Hive.box<Session>('sessions');
  StatsProvider() { _box.watch().listen((_) => notifyListeners()); }
  List<Session> get all => _box.values.toList();
  int get todayMinutes {
    final now = DateTime.now();
    return all.where((s) => s.startedAt.year == now.year && s.startedAt.month == now.month && s.startedAt.day == now.day).fold(0, (a, s) => a + s.durationMinutes);
  }
  int get totalMinutes => all.fold(0, (a, s) => a + s.durationMinutes);
  int get treesPlanted => totalMinutes ~/ 30;
  void load() => notifyListeners();
}
