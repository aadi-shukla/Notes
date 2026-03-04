import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/app/themes/app_theme.dart';
import 'package:notes/controllers/alarm_controller.dart';
import 'package:notes/controllers/categories_controller.dart';
import 'package:notes/controllers/notes_controller.dart';
import 'package:notes/controllers/search_controller.dart' as search;
import 'package:notes/controllers/theme_controller.dart';
import 'package:notes/pages/home/home_page.dart';
import 'package:notes/services/alarm_service.dart';
import 'package:notes/services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveService.initHive();

  // Initialize Notifications
  await AlarmService.initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,

      // Theme Setup
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,

      // Initial Bindings
      initialBinding: AppBindings(),

      // Home Page
      home: const HomePage(),
    );
  }
}

// GetX Bindings for Dependency Injection
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Controllers
    Get.lazyPut(() => NotesController(), fenix: true);
    Get.lazyPut(() => CategoriesController(), fenix: true);
    Get.lazyPut(() => ThemeController(), fenix: true);
    Get.lazyPut(() => search.NoteSearchController(), fenix: true);
    Get.lazyPut(() => AlarmController(), fenix: true);
  }
}
