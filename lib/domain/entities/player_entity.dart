class PlayerEntity {
  final String id;
  final String name;
  int coins;
  int xp;
  int level;
  final List<String> ownedPetIds;
  String? activePetId;
  final List<String> ownedItemIds;
  final List<String> equippedItemIds;
  final DateTime createdAt;
  int totalGamesPlayed;
  int totalQuestsCompleted;

  PlayerEntity({
    required this.id,
    this.name = 'Trainer',
    this.coins = 500,
    this.xp = 0,
    this.level = 1,
    this.ownedPetIds = const [],
    this.activePetId,
    this.ownedItemIds = const [],
    this.equippedItemIds = const [],
    DateTime? createdAt,
    this.totalGamesPlayed = 0,
    this.totalQuestsCompleted = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  int get xpForNextLevel => (100 * level * 1.5).round();
  double get levelProgress => xpForNextLevel > 0 ? xp / xpForNextLevel : 0.0;

  PlayerEntity copyWith({
    String? id,
    String? name,
    int? coins,
    int? xp,
    int? level,
    List<String>? ownedPetIds,
    String? activePetId,
    List<String>? ownedItemIds,
    List<String>? equippedItemIds,
    DateTime? createdAt,
    int? totalGamesPlayed,
    int? totalQuestsCompleted,
  }) {
    return PlayerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      ownedPetIds: ownedPetIds ?? this.ownedPetIds,
      activePetId: activePetId ?? this.activePetId,
      ownedItemIds: ownedItemIds ?? this.ownedItemIds,
      equippedItemIds: equippedItemIds ?? this.equippedItemIds,
      createdAt: createdAt ?? this.createdAt,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalQuestsCompleted:
          totalQuestsCompleted ?? this.totalQuestsCompleted,
    );
  }
}
