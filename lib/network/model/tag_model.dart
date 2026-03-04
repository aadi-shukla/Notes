import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Tag extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String? color;

  @HiveField(3)
  late DateTime createdAt;

  Tag({
    required this.id,
    required this.name,
    this.color,
    required this.createdAt,
  });

  Tag copyWith({
    String? id,
    String? name,
    String? color,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
