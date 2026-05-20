import 'package:flutter/material.dart';
import 'package:ai_pet_companion_pro/shared/widgets/game_button.dart';

class CreateCustomButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateCustomButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GameButton(
      text: 'Create!',
      onPressed: onPressed,
      expanded: false,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
    );
  }
}