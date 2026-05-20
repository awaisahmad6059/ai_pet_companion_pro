import 'dart:convert';
import 'package:ai_pet_companion_pro/domain/entities/quest_entity.dart';

class QuestModel extends QuestEntity {
  QuestModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    super.status,
    required super.target,
    super.progress,
    super.xpReward,
    super.coinReward,
    super.expiresAt,
  });

  factory QuestModel.fromEntity(QuestEntity entity) {
    return QuestModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      type: entity.type,
      status: entity.status,
      target: entity.target,
      progress: entity.progress,
      xpReward: entity.xpReward,
      coinReward: entity.coinReward,
      expiresAt: entity.expiresAt,
    );
  }

  factory QuestModel.fromJson(Map<String, dynamic> json) {
    return QuestModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      type: QuestType.values[json['type'] as int? ?? 0],
      status: QuestStatus.values[json['status'] as int? ?? 0],
      target: json['target'] as int? ?? 1,
      progress: json['progress'] as int? ?? 0,
      xpReward: json['xpReward'] as int? ?? 50,
      coinReward: json['coinReward'] as int? ?? 25,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'status': status.index,
      'target': target,
      'progress': progress,
      'xpReward': xpReward,
      'coinReward': coinReward,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory QuestModel.fromJsonString(String jsonStr) =>
      QuestModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
}
