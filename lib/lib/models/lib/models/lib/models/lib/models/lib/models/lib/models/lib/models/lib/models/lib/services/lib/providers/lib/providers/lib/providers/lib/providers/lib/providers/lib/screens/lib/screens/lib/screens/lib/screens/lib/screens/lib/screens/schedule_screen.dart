import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/schedule_slot.dart';
import '../providers/schedule_provider.dart';
import 'subjects_screen.dart';

const dayNames = ['', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
const subjectColors = [Color(0xFF2E7D32), Color(0xFF1565C0), Color(0xFFC62828), Color(0xFF6A1B9A), Color(0xFFEF6C00), Color(0xFF00838F), Color(0xFFAD1457), Color(0xFF558B2F)];
String fmtTime(int minutes) {
  final h = (minutes ~/ 60) % 24; final m = minutes % 60; final ampm = h < 12 ? 'ص' : 'م'; final h12 = h % 12 == 0 ? 12 : h % 12;
  return '$h12:${m.toString().padLeft(2, '0')} $ampm';
}
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ScheduleProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('الجدول الدراسي'), actions: [
        IconButton(icon: const Icon(Icons.menu_book), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubjectsScreen()))),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addSlotDialog(context, p), icon: const Icon(Icons.add), label: const Text('إضافة'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12), itemCount: 7,
        itemBuilder: (_, i) {
          final day = i + 1; final slots = p.slotsForDay(day);
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(padding: const EdgeInsets.only(bottom: 8, right: 4), child: Text(dayNames[day], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
                if (slots.isEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 6, right: 4), child: Text('لا شيء', style: TextStyle(color: Colors.grey.shade600)))
                else ...slots.map((s) {
                  final color = s.subjectName.isEmpty ? Colors.grey : subjectColors[s.colorIndex % subjectColors.length];
                  return Dismissible(
                    key: Key(s.key.toString()), direction: DismissDirection.endToStart,
                    background: Container(alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 20), color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
                    onDismissed: (_) => p.deleteSlot(s),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                      child: Row(children: [
                        Container(width: 4, height: 44, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)))),
                        Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), child: Row(children: [
                          Expanded(child: Text(s.subjectName.isEmpty ? 'مشغول' : s.subjectName, style: const TextStyle(fontWeight: FontWeight.w600))),
                          Text('${fmtTime(s.startMin)} - ${fmtTime(s.endMin)}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        ]))),
                      ]),
                    ),
                  );
                }),
              ]),
            ),
          );
        },
      ),
    );
  }
  Future<void> _addSlotDialog(BuildContext context, ScheduleProvider p) async {
    if (p.subjects.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أضف مادة أولاً'))); return; }
    int day = 1; TimeOfDay start = const TimeOfDay(hour: 9, minute: 0); TimeOfDay end = const TimeOfDay(hour: 10, minute: 0);
    String? subjectName = p.subjects.first.name; bool isBusy = false;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateD) => AlertDialog(
          title: const Text('إضافة للجدول'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<int>(value: day, decoration: const InputDecoration(labelText: 'اليوم'), items: [for (int i = 1; i <= 7; i++) DropdownMenuItem(value: i, child: Text(dayNames[i]))], onChanged: (v) => setStateD(() => day = v ?? 1)),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () async { final t = await showTimePicker(context: ctx, initialTime: start); if (t != null) setStateD(() => start = t); }, child: Text('من ${start.format(ctx)}'))),
              const SizedBox(width: 8),
              Expanded(child: OutlinedButton(onPressed: () async { final t = await showTimePicker(context: ctx, initialTime: end); if (t != null) setStateD(() => end = t); }, child: Text('إلى ${end.format(ctx)}'))),
            ]),
            const SizedBox(height: 8),
            SwitchListTile(title: const Text('فترة مشغولة'), value: isBusy, onChanged: (v) => setStateD(() => isBusy = v)),
            if (!isBusy) DropdownButtonFormField<String>(value: subjectName, decoration: const InputDecoration(labelText: 'المادة'), items: p.subjects.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(), onChanged: (v) => setStateD(() => subjectName = v)),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            FilledButton(onPressed: () {
              final startMin = start.hour * 60 + start.minute; final endMin = end.hour * 60 + end.minute; if (endMin <= startMin) return;
              int colorIdx = 0; if (!isBusy && subjectName != null) colorIdx = p.subjects.firstWhere((e) => e.name == subjectName, orElse: () => p.subjects.first).colorIndex;
              p.addSlot(ScheduleSlot(dayOfWeek: day, startMin: startMin, endMin: endMin, subjectName: isBusy ? '' : (subjectName ?? ''), colorIndex: colorIdx));
              Navigator.pop(ctx);
            }, child: const Text('إضافة')),
          ],
        ),
      ),
    );
  }
}
