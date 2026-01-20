import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:remindme/pages/task_page.dart';
import 'package:remindme/pages/settings_page.dart';
import 'package:remindme/widgets/task_card.dart';
import 'package:remindme/task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  IconData getIconData(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Icons.pending_actions;
      case Priority.medium:
        return Icons.assignment;
      case Priority.high:
        return Icons.assignment_late;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remind Me'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Task>('tasks').listenable(),
        builder: (context, box, _) {
          final tasks = box.values.toList();
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks yet!'));
          }
          final doneTasks = tasks.where((task) => task.completed).toList();
          final notDoneTasks = tasks.where((task) => !task.completed).toList()
            ..sort((a, b) => b.priority.index.compareTo(a.priority.index));
          return SingleChildScrollView(
            child: Column(
              children: [
                if (notDoneTasks.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: notDoneTasks.length,
                    itemBuilder: (context, index) {
                      final task = notDoneTasks[index];
                      return TaskCard(
                        task: task,
                        leading: Icon(getIconData(task.priority)),
                      );
                    },
                  ),
                if (doneTasks.isNotEmpty)
                  const Divider(height: 1, thickness: 1),
                if (doneTasks.isNotEmpty)
                  ExpansionTile(
                    title: const Text('Done Tasks'),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8.0),
                        itemCount: doneTasks.length,
                        itemBuilder: (context, index) {
                          final task = doneTasks[index];
                          return TaskCard(task: task);
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                TaskPage(task: Task(createdDate: DateTime.now())),
          ),
        ),
        tooltip: 'Add Task',
        child: const Icon(Icons.add_task),
      ),
    );
  }
}

// void _showAddTaskDialog() {
//   String name = '';
//   String? description;
//   bool notifactionEnabled = false;
//   Priority priority = Priority.medium;
//
//   showDialog(
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: const Text('Add Task'),
//             content: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: 'Name'),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a name';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) => name = value!,
//                     ),
//                     TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Description',
//                       ),
//                       onSaved: (value) => description = value,
//                     ),
//                     SwitchListTile(
//                       contentPadding: EdgeInsets.zero,
//                       title: const Text('Enable Notifications'),
//                       value: notifactionEnabled,
//                       onChanged: (value) {
//                         setState(() {
//                           notifactionEnabled = value;
//                         });
//                       },
//                     ),
//                     DropdownButtonFormField<Priority>(
//                       decoration: const InputDecoration(labelText: 'Priority'),
//                       initialValue: priority,
//                       items: Priority.values.map((Priority priority) {
//                         return DropdownMenuItem<Priority>(
//                           value: priority,
//                           child: Text(priority.toString().split('.').last),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           priority = value!;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     final newTask = Task(
//                       id: Uuid().v4(),
//                       name: name,
//                       description: description,
//                       notifactionEnabled: notifactionEnabled,
//                       createdDate: DateTime.now(),
//                       priority: priority,
//                     );
//                     _hiveService.addTask(newTask);
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: const Text('Add'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
