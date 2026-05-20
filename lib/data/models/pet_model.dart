import 'dart:convert';
import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';

class PetModel extends PetEntity {
  PetModel({
    required super.id,
    required super.name,
    super.personality,
    super.hunger,
    super.happiness,
    super.energy,
    super.hygiene,
    super.isSleeping,
    super.createdAt,
    super.lastUpdated,
    super.affection,
  });

  factory PetModel.fromEntity(PetEntity entity) {
    return PetModel(
      id: entity.id,
      name: entity.name,
      personality: entity.personality,
      hunger: entity.hunger,
      happiness: entity.happiness,
      energy: entity.energy,
      hygiene: entity.hygiene,
      isSleeping: entity.isSleeping,
      createdAt: entity.createdAt,
      lastUpdated: entity.lastUpdated,
      affection: entity.affection,
    );
  }

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] as String,
      name: json['name'] as String,
      personality: Personality.values[json['personality'] as int? ?? 0],
      hunger: (json['hunger'] as num?)?.toDouble() ?? 80,
      happiness: (json['happiness'] as num?)?.toDouble() ?? 80,
      energy: (json['energy'] as num?)?.toDouble() ?? 80,
      hygiene: (json['hygiene'] as num?)?.toDouble() ?? 80,
      isSleeping: json['isSleeping'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      affection: json['affection'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'personality': personality.index,
      'hunger': hunger,
      'happiness': happiness,
      'energy': energy,
      'hygiene': hygiene,
      'isSleeping': isSleeping,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'affection': affection,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory PetModel.fromJsonString(String jsonStr) =>
      PetModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

  PetModel copyWithModel({
    String? id,
    String? name,
    Personality? personality,
    double? hunger,
    double? happiness,
    double? energy,
    double? hygiene,
    bool? isSleeping,
    DateTime? lastUpdated,
    int? affection,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      personality: personality ?? this.personality,
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      hygiene: hygiene ?? this.hygiene,
      isSleeping: isSleeping ?? this.isSleeping,
      createdAt: createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
      affection: affection ?? this.affection,
    );
  }
}
