import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/domain/entities/item_entity.dart';
import 'package:ai_pet_companion_pro/presentation/providers/inventory_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/player_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/pet_provider.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/game_button.dart';
import 'package:ai_pet_companion_pro/shared/widgets/animated_bg.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);
    final player = ref.watch(playerProvider);

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Inventory')),
        body: items.isEmpty
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inventory_2_rounded,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your inventory is empty.\nBuy items from the shop!',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isEquipped = player.equippedItemIds.contains(item.id);
                  return _InventoryItemCard(
                    item: item,
                    isEquipped: isEquipped,
                    onUse: () => _useItem(context, ref, item),
                    onEquip: () => _toggleEquip(ref, item, isEquipped),
                  );
                },
              ),
      ),
    );
  }

  void _useItem(BuildContext context, WidgetRef ref, ItemEntity item) {
    if (item.isConsumable) {
      ref.read(petProvider.notifier).giveItem(item);
      ref.read(playerProvider.notifier).removeOwnedItem(item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Used ${item.name}!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _toggleEquip(WidgetRef ref, ItemEntity item, bool isEquipped) {
    if (isEquipped) {
      ref.read(playerProvider.notifier).unequipItem(item.id);
    } else {
      ref.read(playerProvider.notifier).equipItem(item.id);
    }
  }
}

class _InventoryItemCard extends StatelessWidget {
  final ItemEntity item;
  final bool isEquipped;
  final VoidCallback onUse;
  final VoidCallback onEquip;

  const _InventoryItemCard({
    required this.item,
    required this.isEquipped,
    required this.onUse,
    required this.onEquip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: ColorConstants.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _typeIcon(item.type),
                color: ColorConstants.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (isEquipped) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstants.success.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Equipped',
                            style: TextStyle(
                              color: ColorConstants.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (item.isConsumable)
              GameButton(
                text: 'Use',
                onPressed: onUse,
                expanded: false,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                fontSize: 12,
                gradient: [
                  ColorConstants.success,
                  ColorConstants.success.withValues(alpha: 0.7),
                ],
              ),
            const SizedBox(width: 8),
            GameButton(
              text: isEquipped ? 'Unequip' : 'Equip',
              onPressed: onEquip,
              expanded: false,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              fontSize: 12,
              gradient: isEquipped
                  ? [Colors.orange, Colors.deepOrange]
                  : ColorConstants.premiumGradient,
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(ItemType type) {
    switch (type) {
      case ItemType.food:
        return Icons.restaurant_rounded;
      case ItemType.toy:
        return Icons.sports_esports_rounded;
      case ItemType.skin:
        return Icons.checkroom_rounded;
      case ItemType.medicine:
        return Icons.medication_rounded;
      case ItemType.decor:
        return Icons.home_rounded;
    }
  }
}
