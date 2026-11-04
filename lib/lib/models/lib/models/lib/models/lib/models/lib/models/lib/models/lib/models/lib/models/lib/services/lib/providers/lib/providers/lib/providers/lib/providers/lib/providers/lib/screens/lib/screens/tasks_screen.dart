import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final tp = context.watch<TaskProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('المهام')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addDialog(context),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: tp.tasks.length,
        itemBuilder: (_, i) {
          final t = tp.tasks[i];
          return CheckboxListTile(
            title: Text(t.title, style: TextStyle(decoration: t.isDone ? TextDecoration.lineThrough : null)),
            value: t.isDone,
            onChanged: (_) => tp.toggle(t),
            secondary: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => tp.delete(t)),
          );
        },
      ),
    );
  }
  void _addDialog(BuildContext context) {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('مهمة جديدة'),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () { context.read<TaskProvider>().add(c.text); Navigator.pop(context); },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
