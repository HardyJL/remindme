import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:remindme/pages/home_page.dart';
import 'package:remindme/services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hiveService = HiveService();
  await hiveService.init();
  GetIt.I.registerSingleton<HiveService>(hiveService);
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
