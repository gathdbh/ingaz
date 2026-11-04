import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/session.dart';
import '../services/notification_service.dart';

enum TimerMode { down, pomodoro }
enum TimerStatus { idle, running, paused }

class TimerProvider extends ChangeNotifier {
  TimerProvider() { _tick = Timer.periodic(const Duration(seconds: 1), (_) => _onTick()); }
  late final Timer _tick;
  TimerMode mode = TimerMode.down;
  TimerStatus status = TimerStatus.idle;
  int _setMinutes = 25;
  int elapsedSeconds = 0;

  int get setMinutes => _setMinutes;
  int get totalSeconds => _setMinutes * 60;
  int get remainingSeconds => (totalSeconds - elapsedSeconds).clamp(0, totalSeconds);

  void setMode(TimerMode m) { mode = m; if (m == TimerMode.pomodoro) _setMinutes = 25; reset(); }
  void setMinutes(int m) { _setMinutes = m; reset(); }
  void start() { if (status != TimerStatus.running) { status = TimerStatus.running; notifyListeners(); } }
  void pause() { status = TimerStatus.paused; notifyListeners(); }
  void reset() { status = TimerStatus.idle; elapsedSeconds = 0; notifyListeners(); }

  void _onTick() {
    if (status != TimerStatus.running) return;
    elapsedSeconds++;
    if (elapsedSeconds >= totalSeconds) { _finishSession(); return; }
    notifyListeners();
  }

  Future<void> _finishSession() async {
    status = TimerStatus.idle;
    final minutes = (elapsedSeconds / 60).floor();
    if (minutes > 0) {
      final box = Hive.box<Session>('sessions');
      await box.add(Session(startedAt: DateTime.now(), durationMinutes: minutes));
      await NotificationService.showSessionDone();
    }
    elapsedSeconds = 0;
    notifyListeners();
  }
  @override void dispose() { _tick.cancel(); super.dispose(); }
}
