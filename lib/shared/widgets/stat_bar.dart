import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final Color color;
  final bool showValue;

  const StatBar({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.color,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 100.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
            if (showValue)
              Text(
                '${clampedValue.toInt()}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: clampedValue / 100,
            backgroundColor: Colors.grey.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class StatBarsRow extends StatelessWidget {
  final double hunger;
  final double happiness;
  final double energy;
  final double hygiene;

  const StatBarsRow({
    super.key,
    required this.hunger,
    required this.happiness,
    required this.energy,
    required this.hygiene,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatBar(
          label: 'Hunger',
          icon: Icons.restaurant_rounded,
          value: hunger,
          color: Colors.orange,
        ),
        const SizedBox(height: 6),
        StatBar(
          label: 'Happiness',
          icon: Icons.favorite_rounded,
          value: happiness,
          color: Colors.pink,
        ),
        const SizedBox(height: 6),
        StatBar(
          label: 'Energy',
          icon: Icons.bolt_rounded,
          value: energy,
          color: Colors.amber,
        ),
        const SizedBox(height: 6),
        StatBar(
          label: 'Hygiene',
          icon: Icons.clean_hands_rounded,
          value: hygiene,
          color: Colors.cyan,
        ),
      ],
    );
  }
}
