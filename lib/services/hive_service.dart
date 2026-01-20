import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:remindme/services/notification_service.dart';
import 'package:remindme/task.dart';

class HiveService {
  static const String _boxName = 'tasks';
  static const String _settingsBoxName = 'settings';
  NotificationService? _notificationService;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(PriorityAdapter());
    await Hive.openBox<Task>(_boxName);
    await Hive.openBox(_settingsBoxName);
    _notificationService = GetIt.I.get<NotificationService>();
  }

  Future<void> addTask(Task task) async {
    final box = Hive.box<Task>(_boxName);
    await box.put(task.id, task);
    updateScheduledNotificationsAfterPut(task);
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
    updateScheduledNotificationsAfterPut(task);
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    final box = Hive.box(_settingsBoxName);
    await box.put('notification_hour', hour);
    await box.put('notification_minute', minute);
    
    // Reschedule all notifications when time changes
    final tasks = getTasks();
    _notificationService?.scheduleWeekdayNotifications(tasks, hour, minute);
  }

  Map<String, int> getNotificationTime() {
    final box = Hive.box(_settingsBoxName);
    final int hour = box.get('notification_hour', defaultValue: 8);
    final int minute = box.get('notification_minute', defaultValue: 0);
    return {'hour': hour, 'minute': minute};
  }

  void updateScheduledNotificationsAfterPut(Task task) {
    if (task.notifactionEnabled) {
      final time = getNotificationTime();
      _notificationService?.scheduleWeekdayNotifications(
        Hive.box<Task>(_boxName).values.toList(),
        time['hour']!,
        time['minute']!,
      );
    }
  }
}
