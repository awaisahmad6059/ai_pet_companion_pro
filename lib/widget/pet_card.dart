import 'package:flutter/material.dart';
import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/pet_avatar.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/core/utils/helpers.dart';

class PetCard extends StatelessWidget {
  final PetEntity pet;

  const PetCard({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    final moodLabel = Helpers.moodText(pet.happiness);
    final moodCol = Helpers.moodColor(pet.happiness);

    return GlassCard(
      glowing: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: moodCol.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        moodLabel,
                        style: TextStyle(
                          color: moodCol,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet.personality.name[0].toUpperCase()}${pet.personality.name.substring(1)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              PetAvatar(pet: pet, size: 100),
            ],
          ),

          const SizedBox(height: 16),

          if (pet.isSleeping)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorConstants.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.nightlight_round, color: ColorConstants.primary),
                  SizedBox(width: 8),
                  Text('Your pet is sleeping zzz...'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}