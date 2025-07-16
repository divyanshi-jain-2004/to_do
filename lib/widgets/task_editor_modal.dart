import 'package:flutter/material.dart';

class TaskEditorModal extends StatefulWidget {
  final String? initialText;
  final void Function(String) onSave;

  const TaskEditorModal({
    super.key,
    this.initialText,
    required this.onSave,
  });

  @override
  State<TaskEditorModal> createState() => _TaskEditorModalState();
}

class _TaskEditorModalState extends State<TaskEditorModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialText ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialText != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEditing ? "Edit Task" : "New Task",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              widget.onSave(value);
              Navigator.pop(context);
            },
            decoration: const InputDecoration(
              hintText: "Enter your task...",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              widget.onSave(_controller.text);
              Navigator.pop(context);
            },
            icon: Icon(isEditing ? Icons.save : Icons.add),
            label: Text(isEditing ? "Save" : "Add"),
          )
        ],
      ),
    );
  }
}
// TODO Implement this library.