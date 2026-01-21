import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:remindme/services/notification_service.dart';
import 'package:remindme/task.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@GenerateMocks([FlutterLocalNotificationsPlugin])
import 'notification_service_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late NotificationService notificationService;
  late MockFlutterLocalNotificationsPlugin mockPlugin;

  setUp(() {
    mockPlugin = MockFlutterLocalNotificationsPlugin();
    notificationService = NotificationService.test(mockPlugin);
    tz.initializeTimeZones();
  });

  group('NotificationService', () {
    test('init initializes timezone and notifications plugin', () async {
      // Mock FlutterTimezone channel
      const MethodChannel channel = MethodChannel('flutter_timezone');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            if (methodCall.method == 'getLocalTimezone') {
              return 'UTC';
            }
            return null;
          });

      when(mockPlugin.initialize(any)).thenAnswer((_) async => true);

      await notificationService.init();

      verify(mockPlugin.initialize(any)).called(1);
    });

    test('scheduleWeekdayNotifications schedules notifications for enabled tasks', () async {
      final task = Task(
        id: '1',
        name: 'Test Task',
        description: 'Desc',
        notifactionEnabled: true,
        createdDate: DateTime.now(),
      );

      when(mockPlugin.cancelAll()).thenAnswer((_) async {});
      when(mockPlugin.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      )).thenAnswer((_) async {});

      await notificationService.scheduleWeekdayNotifications([task], 8, 0);

      // Should cancel all first
      verify(mockPlugin.cancelAll()).called(1);
      
      // Should schedule 5 times (Mon-Fri)
      verify(mockPlugin.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      )).called(5);
    });
    
    test('scheduleWeekdayNotifications does not schedule for disabled tasks', () async {
      final task = Task(
        id: '1',
        name: 'Test Task',
        description: 'Desc',
        notifactionEnabled: false,
        createdDate: DateTime.now(),
      );

      when(mockPlugin.cancelAll()).thenAnswer((_) async {});

      await notificationService.scheduleWeekdayNotifications([task], 8, 0);

      verify(mockPlugin.cancelAll()).called(1);
      verifyNever(mockPlugin.zonedSchedule(
        any,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
      ));
    });
  });
}
