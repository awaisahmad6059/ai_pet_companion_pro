import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pet_companion_pro/core/constants/app_constants.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/game_button.dart';

import 'package:ai_pet_companion_pro/presentation/providers/daily_reward_provider.dart';

class DailyRewardCard extends ConsumerWidget {
  const DailyRewardCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardState = ref.watch(dailyRewardProvider);

    String statusText;

    if (rewardState.canClaim) {
      statusText =
          'Claim your daily +${AppConstants.dailyRewardCoins} coins!';
    } else {
      final hours = rewardState.timeRemaining.inHours;
      final minutes = rewardState.timeRemaining.inMinutes.remainder(60);
      final seconds = rewardState.timeRemaining.inSeconds.remainder(60);

      if (hours > 0) {
        statusText =
            'Next claim in ${hours}h ${minutes.toString().padLeft(2, '0')}m';
      } else if (minutes > 0) {
        statusText =
            'Next claim in ${minutes}m ${seconds.toString().padLeft(2, '0')}s';
      } else {
        statusText = 'Next claim in ${seconds}s';
      }
    }

    final isDisabled = !rewardState.canClaim || rewardState.isLoading;

    return GlassCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: rewardState.canClaim
                  ? ColorConstants.coinColor.withValues(alpha: 0.15)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color:
                  rewardState.canClaim ? ColorConstants.coinColor : Colors.grey,
              size: 28,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Bonus',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: rewardState.canClaim ? null : Colors.grey,
                  ),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    color: rewardState.canClaim
                        ? Colors.grey[500]
                        : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          Stack(
            children: [
              /// 🔥 MAIN BUTTON
              GameButton(
                text: rewardState.isLoading
                    ? 'Claiming...'
                    : rewardState.canClaim
                        ? 'Claim'
                        : 'Claimed',
                isLoading: rewardState.isLoading,
                onPressed: rewardState.canClaim && !rewardState.isLoading
                    ? () async {
                        final messenger = ScaffoldMessenger.of(context);

                        final result = await ref
                            .read(dailyRewardProvider.notifier)
                            .claim();

                        if (!context.mounted) return;

                        if (result == ClaimResult.success) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content:
                                  Text('🎉 Reward Claimed Successfully!'),
                              backgroundColor: ColorConstants.success,
                            ),
                          );
                        }
                      }
                    : null,
                expanded: false,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                fontSize: 13,
                gradient: rewardState.canClaim
                    ? ColorConstants.premiumGradient
                    : [Colors.grey, Colors.grey],
              ),

              /// 🔥 OVERLAY (for disabled click)
              if (isDisabled)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              rewardState.isLoading
                                  ? 'Please wait...'
                                  : '⏳ Come back after ${statusText}',
                            ),
                            backgroundColor: ColorConstants.warning,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}