import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Note extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String content;

  @HiveField(3)
  late String? category;

  @HiveField(4)
  late List<String> tags;

  @HiveField(5)
  late DateTime createdAt;

  @HiveField(6)
  late DateTime updatedAt;

  @HiveField(7)
  late bool isMarkdown;

  @HiveField(8)
  late bool isPinned;

  @HiveField(9)
  late DateTime? reminderTime;

  @HiveField(10)
  late String? color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.category,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isMarkdown = false,
    this.isPinned = false,
    this.reminderTime,
    this.color,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isMarkdown,
    bool? isPinned,
    DateTime? reminderTime,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isMarkdown: isMarkdown ?? this.isMarkdown,
      isPinned: isPinned ?? this.isPinned,
      reminderTime: reminderTime ?? this.reminderTime,
      color: color ?? this.color,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
