import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/subject.dart';
import '../models/schedule_slot.dart';

class ScheduleProvider extends ChangeNotifier {
  final _subjectsBox = Hive.box<Subject>('subjects');
  final _slotsBox = Hive.box<ScheduleSlot>('scheduleSlots');
  
  ScheduleProvider() {
    _subjectsBox.watch().listen((_) => notifyListeners());
    _slotsBox.watch().listen((_) => notifyListeners());
  }
  
  List<Subject> get subjects => _subjectsBox.values.toList();
  List<ScheduleSlot> get slots => _slotsBox.values.toList();
  
  List<ScheduleSlot> slotsForDay(int day) => slots.where((s) => s.dayOfWeek == day).toList()..sort((a, b) => a.startMin.compareTo(b.startMin));
  
  Future<void> addSubject(Subject s) async { await _subjectsBox.add(s); notifyListeners(); }
  Future<void> deleteSubject(Subject s) async { await s.delete(); notifyListeners(); }
  Future<void> addSlot(ScheduleSlot s) async { await _slotsBox.add(s); notifyListeners(); }
  Future<void> deleteSlot(ScheduleSlot s) async { await s.delete(); notifyListeners(); }
  void load() => notifyListeners();
}
