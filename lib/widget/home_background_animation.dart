import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:ai_pet_companion_pro/shared/widgets/animated_bg.dart';
import 'package:flutter/material.dart';
import 'package:ai_pet_companion_pro/shared/animations/fade_scale_animation.dart';
import 'package:ai_pet_companion_pro/shared/widgets/hud_widget.dart';

class HomeBackgroundAnimation extends StatelessWidget {
  final String playerName;
  final PetEntity? pet;

  final Widget Function(String) buildWelcomeHeader;
  final Widget Function(PetEntity) buildPetCard;
  final Widget Function(PetEntity) buildQuickActions;
  final Widget Function(PetEntity) buildStatsCard;
  final Widget buildNoPetCard;
  final Widget buildDailyReward;

  const HomeBackgroundAnimation({
    super.key,
    required this.playerName,
    required this.pet,
    required this.buildWelcomeHeader,
    required this.buildPetCard,
    required this.buildQuickActions,
    required this.buildStatsCard,
    required this.buildNoPetCard,
    required this.buildDailyReward,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const HudWidget(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      FadeScaleAnimation(
                        index: 0,
                        child: buildWelcomeHeader(playerName),
                      ),

                      const SizedBox(height: 20),

                      if (pet != null) ...[
                        FadeScaleAnimation(index: 1, child: buildPetCard(pet!)),
                        const SizedBox(height: 16),

                        FadeScaleAnimation(
                          index: 2,
                          child: buildQuickActions(pet!),
                        ),
                        const SizedBox(height: 16),

                        FadeScaleAnimation(
                          index: 3,
                          child: buildStatsCard(pet!),
                        ),
                      ] else
                        FadeScaleAnimation(index: 1, child: buildNoPetCard),

                      const SizedBox(height: 16),

                      FadeScaleAnimation(index: 4, child: buildDailyReward),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
