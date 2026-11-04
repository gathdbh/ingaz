import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stats_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<StatsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('الإحصائيات')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('وقت اليوم', '${s.todayMinutes} دقيقة'),
            _row('الإجمالي', '${s.totalMinutes} دقيقة'),
            _row('الأشجار', '${s.treesPlanted} 🌳'),
          ],
        ),
      ),
    );
  }
  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 18)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}
