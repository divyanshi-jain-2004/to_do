import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/widgets/task_tile.dart';
import '/widgets/task_editor_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> tasks = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks') ?? [];
    setState(() => tasks.addAll(savedTasks));
  }

  Future<void> _saveTasks() async {
    await prefs.setStringList('tasks', tasks);
  }

  void _addTask(String task) {
    if (task.trim().isEmpty) return;
    setState(() => tasks.insert(0, task.trim()));
    _saveTasks();
    _showSnackbar("🎉 Task added!");
  }

  void _editTask(int index, String newTask) {
    setState(() => tasks[index] = newTask.trim());
    _saveTasks();
    _showSnackbar("✏️ Task updated");
  }

  void _deleteTask(int index) {
    String removed = tasks[index];
    setState(() => tasks.removeAt(index));
    _saveTasks();
    _showSnackbar("🗑️ Deleted: $removed", undo: () {
      setState(() => tasks.insert(index, removed));
      _saveTasks();
    });
  }

  void _showSnackbar(String message, {VoidCallback? undo}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: undo != null
            ? SnackBarAction(label: "Undo", onPressed: undo)
            : null,
      ),
    );
  }

  void _showTaskEditor({String? existingText, int? editIndex}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (_) => TaskEditorModal(
        initialText: existingText,
        onSave: (text) {
          if (editIndex != null) {
            _editTask(editIndex, text);
          } else {
            _addTask(text);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("✨ Interactive To-Do"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTaskEditor(),
        icon: const Icon(Icons.add),
        label: const Text("New Task"),
      ),
      body: tasks.isEmpty
          ? const Center(
        child: Text(
          "🎯 No tasks yet!\nTap + to get started.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tasks.length,
        itemBuilder: (context, index) => TaskTile(
          task: tasks[index],
          onEdit: () => _showTaskEditor(
              existingText: tasks[index], editIndex: index),
          onDelete: () => _deleteTask(index),
        ),
      ),
    );
  }
}
