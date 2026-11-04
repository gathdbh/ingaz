import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'models/session.dart';
import 'models/subject.dart';
import 'models/schedule_slot.dart';
import 'models/plant.dart';
import 'models/note.dart';
import 'providers/timer_provider.dart';
import 'providers/task_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/garden_provider.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(ScheduleSlotAdapter());
  Hive.registerAdapter(PlantAdapter());
  Hive.registerAdapter(NoteAdapter());

  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Session>('sessions');
  await Hive.openBox<Subject>('subjects');
  await Hive.openBox<ScheduleSlot>('scheduleSlots');
  await Hive.openBox<Plant>('plants');
  await Hive.openBox<Note>('notes');

  await NotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()..load()),
        ChangeNotifierProvider(create: (_) => StatsProvider()..load()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()..load()),
        ChangeNotifierProvider(create: (_) => GardenProvider()..load()),
      ],
      child: const IngazApp(),
    ),
  );
}

class IngazApp extends StatelessWidget {
  const IngazApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'إنجاز',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
