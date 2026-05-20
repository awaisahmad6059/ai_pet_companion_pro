import 'package:flutter/material.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/game_button.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';

class CreatePetCard extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const CreatePetCard({
    super.key,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glowing: true,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(
            Icons.pets_rounded,
            size: 80,
            color: ColorConstants.primary,
          ),

          const SizedBox(height: 16),

          const Text(
            'No Pet Yet!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Create your first virtual companion\nand start your adventure!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          GameButton(
            text: 'Create Pet',
            icon: Icons.add_rounded,
            onPressed: onCreatePressed,
          ),
        ],
      ),
    );
  }
}