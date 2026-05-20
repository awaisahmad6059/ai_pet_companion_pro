import 'package:ai_pet_companion_pro/widget/QuickActionButton%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:ai_pet_companion_pro/presentation/providers/pet_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/shop_provider.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';

class QuickActionsCard extends ConsumerWidget {
  final PetEntity pet;

  const QuickActionsCard({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              QuickActionButton(
                icon: Icons.restaurant_rounded,
                label: 'Feed',
                color: Colors.orange,
                onTap: () {
                  if (pet.hunger >= 90) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pet is not hungry!')),
                    );
                    return;
                  }

                  final food = ref
                      .read(shopItemsProvider)
                      .firstWhere((i) => i.type == ItemType.food);

                  ref.read(petProvider.notifier).feedPet(food);
                },
              ),

              const SizedBox(width: 8),

              QuickActionButton(
                icon: Icons.favorite_rounded,
                label: 'Play',
                color: Colors.pink,
                onTap: () {
                  if (pet.energy < 15) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pet is too tired!')),
                    );
                    return;
                  }

                  ref.read(petProvider.notifier).playWithPet();
                },
              ),

              const SizedBox(width: 8),

              QuickActionButton(
                icon: Icons.nightlight_round,
                label: pet.isSleeping ? 'Wake' : 'Sleep',
                color: Colors.indigo,
                onTap: () {
                  if (pet.isSleeping) {
                    ref.read(petProvider.notifier).wakeUp();
                  } else {
                    ref.read(petProvider.notifier).putToSleep();
                  }
                },
              ),

              const SizedBox(width: 8),

              QuickActionButton(
                icon: Icons.clean_hands_rounded,
                label: 'Clean',
                color: Colors.cyan,
                onTap: () {
                  ref.read(petProvider.notifier).cleanPet();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}