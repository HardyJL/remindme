import 'package:hive_flutter/hive_flutter.dart';
import 'package:remindme/task.dart';

class HiveService {
  static const String _boxName = 'tasks';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(PriorityAdapter());
    await Hive.openBox<Task>(_boxName);
  }

  Future<void> addTask(Task task) async {
    final box = Hive.box<Task>(_boxName);
    await box.put(task.id, task);
  }

  List<Task> getTasks() {
    final box = Hive.box<Task>(_boxName);
    return box.values.toList();
  }

  Task? getTask(String id) {
    final box = Hive.box<Task>(_boxName);
    return box.get(id);
  }

  Future<void> updateTask(Task task) async {
    final box = Hive.box<Task>(_boxName);
    await box.put(task.id, task);
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }
}
