import 'package:flutter/material.dart';
import 'package:remindme/pages/task_page.dart';
import 'package:remindme/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Widget? leading;

  const TaskCard({super.key, required this.task, this.leading});

  @override
  Widget build(BuildContext context) {
    final textDecoration = task.completed ? TextDecoration.lineThrough : null;
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: leading,
        title: Text(
          task.name ?? 'New Task',
          style: TextStyle(decoration: textDecoration),
        ),
        subtitle: task.description != null && task.description!.isNotEmpty
            ? Text(
                task.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(decoration: textDecoration),
              )
            : null,
        trailing: Icon(
          task.notifactionEnabled
              ? Icons.notifications
              : Icons.notifications_off,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskPage(task: task)),
          );
        },
      ),
    );
  }
}

                      // return Card(
                      //   elevation: 4.0,
                      //   margin: const EdgeInsets.symmetric(vertical: 8.0),
                      //   child: ListTile(
                      //     title: Text(
                      //       task.name,
                      //       style: const TextStyle(
                      //         decoration: TextDecoration.lineThrough,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //     subtitle:
                      //         task.description != null &&
                      //             task.description!.isNotEmpty
                      //         ? Text(
                      //             task.description!,
                      //             maxLines: 1,
                      //             overflow: TextOverflow.ellipsis,
                      //             style: const TextStyle(
                      //               decoration: TextDecoration.lineThrough,
                      //             ),
                      //           )
                      //         : null,
                      //     trailing: Icon(
                      //       task.notifactionEnabled
                      //           ? Icons.notifications
                      //           : Icons.notifications_off,
                      //     ),
                      //     onTap: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => TaskPage(task: task),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // );
