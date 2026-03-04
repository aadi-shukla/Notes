import 'package:get/get.dart';
import 'package:notes/app/helper/app_helper.dart';
import 'package:notes/network/model/alarm_model.dart';
import 'package:notes/services/alarm_service.dart';
import 'package:notes/services/hive_service.dart';

class AlarmController extends GetxController {
  final RxList<Alarm> alarms = RxList<Alarm>();
  final RxBool isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadAlarms();
  }

  void loadAlarms() {
    try {
      isLoading.value = true;
      alarms.value = HiveService.getActiveAlarms();
    } catch (e) {
      print('Error loading alarms: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAlarm({
    required String noteId,
    required DateTime alarmTime,
    String repeatPattern = 'none',
  }) async {
    try {
      isLoading.value = true;
      final alarm = Alarm(
        id: AppHelper.generateId(),
        noteId: noteId,
        alarmTime: alarmTime,
        repeatPattern: repeatPattern,
        createdAt: DateTime.now(),
      );

      await HiveService.addAlarm(alarm);
      await AlarmService.scheduleAlarm(alarm, 'Note Reminder');
      loadAlarms();

      Get.snackbar(
        'Success',
        'Alarm set successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to set alarm: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAlarm(Alarm alarm) async {
    try {
      isLoading.value = true;
      await HiveService.updateAlarm(alarm);
      if (alarm.isActive) {
        await AlarmService.scheduleAlarm(alarm, 'Note Reminder');
      } else {
        await AlarmService.cancelAlarm(alarm.id);
      }
      loadAlarms();

      Get.snackbar(
        'Success',
        'Alarm updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update alarm: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAlarm(String alarmId) async {
    try {
      await AlarmService.cancelAlarm(alarmId);
      await HiveService.deleteAlarm(alarmId);
      loadAlarms();

      Get.snackbar(
        'Success',
        'Alarm deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete alarm: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<Alarm> getAlarmsByNoteId(String noteId) {
    return HiveService.getAlarmsByNoteId(noteId);
  }

  int getActiveAlarmCount() => alarms.where((alarm) => alarm.isActive).length;
}
