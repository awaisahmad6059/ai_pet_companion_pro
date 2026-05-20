import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:ai_pet_companion_pro/domain/entities/item_entity.dart';

abstract class PetRepository {
  PetEntity? getActivePet();
  Future<void> savePet(PetEntity pet);
  Future<void> feedPet(PetEntity pet, ItemEntity item);
  Future<void> playWithPet(PetEntity pet);
  Future<void> putPetToSleep(PetEntity pet);
  Future<void> wakePet(PetEntity pet);
  Future<void> cleanPet(PetEntity pet);
  Future<void> applyStatDecay(PetEntity pet);
  Future<void> giveItem(PetEntity pet, ItemEntity item);
  PetMood getMood(PetEntity pet);
}
