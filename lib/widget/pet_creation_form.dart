import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';
import 'package:flutter/material.dart';

class PetCreationForm extends StatelessWidget {
  final TextEditingController nameController;
  final Personality selectedPersonality;
  final Function(Personality) onPersonalitySelected;

  const PetCreationForm({
    super.key,
    required this.nameController,
    required this.selectedPersonality,
    required this.onPersonalitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final labels = {
      Personality.playful: 'Playful',
      Personality.lazy: 'Lazy',
      Personality.grumpy: 'Grumpy',
      Personality.affectionate: 'Affectionate',
      Personality.independent: 'Independent',
    };

    final emojis = {
      Personality.playful: '🎾',
      Personality.lazy: '😴',
      Personality.grumpy: '😤',
      Personality.affectionate: '🥰',
      Personality.independent: '🦸',
    };

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Pet Name',
            hintText: 'Enter a name...',
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.1),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Choose Personality:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 220,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Personality.values.map((p) {
                return ChoiceChip(
                  label: Text(
                    '${emojis[p]} ${labels[p]}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  selected: selectedPersonality == p,
                  selectedColor: Colors.black,
                  backgroundColor: Colors.grey[800],
                  checkmarkColor: Colors.white,
                  labelStyle: const TextStyle(color: Colors.white),
                  onSelected: (_) => onPersonalitySelected(p),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
