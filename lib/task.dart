import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,

  @HiveField(1)
  medium,

  @HiveField(2)
  high,
}

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  bool notifactionEnabled;

  @HiveField(4)
  bool completed;

  @HiveField(5)
  Priority priority;

  @HiveField(6)
  DateTime createdDate;

  Task({
    this.id,
    this.name,
    this.description,
    this.notifactionEnabled = false,
    this.completed = false,
    this.priority = Priority.medium,
    required this.createdDate,
  });
}
