import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/app/constants/app_constants.dart';
import 'package:notes/app/widgets/glass_container.dart';
import 'package:notes/controllers/categories_controller.dart';
import 'package:notes/controllers/notes_controller.dart';
import 'package:notes/controllers/theme_controller.dart';
import 'package:notes/pages/categories/categories_page.dart';
import 'package:notes/services/export_service.dart';
import 'package:notes/services/hive_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final themeController = Get.find<ThemeController>();
  final notesController = Get.find<NotesController>();
  final categoriesController = Get.find<CategoriesController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Settings
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GlassContainer(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                      const SizedBox(width: 12),
                      Text('Dark Mode'),
                    ],
                  ),
                  Obx(
                    () => Switch(
                      value: themeController.isDarkMode.value,
                      onChanged: (value) {
                        themeController.setDarkMode(value);
                        Get.changeThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Categories Section
            Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Obx(
              () => GlassContainer(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                onTap: () {
                  Get.to(() => const CategoriesPage());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Manage Categories'),
                    Text(
                      '${categoriesController.categories.length} categories',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // Data Management
            Text(
              'Data Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GlassContainer(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onTap: _exportNotesAsJson,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Export Notes'),
                  const Icon(Icons.download),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GlassContainer(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onTap: _showDeleteAllConfirmation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Delete All Data',
                    style: TextStyle(color: Colors.red),
                  ),
                  const Icon(Icons.delete, color: Colors.red),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            // App Info
            Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GlassContainer(
              width: double.infinity,
              height: 130,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version ${AppConstants.appVersion}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Offline First Notes App',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => GlassContainer(
                width: double.infinity,
                height: 180,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistics',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _buildStatRow(
                      context,
                      'Total Notes:',
                      '${notesController.getTotalNotes()}',
                    ),
                    _buildStatRow(
                      context,
                      'Total Words:',
                      '${notesController.getTotalWords()}',
                    ),
                    _buildStatRow(
                      context,
                      'Total Characters:',
                      '${notesController.getTotalCharacters()}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
        ],
      ),
    );
  }

  void _exportNotesAsJson() async {
    try {
      final notes = notesController.notes;
      final jsonData = await ExportService.exportNotesToJson(notes);
      final file = await ExportService.saveJsonFile(jsonData);
      Get.snackbar(
        'Success',
        'Notes exported to: ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to export notes: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showDeleteAllConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data?'),
        content: const Text(
          'This will permanently delete all notes, categories, and alarms. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await HiveService.clearAllData();
              notesController.loadAllNotes();
              categoriesController.loadCategories();
              Get.back();
              Get.snackbar(
                'Success',
                'All data cleared',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
