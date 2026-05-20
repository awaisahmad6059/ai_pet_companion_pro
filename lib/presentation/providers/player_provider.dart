import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/data/models/player_model.dart';
import 'package:ai_pet_companion_pro/data/datasources/local_datasource.dart';
import 'package:ai_pet_companion_pro/presentation/providers/theme_provider.dart';
import 'package:uuid/uuid.dart';

class PlayerNotifier extends StateNotifier<PlayerModel> {
  final LocalDataSource _dataSource;

  PlayerNotifier(this._dataSource)
      : super(_loadOrCreatePlayer(_dataSource));

  static PlayerModel _loadOrCreatePlayer(LocalDataSource ds) {
    final existing = ds.loadPlayer();
    if (existing != null) return existing;
    const uuid = Uuid();
    final newPlayer = PlayerModel(
      id: uuid.v4(),
      name: 'Trainer',
      coins: 500,
      xp: 0,
      level: 1,
    );
    ds.savePlayer(newPlayer);
    return newPlayer;
  }

  void addCoins(int amount) {
    state = state.copyWithModel(coins: state.coins + amount);
    _dataSource.savePlayer(state);
  }

  void spendCoins(int amount) {
    if (state.coins < amount) return;
    state = state.copyWithModel(coins: state.coins - amount);
    _dataSource.savePlayer(state);
  }

  void addXp(int amount) {
    final newXp = state.xp + amount;
    final xpNeeded = state.xpForNextLevel;
    if (newXp >= xpNeeded) {
      final overflow = newXp - xpNeeded;
      state = state.copyWithModel(
        xp: overflow,
        level: state.level + 1,
        coins: state.coins + (state.level * 50),
      );
    } else {
      state = state.copyWithModel(xp: newXp);
    }
    _dataSource.savePlayer(state);
  }

  void addOwnedItem(String itemId) {
    final updated = [...state.ownedItemIds, itemId];
    state = state.copyWithModel(ownedItemIds: updated);
    _dataSource.savePlayer(state);
  }

  void removeOwnedItem(String itemId) {
    final updated = state.ownedItemIds.where((id) => id != itemId).toList();
    state = state.copyWithModel(ownedItemIds: updated);
    _dataSource.savePlayer(state);
  }

  void equipItem(String itemId) {
    final updated = [...state.equippedItemIds, itemId];
    state = state.copyWithModel(equippedItemIds: updated);
    _dataSource.savePlayer(state);
  }

  void unequipItem(String itemId) {
    final updated =
        state.equippedItemIds.where((id) => id != itemId).toList();
    state = state.copyWithModel(equippedItemIds: updated);
    _dataSource.savePlayer(state);
  }

  void setActivePet(String petId) {
    state = state.copyWithModel(activePetId: petId);
    _dataSource.savePlayer(state);
  }

  void incrementGamesPlayed() {
    state = state.copyWithModel(totalGamesPlayed: state.totalGamesPlayed + 1);
    _dataSource.savePlayer(state);
  }

  void incrementQuestsCompleted() {
    state = state.copyWithModel(
        totalQuestsCompleted: state.totalQuestsCompleted + 1);
    _dataSource.savePlayer(state);
  }

  void reset() {
    const uuid = Uuid();
    state = PlayerModel(
      id: uuid.v4(),
      name: 'Trainer',
      coins: 500,
      xp: 0,
      level: 1,
    );
    _dataSource.savePlayer(state);
  }
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerModel>((ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return PlayerNotifier(dataSource);
});
