import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:remindme/pages/home_page.dart';
import 'package:remindme/services/hive_service.dart';
import 'package:remindme/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final notificationService = NotificationService();
  GetIt.I.registerSingleton<NotificationService>(notificationService);
  final hiveService = HiveService();
  await hiveService.init();
  await notificationService.init();
  // technically we should deal with rejected permissions here
  await notificationService.requestPermissions();
  GetIt.I.registerSingleton<HiveService>(hiveService);
  // notificationService.scheduleWeekdayNotifications(
  //   hiveService.getTasks(),
  //   8,
  //   0,
  // );
  runApp(const App());
}

// #D4A373
const colorSeed = Color(0xFFCD853F);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remind Me',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorSeed,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorSeed,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
