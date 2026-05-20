import 'dart:convert';
import 'package:ai_pet_companion_pro/domain/entities/player_entity.dart';

class PlayerModel extends PlayerEntity {
  PlayerModel({
    required super.id,
    super.name,
    super.coins,
    super.xp,
    super.level,
    super.ownedPetIds,
    super.activePetId,
    super.ownedItemIds,
    super.equippedItemIds,
    super.createdAt,
    super.totalGamesPlayed,
    super.totalQuestsCompleted,
  });

  factory PlayerModel.fromEntity(PlayerEntity entity) {
    return PlayerModel(
      id: entity.id,
      name: entity.name,
      coins: entity.coins,
      xp: entity.xp,
      level: entity.level,
      ownedPetIds: entity.ownedPetIds,
      activePetId: entity.activePetId,
      ownedItemIds: entity.ownedItemIds,
      equippedItemIds: entity.equippedItemIds,
      createdAt: entity.createdAt,
      totalGamesPlayed: entity.totalGamesPlayed,
      totalQuestsCompleted: entity.totalQuestsCompleted,
    );
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Trainer',
      coins: json['coins'] as int? ?? 500,
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      ownedPetIds: (json['ownedPetIds'] as List<dynamic>?)
              ?.cast<String>() ??
          [],
      activePetId: json['activePetId'] as String?,
      ownedItemIds: (json['ownedItemIds'] as List<dynamic>?)
              ?.cast<String>() ??
          [],
      equippedItemIds: (json['equippedItemIds'] as List<dynamic>?)
              ?.cast<String>() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      totalGamesPlayed: json['totalGamesPlayed'] as int? ?? 0,
      totalQuestsCompleted: json['totalQuestsCompleted'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coins': coins,
      'xp': xp,
      'level': level,
      'ownedPetIds': ownedPetIds,
      'activePetId': activePetId,
      'ownedItemIds': ownedItemIds,
      'equippedItemIds': equippedItemIds,
      'createdAt': createdAt.toIso8601String(),
      'totalGamesPlayed': totalGamesPlayed,
      'totalQuestsCompleted': totalQuestsCompleted,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory PlayerModel.fromJsonString(String jsonStr) =>
      PlayerModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

  PlayerModel copyWithModel({
    String? id,
    String? name,
    int? coins,
    int? xp,
    int? level,
    List<String>? ownedPetIds,
    String? activePetId,
    List<String>? ownedItemIds,
    List<String>? equippedItemIds,
    int? totalGamesPlayed,
    int? totalQuestsCompleted,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      ownedPetIds: ownedPetIds ?? this.ownedPetIds,
      activePetId: activePetId ?? this.activePetId,
      ownedItemIds: ownedItemIds ?? this.ownedItemIds,
      equippedItemIds: equippedItemIds ?? this.equippedItemIds,
      createdAt: createdAt,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalQuestsCompleted:
          totalQuestsCompleted ?? this.totalQuestsCompleted,
    );
  }
}
