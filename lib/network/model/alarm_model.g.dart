// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmAdapter extends TypeAdapter<Alarm> {
  @override
  final int typeId = 3;

  @override
  Alarm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Alarm(
      id: fields[0] as String,
      noteId: fields[1] as String,
      alarmTime: fields[2] as DateTime,
      isActive: fields[3] as bool,
      repeatPattern: fields[4] as String?,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Alarm obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.noteId)
      ..writeByte(2)
      ..write(obj.alarmTime)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.repeatPattern)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Alarm _$AlarmFromJson(Map<String, dynamic> json) => Alarm(
      id: json['id'] as String,
      noteId: json['noteId'] as String,
      alarmTime: DateTime.parse(json['alarmTime'] as String),
      isActive: json['isActive'] as bool? ?? true,
      repeatPattern: json['repeatPattern'] as String? ?? 'none',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AlarmToJson(Alarm instance) => <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'alarmTime': instance.alarmTime.toIso8601String(),
      'isActive': instance.isActive,
      'repeatPattern': instance.repeatPattern,
      'createdAt': instance.createdAt.toIso8601String(),
    };
