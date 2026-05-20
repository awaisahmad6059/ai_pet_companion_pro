import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/presentation/providers/quest_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/player_provider.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/game_button.dart';
import 'package:ai_pet_companion_pro/shared/widgets/animated_bg.dart';
import 'package:ai_pet_companion_pro/shared/animations/fade_scale_animation.dart';

class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(questsProvider);
    final player = ref.watch(playerProvider);

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Quests'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded,
                      color: ColorConstants.xpColor, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Lv.${player.level}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: GlassCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Quest Progress',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            '${quests.where((q) => q.status == QuestStatus.completed).length}/${quests.length} completed',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: quests.isEmpty
                              ? 0
                              : quests
                                      .where((q) =>
                                          q.status == QuestStatus.completed)
                                      .length /
                                  quests.length,
                          backgroundColor:
                              Colors.grey.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation(
                              ColorConstants.xpColor),
                          minHeight: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: quests.isEmpty
                  ? const Center(child: Text('No quests available'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: quests.length,
                      itemBuilder: (context, index) => FadeScaleAnimation(
                        index: index,
                        child: _QuestCard(
                          quest: quests[index],
                          onClaim: () =>
                              _claimQuest(context, ref, quests[index]),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _claimQuest(BuildContext context, WidgetRef ref, QuestEntity quest) {
    if (quest.status != QuestStatus.completed) return;
    ref.read(questRepositoryProvider).claimQuest(quest.id);
    ref.read(playerProvider.notifier).addCoins(quest.coinReward);
    ref.read(playerProvider.notifier).addXp(quest.xpReward);
    ref.read(playerProvider.notifier).incrementQuestsCompleted();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('+${quest.coinReward} coins, +${quest.xpReward} XP!'),
        backgroundColor: ColorConstants.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  final QuestEntity quest;
  final VoidCallback onClaim;

  const _QuestCard({required this.quest, required this.onClaim});

  IconData _typeIcon(QuestType type) {
    switch (type) {
      case QuestType.daily:
        return Icons.today_rounded;
      case QuestType.weekly:
        return Icons.date_range_rounded;
      case QuestType.achievement:
        return Icons.emoji_events_rounded;
    }
  }

  Color _statusColor(QuestStatus status) {
    switch (status) {
      case QuestStatus.active:
        return Colors.orange;
      case QuestStatus.completed:
        return ColorConstants.success;
      case QuestStatus.claimed:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(quest.status);
    final isComplete = quest.status == QuestStatus.completed;
    final isClaimed = quest.status == QuestStatus.claimed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_typeIcon(quest.type),
                  color: statusColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    quest.description,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: quest.progressFraction,
                            backgroundColor:
                                Colors.grey.withValues(alpha: 0.15),
                            valueColor: AlwaysStoppedAnimation(statusColor),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${quest.progress}/${quest.target}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isComplete)
              GameButton(
                text: 'Claim',
                onPressed: onClaim,
                expanded: false,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                fontSize: 11,
                gradient: [
                  ColorConstants.success,
                  ColorConstants.success.withValues(alpha: 0.7),
                ],
              )
            else if (isClaimed)
              const Icon(Icons.check_circle,
                  color: ColorConstants.success, size: 24)
            else
              Column(
                children: [
                  Icon(Icons.monetization_on_rounded,
                      size: 14, color: ColorConstants.coinColor),
                  Text('${quest.coinReward}',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold)),
                  Icon(Icons.stars_rounded,
                      size: 14, color: ColorConstants.xpColor),
                  Text('${quest.xpReward}',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
