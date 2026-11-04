import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../providers/schedule_provider.dart';
import 'schedule_screen.dart' show subjectColors;

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<ScheduleProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('المواد الدراسية')),
      floatingActionButton: FloatingActionButton(onPressed: () => _addDialog(context, p), child: const Icon(Icons.add)),
      body: p.subjects.isEmpty ? const Center(child: Text('لا توجد مواد بعد')) : ListView.builder(
        itemCount: p.subjects.length,
        itemBuilder: (_, i) {
          final s = p.subjects[i];
          return ListTile(
            leading: CircleAvatar(backgroundColor: subjectColors[s.colorIndex % subjectColors.length], radius: 12),
            title: Text(s.name),
            trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => p.deleteSubject(s)),
          );
        },
      ),
    );
  }
  void _addDialog(BuildContext context, ScheduleProvider p) {
    final nameC = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('مادة جديدة'),
      content: TextField(controller: nameC, decoration: const InputDecoration(labelText: 'اسم المادة'), autofocus: true),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        FilledButton(onPressed: () {
          final name = nameC.text.trim(); if (name.isEmpty) return;
          p.addSubject(Subject(name: name, colorIndex: p.subjects.length % subjectColors.length)); Navigator.pop(ctx);
        }, child: const Text('إضافة')),
      ],
    ));
  }
}
