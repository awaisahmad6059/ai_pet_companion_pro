import 'package:ai_pet_companion_pro/domain/entities/item_entity.dart';

abstract class ShopRepository {
  List<ItemEntity> getShopItems();
  List<ItemEntity> getItemsByType(ItemType type);
  List<ItemEntity> getItemsByRarity(ItemRarity rarity);
}
