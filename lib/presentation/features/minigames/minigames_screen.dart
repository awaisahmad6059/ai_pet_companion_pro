import 'package:flutter/material.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/animated_bg.dart';
import 'package:ai_pet_companion_pro/game/systems/tap_catch_game.dart';

class MinigamesScreen extends StatelessWidget {
  const MinigamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Mini Games')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Play games to earn coins & XP!',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _GameCard(
                      title: 'Tap Catch',
                      description: 'Catch falling items!',
                      icon: Icons.touch_app_rounded,
                      gradient: const [
                        ColorConstants.primary,
                        Color(0xFF8B5CF6),
                      ],
                      onTap: () => _openGame(context, 'tap_catch'),
                    ),
                    _GameCard(
                      title: 'Memory Match',
                      description: 'Match the pairs!',
                      icon: Icons.psychology_rounded,
                      gradient: const [
                        ColorConstants.secondary,
                        Color(0xFFFF8A80),
                      ],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Coming soon!'),
                              duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                    _GameCard(
                      title: 'Endless Runner',
                      description: 'Run & collect!',
                      icon: Icons.directions_run_rounded,
                      gradient: const [
                        Color(0xFF00D9FF),
                        Color(0xFF00BFA5),
                      ],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Coming soon!'),
                              duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                    _GameCard(
                      title: 'Puzzle',
                      description: 'Solve the puzzle!',
                      icon: Icons.extension_rounded,
                      gradient: const [
                        Color(0xFFFFD700),
                        Color(0xFFFF8F00),
                      ],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Coming soon!'),
                              duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openGame(BuildContext context, String gameId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TapCatchGameScreen(),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _GameCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                  fontSize: 11, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
