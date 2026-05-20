enum ItemType { food, toy, skin, medicine, decor }

enum ItemRarity { common, rare, epic, legendary }

class ItemEntity {
  final String id;
  final String name;
  final String description;
  final ItemType type;
  final ItemRarity rarity;
  final int price;
  final String imagePath;
  final Map<String, double> statEffects;
  final bool isConsumable;

  ItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.rarity = ItemRarity.common,
    required this.price,
    this.imagePath = '',
    this.statEffects = const {},
    this.isConsumable = true,
  });

  String get rarityLabel {
    switch (rarity) {
      case ItemRarity.common:
        return 'Common';
      case ItemRarity.rare:
        return 'Rare';
      case ItemRarity.epic:
        return 'Epic';
      case ItemRarity.legendary:
        return 'Legendary';
    }
  }
}
