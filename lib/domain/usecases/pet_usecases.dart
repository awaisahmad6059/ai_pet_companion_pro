import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:ai_pet_companion_pro/core/constants/app_constants.dart';

class PetUseCases {
  PetUseCases._();

  static void applyDecay(PetEntity pet) {
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
    }
  }

  static bool canInteract(PetEntity pet) {
    if (pet.isSleeping) return false;
    return pet.energy > 10;
  }

  static int calculateAffectionGain(PetEntity pet) {
    final base = 5;
    final moodBonus = switch (pet.mood) {
      PetMood.joyful => 10,
      PetMood.happy => 7,
      PetMood.neutral => 5,
      PetMood.sad => 3,
      PetMood.miserable => 1,
    };
    return base + moodBonus;
  }
}
