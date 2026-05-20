import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/presentation/providers/theme_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/shop_provider.dart';

final inventoryProvider = Provider<List<ItemEntity>>((ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  final shopRepo = ref.watch(shopRepositoryProvider);

  final ownedIds = dataSource.loadInventory();
  final allItems = shopRepo.getShopItems();
  return allItems.where((item) => ownedIds.contains(item.id)).toList();
});
