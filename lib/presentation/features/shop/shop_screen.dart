import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/core/utils/helpers.dart';
import 'package:ai_pet_companion_pro/presentation/providers/shop_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/player_provider.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/game_button.dart';
import 'package:ai_pet_companion_pro/shared/widgets/animated_bg.dart';
import 'package:ai_pet_companion_pro/shared/animations/fade_scale_animation.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  ItemType? _selectedFilter;

  final _typeIcons = {
    ItemType.food: Icons.restaurant_rounded,
    ItemType.toy: Icons.sports_esports_rounded,
    ItemType.skin: Icons.checkroom_rounded,
    ItemType.medicine: Icons.medication_rounded,
    ItemType.decor: Icons.home_rounded,
  };

  final _typeLabels = {
    ItemType.food: 'Food',
    ItemType.toy: 'Toys',
    ItemType.skin: 'Skins',
    ItemType.medicine: 'Medicine',
    ItemType.decor: 'Decor',
  };

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(shopItemsProvider);
    final player = ref.watch(playerProvider);
    final filteredItems = _selectedFilter == null
        ? items
        : items.where((i) => i.type == _selectedFilter).toList();

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Shop'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on_rounded,
                      color: ColorConstants.coinColor, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    Helpers.formatCoins(player.coins),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(child: Text('No items available'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) => FadeScaleAnimation(
                        index: index,
                        child: _ShopItemCard(
                          item: filteredItems[index],
                          playerCoins: player.coins,
                          isOwned: player.ownedItemIds
                              .contains(filteredItems[index].id),
                          onBuy: () => _buyItem(filteredItems[index]),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'All',
            icon: Icons.grid_view_rounded,
            selected: _selectedFilter == null,
            onTap: () => setState(() => _selectedFilter = null),
          ),
          ...ItemType.values.map((type) => _FilterChip(
                label: _typeLabels[type]!,
                icon: _typeIcons[type]!,
                selected: _selectedFilter == type,
                onTap: () => setState(() => _selectedFilter = type),
              )),
        ],
      ),
    );
  }

  void _buyItem(ItemEntity item) {
    final playerNotifier = ref.read(playerProvider.notifier);
    if (ref.read(playerProvider).coins < item.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    playerNotifier.spendCoins(item.price);
    playerNotifier.addOwnedItem(item.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchased ${item.name}!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: selected
                  ? ColorConstants.primary.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              border: Border.all(
                color: selected
                    ? ColorConstants.primary
                    : Colors.grey.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 16,
                    color: selected ? ColorConstants.primary : Colors.grey),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                    color:
                        selected ? ColorConstants.primary : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final ItemEntity item;
  final int playerCoins;
  final bool isOwned;
  final VoidCallback onBuy;

  const _ShopItemCard({
    required this.item,
    required this.playerCoins,
    required this.isOwned,
    required this.onBuy,
  });

  Color _rarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey;
      case ItemRarity.rare:
        return Colors.blue;
      case ItemRarity.epic:
        return Colors.purple;
      case ItemRarity.legendary:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rarityColor = _rarityColor(item.rarity);
    final canAfford = playerCoins >= item.price;

    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: rarityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.rarityLabel,
                  style: TextStyle(
                    fontSize: 9,
                    color: rarityColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.monetization_on_rounded,
                  size: 14, color: ColorConstants.coinColor),
              const SizedBox(width: 2),
              Text(
                '${item.price}',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: ColorConstants.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _itemIcon(item.type),
                  color: ColorConstants.primary,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.description,
            style: TextStyle(
                fontSize: 10, color: Colors.grey[500], height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: GameButton(
              text: isOwned ? 'Owned' : 'Buy',
              onPressed: isOwned ? null : onBuy,
              expanded: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              fontSize: 12,
              gradient: isOwned
                  ? [Colors.grey, Colors.grey]
                  : canAfford
                      ? ColorConstants.premiumGradient
                      : [Colors.grey, Colors.grey],
            ),
          ),
        ],
      ),
    );
  }

  IconData _itemIcon(ItemType type) {
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
