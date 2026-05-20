import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/domain/entities/item_entity.dart';
import 'package:ai_pet_companion_pro/data/repositories/shop_repository_impl.dart';
import 'package:ai_pet_companion_pro/domain/repositories/shop_repository.dart';

export 'package:ai_pet_companion_pro/domain/entities/item_entity.dart';

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepositoryImpl();
});

final shopItemsProvider = Provider<List<ItemEntity>>((ref) {
  final repo = ref.watch(shopRepositoryProvider);
  return repo.getShopItems();
});

final shopItemsByTypeProvider =
    Provider.family<List<ItemEntity>, ItemType>((ref, type) {
  final repo = ref.watch(shopRepositoryProvider);
  return repo.getItemsByType(type);
});
