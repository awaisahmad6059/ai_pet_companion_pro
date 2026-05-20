import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/core/utils/helpers.dart';
import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:ai_pet_companion_pro/presentation/providers/pet_provider.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/pet_avatar.dart';
import 'package:ai_pet_companion_pro/shared/widgets/stat_bar.dart';
import 'package:ai_pet_companion_pro/shared/widgets/game_button.dart';
import 'package:ai_pet_companion_pro/shared/widgets/animated_bg.dart';

class PetScreen extends ConsumerWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pet = ref.watch(petProvider);

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('My Pet'),
          actions: [
            if (pet != null)
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => _showRenameDialog(context, ref, pet),
              ),
          ],
        ),
        body: pet == null
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pets_rounded, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No pet yet!\nCreate one from the home screen.',
                        textAlign: TextAlign.center),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildPetProfile(context, pet),
                    const SizedBox(height: 16),
                    _buildMoodSection(pet),
                    const SizedBox(height: 16),
                    _buildDetailedStats(pet),
                    const SizedBox(height: 16),
                    _buildPersonalityCard(pet),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPetProfile(BuildContext context, PetEntity pet) {
    return GlassCard(
      glowing: true,
      child: Column(
        children: [
          PetAvatar(pet: pet, size: 130),
          const SizedBox(height: 12),
          Text(
            pet.name,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorConstants.primary.withValues(alpha: 0.2),
                  ColorConstants.secondary.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Level ${_getLevel(pet.affection)} ${pet.personality.name}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ColorConstants.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Affection: ${pet.affection}',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSection(PetEntity pet) {
    final moodLabel = Helpers.moodText(pet.happiness);
    final moodCol = Helpers.moodColor(pet.happiness);

    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: moodCol.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              Helpers.moodEmoji(pet.happiness),
              style: const TextStyle(fontSize: 36),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moodLabel,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: moodCol,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Overall happiness: ${pet.happiness.toInt()}%',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats(PetEntity pet) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detailed Stats',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          StatBarsRow(
            hunger: pet.hunger,
            happiness: pet.happiness,
            energy: pet.energy,
            hygiene: pet.hygiene,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityCard(PetEntity pet) {
    final personalityDescriptions = {
      Personality.playful: 'Loves to play and explore! Always full of energy.',
      Personality.lazy: 'Enjoys relaxing and taking long naps.',
      Personality.grumpy: 'Takes time to warm up, but loyal once bonded.',
      Personality.affectionate: 'Loves cuddles and attention from you.',
      Personality.independent: 'Self-sufficient and curious about everything.',
    };

    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorConstants.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.psychology_rounded,
              color: ColorConstants.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pet.personality.name[0].toUpperCase()}${pet.personality.name.substring(1)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  personalityDescriptions[pet.personality] ?? '',
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[500], height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getLevel(int affection) => (affection ~/ 100) + 1;

  void _showRenameDialog(
      BuildContext context, WidgetRef ref, PetEntity pet) {
    final controller = TextEditingController(text: pet.name);
    showDialog(
      context: context,
      builder: (ctx) {
        final keyboardHeight = MediaQuery.of(ctx).viewInsets.bottom;
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(ctx).size.height - keyboardHeight - 48,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20 + keyboardHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Rename Pet',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'New Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel')),
                      const SizedBox(width: 8),
                      GameButton(
                        text: 'Save',
                        onPressed: () {
                          if (controller.text.trim().isNotEmpty) {
                            ref
                                .read(petProvider.notifier)
                                .rename(controller.text.trim());
                            Navigator.pop(ctx);
                          }
                        },
                        expanded: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
