import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:remindme/services/hive_service.dart';
import 'package:remindme/services/notification_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late int _hour;
  late int _minute;
  final HiveService _hiveService = GetIt.I.get<HiveService>();
  final NotificationService _notificationService = GetIt.I
      .get<NotificationService>();
  List<PendingNotificationRequest> _pendingNotifications = [];

  @override
  void initState() {
    super.initState();
    final time = _hiveService.getNotificationTime();
    _hour = time['hour']!;
    _minute = time['minute']!;
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await _notificationService
        .getScheduledNotifications();
    final uniqueNotifications = notifications
        .fold<List<PendingNotificationRequest>>([], (list, element) {
          if (!list.any((item) => item.title == element.title)) {
            list.add(element);
          }
          return list;
        });
    setState(() {
      _pendingNotifications = uniqueNotifications;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour, minute: _minute),
    );
    if (picked != null) {
      setState(() {
        _hour = picked.hour;
        _minute = picked.minute;
      });
      await _hiveService.setNotificationTime(_hour, _minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Notification Time'),
            subtitle: Text(
              'Reminders will be sent at ${TimeOfDay(hour: _hour, minute: _minute).format(context)}',
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context),
          ),
          const Divider(height: 32.0),
          Text(
            'Scheduled Notifications (${_pendingNotifications.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8.0),
          ..._pendingNotifications.map((notification) {
            return Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.notifications_active),
                title: Text(notification.title ?? 'No Title'),
                subtitle: Text(notification.body ?? 'No Body'),
              ),
            );
          }),
        ],
      ),
    );
  }
}
