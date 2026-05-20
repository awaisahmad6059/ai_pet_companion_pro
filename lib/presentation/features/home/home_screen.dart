import 'package:ai_pet_companion_pro/widget/create_custom_button.dart';
import 'package:ai_pet_companion_pro/widget/create_pet_card.dart';
import 'package:ai_pet_companion_pro/widget/custom_text_button.dart';
import 'package:ai_pet_companion_pro/widget/daily_reward_card.dart';
import 'package:ai_pet_companion_pro/widget/home_background_animation.dart';
import 'package:ai_pet_companion_pro/widget/pet_card.dart';
import 'package:ai_pet_companion_pro/widget/pet_creation_form.dart';
import 'package:ai_pet_companion_pro/widget/pet_stats_card.dart';
import 'package:ai_pet_companion_pro/widget/quick_actions_card.dart';
import 'package:ai_pet_companion_pro/widget/welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:ai_pet_companion_pro/presentation/providers/pet_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/player_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _showCreatePetDialog() {
    final nameController = TextEditingController();
    Personality selectedPersonality = Personality.playful;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final keyboardHeight = MediaQuery.of(ctx).viewInsets.bottom;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              insetPadding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
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
                        'Create Your Pet',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      PetCreationForm(
                        nameController: nameController,
                        selectedPersonality: selectedPersonality,
                        onPersonalitySelected: (p) {
                          setDialogState(() {
                            selectedPersonality = p;
                          });
                        },
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextButton(
                            text: 'Cancel',
                            onPressed: () => Navigator.pop(ctx),
                          ),
                          CreateCustomButton(
                            onPressed: () {
                              if (nameController.text.trim().isEmpty) return;

                              ref
                                  .read(petProvider.notifier)
                                  .createPet(
                                    nameController.text.trim(),
                                    personality: selectedPersonality,
                                  );

                              Navigator.pop(ctx);
                            },
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = ref.watch(petProvider);
    final player = ref.watch(playerProvider);

    return HomeBackgroundAnimation(
      playerName: player.name,
      pet: pet,

      buildWelcomeHeader: (name) => WelcomeHeader(name: name),

      buildPetCard: (p) => PetCard(pet: p),

      buildQuickActions: (p) => QuickActionsCard(pet: p),

      buildStatsCard: (p) =>
          PetStatsCard(pet: p, formatTimeAgo: _formatTimeAgo),
      buildNoPetCard: CreatePetCard(onCreatePressed: _showCreatePetDialog),
      buildDailyReward: const DailyRewardCard(),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}