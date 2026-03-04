import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notes/network/model/alarm_model.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );
  }

  static Future<void> scheduleAlarm(Alarm alarm, String noteTitle) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        alarm.id.hashCode,
        'Note Reminder: $noteTitle',
        'It\'s time to check your note!',
        tz.TZDateTime.from(alarm.alarmTime, tz.getLocation('UTC')),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'note_alarms',
            'Note Alarms',
            channelDescription: 'Notifications for note reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default.caf',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            _getMatchDateTimeComponents(alarm.repeatPattern),
      );
    } catch (e) {
      print('Error scheduling alarm: $e');
    }
  }

  static Future<void> cancelAlarm(String alarmId) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(alarmId.hashCode);
    } catch (e) {
      print('Error canceling alarm: $e');
    }
  }

  static Future<void> cancelAllAlarms() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      print('Error canceling all alarms: $e');
    }
  }

  static DateTimeComponents? _getMatchDateTimeComponents(String? pattern) {
    switch (pattern) {
      case 'daily':
        return DateTimeComponents.time;
      case 'weekly':
        return DateTimeComponents.dayOfWeekAndTime;
      case 'monthly':
        return DateTimeComponents.dayOfMonthAndTime;
      default:
        return null;
    }
  }

  static Future<void> showInstantNotification(String title, String body) async {
    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'instant_notifications',
            'Instant Notifications',
            channelDescription: 'Instant notification channel',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }
}
