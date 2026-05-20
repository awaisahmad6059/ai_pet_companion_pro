import 'package:ai_pet_companion_pro/domain/entities/item_entity.dart';
import 'package:ai_pet_companion_pro/domain/repositories/shop_repository.dart';
import 'package:uuid/uuid.dart';

class ShopRepositoryImpl implements ShopRepository {
  static final List<ItemEntity> _shopItems = _generateShopItems();

  static List<ItemEntity> _generateShopItems() {
    const uuid = Uuid();
    return [
      ItemEntity(
        id: uuid.v4(),
        name: 'Premium Kibble',
        description: 'High-quality pet food. +25 hunger',
        type: ItemType.food,
        rarity: ItemRarity.common,
        price: 50,
        statEffects: {'hunger': 25, 'happiness': 5},
      ),
      ItemEntity(
        id: uuid.v4(),
        name: 'Gourmet Steak',
        description: 'Delicious steak dinner. +40 hunger',
        type: ItemType.food,
        rarity: ItemRarity.rare,
        price: 120,
        statEffects: {'hunger': 40, 'happiness': 10},
      ),
      ItemEntity(
        id: uuid.v4(),
        name: 'Rainbow Treat',
        description: 'Magical treat that boosts everything!',
        type: ItemType.food,
        rarity: ItemRarity.epic,
        price: 300,
        statEffects: {'hunger': 30, 'happiness': 25, 'energy': 15},
      ),
      ItemEntity(
        id: uuid.v4(),
        name: 'Tennis Ball',
        description: 'A classic toy for fetch. +15 happiness',
        type: ItemType.toy,
        rarity: ItemRarity.common,
        price: 30,
        statEffects: {'happiness': 15, 'energy': -5},
      ),
      ItemEntity(
        id: uuid.v4(),
        name: 'Laser Pointer',
        description: 'Endless fun chasing the light!',
        type: ItemType.toy,
        rarity: ItemRarity.rare,
        price: 80,
        statEffects: {'happiness': 25, 'energy': -10},
      ),
      ItemEntity(
        id: uuid.v4(),
        name: 'Interactive Robot',
        description: 'AI-powered playmate for your pet.',
        type: ItemType.toy,
        rarity: ItemRarity.epic,
        price: 500,
        statEffects: {'happiness': 40, 'energy': -15, 'affection': 10},
      ),
      ItemEntity(
        id: uuid.v4(),
        name: 'Golden Crown',
        description: 'Make your pet feel like royalty!',
        type: ItemType.skin,
        rarity: ItemRarity.legendary,
        price: 1000,
        statEffects: {'happiness': 50},
        isConsumable: false,
      ),
      ItemEntity(
        id: uuid.v4(),
        name: 'Cozy Sweater',
        description: 'Keep your pet warm and stylish.',
        type: ItemType.skin,
        rarity: ItemRarity.rare,
        price: 200,
        statEffects: {'happiness': 15},
        isConsumable: false,
      ),
      ItemEntity(
        id: uuid.v4(),
        name: 'Vitamin Supplement',
        description: 'Boosts overall health.',
        type: ItemType.medicine,
        rarity: ItemRarity.common,
        price: 40,
        statEffects: {'hunger': 10, 'energy': 20, 'hygiene': 10},
      ),
      ItemEntity(
        id: uuid.v4(),
        name: 'Pet Bed Deluxe',
        description: 'Luxurious bed for deep sleep.',
        type: ItemType.decor,
        rarity: ItemRarity.rare,
        price: 350,
        statEffects: {'energy': 30, 'happiness': 10},
        isConsumable: false,
      ),
    ];
  }

  @override
  List<ItemEntity> getShopItems() => _shopItems;

  @override
  List<ItemEntity> getItemsByType(ItemType type) =>
      _shopItems.where((item) => item.type == type).toList();

  @override
  List<ItemEntity> getItemsByRarity(ItemRarity rarity) =>
      _shopItems.where((item) => item.rarity == rarity).toList();
}
