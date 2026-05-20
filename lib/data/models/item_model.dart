import 'dart:convert';
import 'package:ai_pet_companion_pro/domain/entities/item_entity.dart';

class ItemModel extends ItemEntity {
  ItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.type,
    super.rarity,
    required super.price,
    super.imagePath,
    super.statEffects,
    super.isConsumable,
  });

  factory ItemModel.fromEntity(ItemEntity entity) {
    return ItemModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      type: entity.type,
      rarity: entity.rarity,
      price: entity.price,
      imagePath: entity.imagePath,
      statEffects: entity.statEffects,
      isConsumable: entity.isConsumable,
    );
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      type: ItemType.values[json['type'] as int? ?? 0],
      rarity: ItemRarity.values[json['rarity'] as int? ?? 0],
      price: json['price'] as int? ?? 0,
      imagePath: json['imagePath'] as String? ?? '',
      statEffects: (json['statEffects'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          {},
      isConsumable: json['isConsumable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.index,
      'rarity': rarity.index,
      'price': price,
      'imagePath': imagePath,
      'statEffects': statEffects,
      'isConsumable': isConsumable,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory ItemModel.fromJsonString(String jsonStr) =>
      ItemModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
}
