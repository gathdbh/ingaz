import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../providers/stats_provider.dart';
import '../services/notification_service.dart';
import 'tasks_screen.dart';
import 'stats_screen.dart';
import 'schedule_screen.dart';
import 'garden_screen.dart';
import 'notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    NotificationService.requestPermissions();
  }

  final _pages = const [
    _TimerPage(),
    TasksScreen(),
    GardenScreen(),
    NotesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.timer), label: 'مؤقت'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'مهام'),
          NavigationDestination(icon: Icon(Icons.park), label: 'حديقتي'),
          NavigationDestination(icon: Icon(Icons.sticky_note_2), label: 'ملاحظات'),
        ],
      ),
    );
  }
}

class _TimerPage extends StatelessWidget {
  const _TimerPage();
  String _fmt(int s) => '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final timer = context.watch<TimerProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنجاز'),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_month), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen()))),
          IconButton(icon: const Icon(Icons.bar_chart), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen()))),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SegmentedButton<TimerMode>(
            segments: const [
              ButtonSegment(value: TimerMode.down, label: Text('تنازلي')),
              ButtonSegment(value: TimerMode.pomodoro, label: Text('بومودورو')),
            ],
            selected: {timer.mode},
            onSelectionChanged: (s) => timer.setMode(s.first),
          ),
          const Spacer(),
          Text(_fmt(timer.remainingSeconds), style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [15, 25, 45, 60].map((m) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(label: Text('$m'), selected: timer.setMinutes == m, onSelected: (_) => timer.setMinutes(m)),
              );
            }).toList(),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: timer.status == TimerStatus.running ? timer.pause : timer.start,
                icon: Icon(timer.status == TimerStatus.running ? Icons.pause : Icons.play_arrow),
                label: Text(timer.status == TimerStatus.running ? 'إيقاف' : 'ابدأ'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(onPressed: timer.reset, icon: const Icon(Icons.refresh), label: const Text('تصفير')),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
