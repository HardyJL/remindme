import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:remindme/services/hive_service.dart';
import 'package:remindme/task.dart';
import 'package:uuid/uuid.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final _hiveService = GetIt.I<HiveService>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.name ?? "New Task")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(), // Material styling
                ),
                initialValue: widget.task.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => widget.task.name = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                initialValue: widget.task.description,
                maxLines: 3,
                onSaved: (value) => widget.task.description = value,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enable Notifications'),
                contentPadding: EdgeInsets.zero,
                value: widget.task.notifactionEnabled,
                onChanged: (value) {
                  setState(() {
                    widget.task.notifactionEnabled = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Priority>(
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                initialValue: widget.task.priority,
                items: Priority.values.map((Priority priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget.task.priority = value!;
                  });
                },
                onSaved: (value) => widget.task.priority = value!,
              ),
              const SizedBox(height: 24),
              Text(
                'Created: ${DateFormat.yMd().format(widget.task.createdDate.toLocal())}',
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submitForm,
                child: const Text('Save Task'),
              ),
              if (widget.task.id != null)
                ElevatedButton(
                  onPressed: () {
                    widget.task.completed = true;
                    widget.task.notifactionEnabled = false;
                    _submitForm();
                  },
                  child: const Text('Finish Task'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // 4. Validate and Save
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Triggers all onSaved callbacks
      widget.task.id ??= Uuid().v4();
      _hiveService.addTask(widget.task);
      Navigator.of(context).pop();
    }
  }
}
