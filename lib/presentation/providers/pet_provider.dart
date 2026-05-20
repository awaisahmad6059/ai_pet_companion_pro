import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/data/models/pet_model.dart';
import 'package:ai_pet_companion_pro/data/datasources/local_datasource.dart';
import 'package:ai_pet_companion_pro/presentation/providers/theme_provider.dart';
import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:ai_pet_companion_pro/domain/entities/item_entity.dart';
import 'package:ai_pet_companion_pro/domain/usecases/pet_usecases.dart';
import 'package:uuid/uuid.dart';

class PetNotifier extends StateNotifier<PetModel?> {
  final LocalDataSource _dataSource;

  PetNotifier(this._dataSource) : super(_loadPet(_dataSource));

  static PetModel? _loadPet(LocalDataSource ds) {
    final pet = ds.loadPet();
    if (pet != null) {
      PetUseCases.applyDecay(pet);
      ds.savePet(pet);
    }
    return pet;
  }

  PetEntity? get pet => state;

  void createPet(String name, {Personality personality = Personality.playful}) {
    const uuid = Uuid();
    final newPet = PetModel(
      id: uuid.v4(),
      name: name,
      personality: personality,
    );
    state = newPet;
    _dataSource.savePet(newPet);
  }

  void feedPet(ItemEntity item) {
    if (state == null) return;
    state = state!.copyWithModel(
      hunger: (state!.hunger + (item.statEffects['hunger'] ?? 15))
          .clamp(0, 100),
      happiness: (state!.happiness + (item.statEffects['happiness'] ?? 5))
          .clamp(0, 100),
    );
    _dataSource.savePet(state!);
  }

  void playWithPet() {
    if (state == null) return;
    state = state!.copyWithModel(
      happiness: (state!.happiness + 10).clamp(0, 100),
      energy: (state!.energy - 15).clamp(0, 100),
      affection: state!.affection + 2,
    );
    _dataSource.savePet(state!);
  }

  void putToSleep() {
    if (state == null) return;
    state = state!.copyWithModel(isSleeping: true);
    _dataSource.savePet(state!);
  }

  void wakeUp() {
    if (state == null) return;
    state = state!.copyWithModel(
      isSleeping: false,
      energy: (state!.energy + 40).clamp(0, 100),
    );
    _dataSource.savePet(state!);
  }

  void cleanPet() {
    if (state == null) return;
    state = state!.copyWithModel(hygiene: 100);
    _dataSource.savePet(state!);
  }

  void giveItem(ItemEntity item) {
    if (state == null) return;
    var newState = state!;
    item.statEffects.forEach((key, value) {
      switch (key) {
        case 'hunger':
          newState = newState.copyWithModel(
              hunger: (newState.hunger + value).clamp(0, 100));
          break;
        case 'happiness':
          newState = newState.copyWithModel(
              happiness: (newState.happiness + value).clamp(0, 100));
          break;
        case 'energy':
          newState = newState.copyWithModel(
              energy: (newState.energy + value).clamp(0, 100));
          break;
        case 'hygiene':
          newState = newState.copyWithModel(
              hygiene: (newState.hygiene + value).clamp(0, 100));
          break;
      }
    });
    newState = newState.copyWithModel(affection: newState.affection + 5);
    state = newState;
    _dataSource.savePet(state!);
  }

  void applyDecay() {
    if (state == null) return;
    PetUseCases.applyDecay(state!);
    _dataSource.savePet(state!);
  }

  void rename(String newName) {
    if (state == null) return;
    state = state!.copyWithModel(name: newName);
    _dataSource.savePet(state!);
  }

  void reset() {
    state = null;
    _dataSource.savePet(null);
  }
}

final petProvider = StateNotifierProvider<PetNotifier, PetModel?>((ref) {
  final dataSource = ref.watch(localDataSourceProvider);
  return PetNotifier(dataSource);
});
