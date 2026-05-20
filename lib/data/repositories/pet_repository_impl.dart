import 'package:ai_pet_companion_pro/data/datasources/local_datasource.dart';
import 'package:ai_pet_companion_pro/data/models/pet_model.dart';
import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:ai_pet_companion_pro/domain/entities/item_entity.dart';
import 'package:ai_pet_companion_pro/domain/repositories/pet_repository.dart';
import 'package:ai_pet_companion_pro/core/constants/app_constants.dart';

class PetRepositoryImpl implements PetRepository {
  final LocalDataSource _localDataSource;

  PetRepositoryImpl(this._localDataSource);

  @override
  PetEntity? getActivePet() {
    return _localDataSource.loadPet();
  }

  @override
  Future<void> savePet(PetEntity pet) async {
    await _localDataSource.savePet(PetModel.fromEntity(pet));
  }

  @override
  Future<void> feedPet(PetEntity pet, ItemEntity item) async {
    pet.hunger =
        (pet.hunger + (item.statEffects['hunger'] ?? 15)).clamp(0, 100).toDouble();
    pet.happiness =
        (pet.happiness + (item.statEffects['happiness'] ?? 5)).clamp(0, 100).toDouble();
    pet.lastUpdated = DateTime.now();
    await savePet(pet);
  }

  @override
  Future<void> playWithPet(PetEntity pet) async {
    pet.happiness =
        (pet.happiness + 10).clamp(0, 100).toDouble();
    pet.energy =
        (pet.energy - 15).clamp(0, 100).toDouble();
    pet.lastUpdated = DateTime.now();
    await savePet(pet);
  }

  @override
  Future<void> putPetToSleep(PetEntity pet) async {
    pet.isSleeping = true;
    pet.lastUpdated = DateTime.now();
    await savePet(pet);
  }

  @override
  Future<void> wakePet(PetEntity pet) async {
    pet.isSleeping = false;
    pet.energy =
        (pet.energy + 40).clamp(0, 100).toDouble();
    pet.happiness =
        (pet.happiness + 5).clamp(0, 100).toDouble();
    pet.lastUpdated = DateTime.now();
    await savePet(pet);
  }

  @override
  Future<void> cleanPet(PetEntity pet) async {
    pet.hygiene = AppConstants.maxPetStats.toDouble();
    pet.happiness =
        (pet.happiness + 5).clamp(0, 100).toDouble();
    pet.lastUpdated = DateTime.now();
    await savePet(pet);
  }

  @override
  Future<void> applyStatDecay(PetEntity pet) async {
    final now = DateTime.now();
    final diff = now.difference(pet.lastUpdated);
    final intervals = diff.inMinutes ~/ AppConstants.statDecayIntervalMinutes;

    if (intervals > 0) {
      final decay = intervals * AppConstants.statDecayAmount;
      pet.hunger = (pet.hunger - decay).clamp(0, 100).toDouble();
      pet.happiness = (pet.happiness - decay).clamp(0, 100).toDouble();
      pet.energy = (pet.energy - decay).clamp(0, 100).toDouble();
      pet.hygiene = (pet.hygiene - decay).clamp(0, 100).toDouble();
      pet.lastUpdated = now;
      await savePet(pet);
    }
  }

  @override
  Future<void> giveItem(PetEntity pet, ItemEntity item) async {
    item.statEffects.forEach((key, value) {
      switch (key) {
        case 'hunger':
          pet.hunger = (pet.hunger + value).clamp(0, 100).toDouble();
          break;
        case 'happiness':
          pet.happiness = (pet.happiness + value).clamp(0, 100).toDouble();
          break;
        case 'energy':
          pet.energy = (pet.energy + value).clamp(0, 100).toDouble();
          break;
        case 'hygiene':
          pet.hygiene = (pet.hygiene + value).clamp(0, 100).toDouble();
          break;
      }
    });
    pet.affection += 5;
    pet.lastUpdated = DateTime.now();
    await savePet(pet);
  }

  @override
  PetMood getMood(PetEntity pet) => pet.mood;
}
