import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:remindme/task.dart' hide Priority;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones(); // Initialize timezone database
    final String timeZoneName =
        (await FlutterTimezone.getLocalTimezone()).identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification'); // Ensure icon exists

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      await androidImplementation?.requestNotificationsPermission();
      await androidImplementation?.requestExactAlarmsPermission();
    }
  }

  /// Cancels all notifications to prevent duplicates before rescheduling
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Schedules notifications for a specific list of items
  /// [hour] and [minute] define the "Morning" time (e.g., 8:00)
  Future<void> scheduleWeekdayNotifications(
    List<Task> items,
    int hour,
    int minute,
  ) async {
    // 1. Clear existing schedules
    await cancelAllNotifications();
    int notificationId = 0;
    for (var item in items) {
      // 2. Filter: Only process items where notification is true
      if (item.notifactionEnabled) {
        // 3. Loop: Create a schedule for Mon(1) through Fri(5)
        for (int weekday = 1; weekday <= 5; weekday++) {
          await _scheduleWeeklyNotification(
            id: notificationId++,
            title: item.name!,
            body: item.description ?? "Time to check: ${item.name}",
            hour: hour,
            minute: minute,
            weekday: weekday,
          );
        }
      }
    }
  }

  // Future<void> testNotificationInTenSeconds() async {
  //   try {
  //     final now = tz.TZDateTime.now(tz.local);
  //     final scheduledDate = now.add(const Duration(seconds: 10));
  //
  //     print('DEBUG: Current time: $now');
  //     print('DEBUG: Scheduled time: $scheduledDate');
  //
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'Reminder',
  //       'Time to check: Test',
  //       scheduledDate,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'daily_reminder_channel_v3', // Changed channel ID
  //           'Daily Reminders V2',
  //           channelDescription: 'Channel for weekday reminders',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //         ),
  //         iOS: DarwinNotificationDetails(),
  //       ),
  //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     );
  //     print('Notification scheduled successfully');
  //
  //     final pending = await flutterLocalNotificationsPlugin
  //         .pendingNotificationRequests();
  //     print('DEBUG: Pending notifications count: ${pending.length}');
  //     for (var p in pending) {
  //       print(
  //         'DEBUG: Pending notification: id=${p.id}, title=${p.title}, body=${p.body}',
  //       );
  //     }
  //   } catch (e) {
  //     print('Error scheduling notification: $e');
  //   }
  //   final List<PendingNotificationRequest> pending =
  //       await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  //   print("Pending notifications: ${pending.length}");
  //   for (var p in pending) {
  //     print("Pending notification: ${p.id} at ${p.body}");
  //   }
  // }

  Future<void> _scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required int weekday, // 1 = Monday, 7 = Sunday
  }) async {
    print(
      "DEBUG: Scheduling notification for $title at $hour:$minute on $weekday",
    );
    var scheduledDate = _nextInstanceOfDay(weekday, hour, minute);
    print("DEBUG: Scheduled date: $scheduledDate");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Channel for weekday reminders',
          importance: Importance.max,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.dayOfWeekAndTime, // Repeats weekly
    );
  }

  tz.TZDateTime _nextInstanceOfDay(int weekday, int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Adjust to the correct weekday
    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // If the calculated time is in the past, add a week
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    return scheduledDate;
  }
}
