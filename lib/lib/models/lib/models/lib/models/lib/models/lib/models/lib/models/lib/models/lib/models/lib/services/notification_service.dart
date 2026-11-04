import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _inited = false;

  static Future<void> init() async {
    if (_inited) return;
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(const InitializationSettings(android: android, iOS: ios));
    _inited = true;
  }

  static Future<void> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  static Future<void> showSessionDone() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'ingaz_sessions', 'جلسات إنجاز',
        importance: Importance.max, priority: Priority.high,
        playSound: true, enableVibration: true,
      ),
    );
    await _plugin.show(0, 'انتهت الجلسة 🎉', 'أحسنت! تم تسجيل جلسة تركيز جديدة.', details);
  }
}
