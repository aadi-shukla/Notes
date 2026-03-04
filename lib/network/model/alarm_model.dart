import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alarm_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class Alarm extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String noteId;

  @HiveField(2)
  late DateTime alarmTime;

  @HiveField(3)
  late bool isActive;

  @HiveField(4)
  late String? repeatPattern; // none, daily, weekly, monthly

  @HiveField(5)
  late DateTime createdAt;

  Alarm({
    required this.id,
    required this.noteId,
    required this.alarmTime,
    this.isActive = true,
    this.repeatPattern = 'none',
    required this.createdAt,
  });

  Alarm copyWith({
    String? id,
    String? noteId,
    DateTime? alarmTime,
    bool? isActive,
    String? repeatPattern,
    DateTime? createdAt,
  }) {
    return Alarm(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      alarmTime: alarmTime ?? this.alarmTime,
      isActive: isActive ?? this.isActive,
      repeatPattern: repeatPattern ?? this.repeatPattern,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmToJson(this);
}
