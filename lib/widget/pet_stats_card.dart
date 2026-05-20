  import 'package:ai_pet_companion_pro/shared/widgets/stat_bar.dart';
  import 'package:flutter/material.dart';
  import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
  import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';

  class PetStatsCard extends StatelessWidget {
    final PetEntity pet;
    final String Function(DateTime) formatTimeAgo;

    const PetStatsCard({
      super.key,
      required this.pet,
      required this.formatTimeAgo,
    });

    @override
    Widget build(BuildContext context) {
      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pet Stats',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            StatBarsRow(
              hunger: pet.hunger,
              happiness: pet.happiness,
              energy: pet.energy,
              hygiene: pet.hygiene,
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.favorite,
                  size: 14,
                  color: Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  'Affection: ${pet.affection}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),

                const Spacer(),

                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey[400],
                ),
                const SizedBox(width: 4),

                Text(
                  'Updated: ${formatTimeAgo(pet.lastUpdated)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }