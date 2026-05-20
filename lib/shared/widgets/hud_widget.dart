import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/core/utils/helpers.dart';
import 'package:ai_pet_companion_pro/presentation/providers/player_provider.dart';

class HudWidget extends ConsumerWidget {
  const HudWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDark
                ? ColorConstants.darkBg.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _HudItem(
              icon: Icons.stars_rounded,
              value: 'Lv.${player.level}',
              color: ColorConstants.xpColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: player.levelProgress,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(ColorConstants.xpColor),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 16),
            _HudItem(
              icon: Icons.monetization_on_rounded,
              value: Helpers.formatCoins(player.coins),
              color: ColorConstants.coinColor,
            ),
            const SizedBox(width: 8),
            _HudItem(
              icon: Icons.bolt_rounded,
              value: '${player.totalGamesPlayed}',
              color: ColorConstants.energyColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _HudItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _HudItem({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
