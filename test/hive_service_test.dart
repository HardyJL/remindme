import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:remindme/services/hive_service.dart';
import 'package:remindme/services/notification_service.dart';
import 'package:remindme/task.dart';

@GenerateMocks([NotificationService])
import 'hive_service_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late HiveService hiveService;
  late MockNotificationService mockNotificationService;
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp();
    
    // Mock path_provider channel
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return tempDir.path;
          }
          return null;
        });

    mockNotificationService = MockNotificationService();
    
    // Register the mock with GetIt
    if (GetIt.I.isRegistered<NotificationService>()) {
      GetIt.I.unregister<NotificationService>();
    }
    GetIt.I.registerSingleton<NotificationService>(mockNotificationService);

    hiveService = HiveService();
    // init() calls Hive.initFlutter (uses path_provider) and registers adapters
    // This is now done once for all tests in this group
    await hiveService.init(); 
  });

  setUp(() async {
    // Reset mock interactions
    reset(mockNotificationService);
    // Clear boxes to ensure test isolation
    await Hive.box<Task>('tasks').clear();
    await Hive.box('settings').clear();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
    await GetIt.I.reset();
  });

  group('HiveService', () {
    test('addTask adds task to box and schedules notification', () async {
      final task = Task(
        id: '1',
        name: 'Test Task',
        notifactionEnabled: true,
        createdDate: DateTime.now(),
      );
      
      when(mockNotificationService.scheduleWeekdayNotifications(any, any, any))
          .thenAnswer((_) async {});

      await hiveService.addTask(task);

      final box = Hive.box<Task>('tasks');
      expect(box.get('1'), task);
      
      verify(mockNotificationService.scheduleWeekdayNotifications(any, 8, 0)).called(1);
    });

    test('updateTask updates task and rescheduling', () async {
      final task = Task(
        id: '1',
        name: 'Test Task',
        notifactionEnabled: false,
        createdDate: DateTime.now(),
      );
      await hiveService.addTask(task);
      
      task.notifactionEnabled = true;
      
      when(mockNotificationService.scheduleWeekdayNotifications(any, any, any))
          .thenAnswer((_) async {});

      await hiveService.updateTask(task);
      
      final box = Hive.box<Task>('tasks');
      expect(box.get('1')!.notifactionEnabled, true);
      
      verify(mockNotificationService.scheduleWeekdayNotifications(any, 8, 0)).called(1);
    });
    
    test('setNotificationTime updates settings and reschedules', () async {
      when(mockNotificationService.scheduleWeekdayNotifications(any, any, any))
          .thenAnswer((_) async {});

      await hiveService.setNotificationTime(9, 30);
      
      final box = Hive.box('settings');
      expect(box.get('notification_hour'), 9);
      expect(box.get('notification_minute'), 30);
      
      verify(mockNotificationService.scheduleWeekdayNotifications(any, 9, 30)).called(1);
    });
  });
}