// App Configuration File
// This file contains environment-specific configurations

class AppConfig {
  // App Options
  static const bool isProduction = false;
  static const bool enableDebugLogging = true;
  static const bool enableOfflineMode = true; // Always true for this app

  // Database Configuration
  static const String hiveBoxNotes = 'notes';
  static const String hiveBoxCategories = 'categories';
  static const String hiveBoxTags = 'tags';
  static const String hiveBoxAlarms = 'alarms';
  static const String hiveBoxSettings = 'settings';

  // Notification Configuration
  static const String notificationChannelId = 'note_alarms';
  static const String notificationChannelName = 'Note Alarms';
  static const String notificationChannelDescription =
      'Notifications for note reminders';

  // File Export Configuration
  static const String exportFilePrefix = 'notes_export_';
  static const String exportFileExtension = '.json';

  // Validation Rules
  static const int minNoteTitleLength = 1;
  static const int maxNoteTitleLength = 200;
  static const int maxNoteContentLength = 50000;
  static const int maxCategoryNameLength = 50;
  static const int maxTagNameLength = 30;
}
