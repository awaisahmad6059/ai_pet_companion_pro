import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_pet_companion_pro/presentation/providers/theme_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/daily_reward_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/player_provider.dart';
import 'package:ai_pet_companion_pro/presentation/providers/pet_provider.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/game_button.dart';
import 'package:ai_pet_companion_pro/shared/widgets/animated_bg.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final player = ref.watch(playerProvider);
    final pet = ref.watch(petProvider);
    final isDark = themeMode == ThemeMode.dark;

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              title: 'Appearance',
              children: [
                GlassCard(
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ColorConstants.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        color: ColorConstants.primary,
                      ),
                    ),
                    title: const Text('Dark Mode',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(isDark ? 'Enabled' : 'Disabled',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[500])),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) {
                        ref.read(themeProvider.notifier).toggleTheme();
                      },
                      activeColor: ColorConstants.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Player Stats',
              children: [
                GlassCard(
                  child: Column(
                    children: [
                      _StatRow(
                        icon: Icons.person_rounded,
                        label: 'Name',
                        value: player.name,
                      ),
                      const Divider(height: 1),
                      _StatRow(
                        icon: Icons.stars_rounded,
                        label: 'Level',
                        value: '${player.level}',
                      ),
                      const Divider(height: 1),
                      _StatRow(
                        icon: Icons.monetization_on_rounded,
                        label: 'Coins',
                        value: '${player.coins}',
                      ),
                      const Divider(height: 1),
                      _StatRow(
                        icon: Icons.emoji_events_rounded,
                        label: 'Games Played',
                        value: '${player.totalGamesPlayed}',
                      ),
                      const Divider(height: 1),
                      _StatRow(
                        icon: Icons.flag_rounded,
                        label: 'Quests Done',
                        value: '${player.totalQuestsCompleted}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Pet Info',
              children: [
                GlassCard(
                  child: Column(
                    children: [
                      _StatRow(
                        icon: Icons.pets_rounded,
                        label: 'Pet Name',
                        value: pet?.name ?? 'None',
                      ),
                      if (pet != null) ...[
                        const Divider(height: 1),
                        _StatRow(
                          icon: Icons.favorite_rounded,
                          label: 'Affection',
                          value: '${pet.affection}',
                        ),
                        const Divider(height: 1),
                        _StatRow(
                          icon: Icons.access_time_rounded,
                          label: 'Created',
                          value:
                              '${pet.createdAt.day}/${pet.createdAt.month}/${pet.createdAt.year}',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'About',
              children: [
                GlassCard(
                  child: Column(
                    children: [
                      _StatRow(
                        icon: Icons.info_rounded,
                        label: 'Version',
                        value: AppConstants.version,
                      ),
                      const Divider(height: 1),
                      _StatRow(
                        icon: Icons.memory_rounded,
                        label: 'Engine',
                        value: 'Flutter + Flame',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GameButton(
              text: 'Reset Game Data',
              icon: Icons.delete_forever_rounded,
              onPressed: () => _showResetDialog(context, ref),
              gradient: [Colors.red, Colors.deepOrange],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        title: const Text('Reset Game?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'This will delete all your progress including pets, coins, and items. This cannot be undone!',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          GameButton(
            text: 'Reset',
            onPressed: () async {
              Navigator.pop(ctx);

              // Reset all game data
              ref.read(playerProvider.notifier).reset();
              ref.read(petProvider.notifier).reset();
              try {
                ref.read(dailyRewardProvider.notifier).reset();
              } catch (_) {}

              // Navigate to home
              context.go('/home');

              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Game data has been reset'),
                  backgroundColor: ColorConstants.success,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            expanded: false,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            gradient: [Colors.red, Colors.deepOrange],
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ColorConstants.primary),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.primary)),
        ],
      ),
    );
  }
}
