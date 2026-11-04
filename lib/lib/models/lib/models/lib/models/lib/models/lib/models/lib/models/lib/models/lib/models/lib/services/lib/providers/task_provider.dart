import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final Box<Task> _box = Hive.box<Task>('tasks');
  List<Task> get tasks => _box.values.toList().reversed.toList();
  void load() => notifyListeners();
  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    await _box.add(Task(title: title.trim()));
    notifyListeners();
  }
  Future<void> toggle(Task t) async { t.isDone = !t.isDone; await t.save(); notifyListeners(); }
  Future<void> delete(Task t) async { await t.delete(); notifyListeners(); }
}
