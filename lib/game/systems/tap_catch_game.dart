import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/game/engine/minigame_base.dart';
import 'package:ai_pet_companion_pro/presentation/providers/player_provider.dart';
import 'package:ai_pet_companion_pro/shared/widgets/glass_card.dart';
import 'package:ai_pet_companion_pro/shared/widgets/game_button.dart';
import 'package:ai_pet_companion_pro/shared/widgets/animated_bg.dart';

class TapCatchGame extends MiniGameBase {
  @override
  String get gameName => 'Tap Catch';

  @override
  IconData get gameIcon => Icons.touch_app_rounded;

  final List<_FallingItem> _items = [];
  final Random _random = Random();
  int _caught = 0;
  int _missed = 0;
  double _speed = 1.0;

  List<_FallingItem> get items => _items;
  int get caught => _caught;
  int get missed => _missed;

  @override
  void onGameStart() {
    _items.clear();
    _caught = 0;
    _missed = 0;
    _speed = 1.0;
    timeLimit = const Duration(seconds: 30);
  }

  @override
  void onGameEnd() {}

  @override
  void onGamePause() {}

  @override
  void onGameResume() {}

  @override
  void onScoreChanged(int newScore) {}

  @override
  void onReset() {
    _items.clear();
    _caught = 0;
    _missed = 0;
  }

  void spawnItem(Size screenSize) {
    if (state != GameState.playing) return;
    final x = _random.nextDouble() * (screenSize.width - 60);
    final type = _random.nextDouble() < 0.2 ? _ItemType.bad : _ItemType.good;
    final value = type == _ItemType.good
        ? (_random.nextInt(3) + 1) * 5
        : -10;
    _items.add(_FallingItem(
      x: x,
      y: -40,
      type: type,
      value: value,
      speed: 120 + _speed * 60,
    ));
  }

  void updateItems(double dt, Size screenSize) {
    final toRemove = <_FallingItem>[];
    for (final item in _items) {
      item.y += item.speed * dt;
      if (item.y > screenSize.height + 40) {
        toRemove.add(item);
        if (item.type == _ItemType.good) _missed++;
      }
    }
    _items.removeWhere((i) => toRemove.contains(i));

    final elapsed = (DateTime.now().millisecondsSinceEpoch % 30000) / 1000;
    _speed = 1.0 + elapsed * 0.05;
  }

  void tapItem(Offset position) {
    for (int i = _items.length - 1; i >= 0; i--) {
      final item = _items[i];
      final hitBox = Rect.fromLTWH(item.x, item.y, 50, 50);
      if (hitBox.contains(position)) {
        if (item.type == _ItemType.good) {
          _caught++;
          addScore(item.value);
        } else {
          addScore(item.value);
        }
        _items.removeAt(i);
        break;
      }
    }
  }

}

class _FallingItem {
  double x;
  double y;
  final _ItemType type;
  final int value;
  final double speed;

  _FallingItem({
    required this.x,
    required this.y,
    required this.type,
    required this.value,
    required this.speed,
  });
}

enum _ItemType { good, bad }

class TapCatchGameScreen extends ConsumerStatefulWidget {
  const TapCatchGameScreen({super.key});

  @override
  ConsumerState<TapCatchGameScreen> createState() =>
      _TapCatchGameScreenState();
}

class _TapCatchGameScreenState extends ConsumerState<TapCatchGameScreen>
    with TickerProviderStateMixin {
  final TapCatchGame _game = TapCatchGame();
  late AnimationController _gameLoop;
  DateTime? _lastUpdate;
  int _combo = 0;

  @override
  void initState() {
    super.initState();
    _gameLoop = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_update);
    _gameLoop.repeat();
  }

  @override
  void dispose() {
    _gameLoop.dispose();
    _game.dispose();
    super.dispose();
  }

  void _update() {
    if (_game.state != GameState.playing) return;
    final now = DateTime.now();
    final dt = _lastUpdate != null
        ? now.difference(_lastUpdate!).inMilliseconds / 1000.0
        : 0.016;
    _lastUpdate = now;

    final size = MediaQuery.of(context).size;
    if (_game.items.length < 8 && _randomChance(0.05)) {
      _game.spawnItem(size);
    }
    _game.updateItems(dt, size);
    setState(() {});
  }

  bool _randomChance(double probability) {
    return Random().nextDouble() < probability;
  }

  void _startGame() {
    _game.startGame();
    _combo = 0;
    _lastUpdate = null;
    setState(() {});
  }

  void _onTap(Offset position) {
    if (_game.state != GameState.playing) return;
    final prevScore = _game.score;
    _game.tapItem(position);
    if (_game.score > prevScore) {
      _combo++;
    } else if (_game.score < prevScore) {
      _combo = 0;
    }
    setState(() {});
  }

  void _endGame() {
    _game.endGame();
    final coinReward = _game.calculateCoinReward();
    final xpReward = _game.calculateXpReward();

    ref.read(playerProvider.notifier).addCoins(coinReward);
    ref.read(playerProvider.notifier).addXp(xpReward);
    ref.read(playerProvider.notifier).incrementGamesPlayed();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        title: const Text('Game Over!',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.celebration_rounded,
                size: 64, color: ColorConstants.coinColor),
            const SizedBox(height: 16),
            Text('Score: ${_game.score}',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('Caught: ${_game.caught}  |  Missed: ${_game.missed}',
                style: TextStyle(color: Colors.grey[500])),
            const SizedBox(height: 16),
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.monetization_on_rounded,
                          color: ColorConstants.coinColor),
                      Text('+$coinReward',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.stars_rounded,
                          color: ColorConstants.xpColor),
                      Text('+$xpReward',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
          GameButton(
            text: 'Play Again',
            onPressed: () {
              Navigator.pop(ctx);
              _game.reset();
              _startGame();
            },
            expanded: false,
            padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        showParticles: false,
        child: Stack(
          children: [
            if (_game.state == GameState.playing) ...[
              GestureDetector(
                onTapDown: (details) => _onTap(details.localPosition),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: _TapCatchPainter(
                      items: _game.items,
                    ),
                  ),
                ),
              ),
              _buildGameHud(),
              if (_combo >= 3)
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3,
                  left: 0,
                  right: 0,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 1 + (1 - value) * 0.3,
                          child: Text(
                            '${_combo}x Combo!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28 + (1 - value) * 10,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.coinColor,
                              shadows: [
                                Shadow(
                                  color: ColorConstants.coinColor
                                      .withValues(alpha: 0.5),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ] else if (_game.state == GameState.gameOver) ...[
              // handled by dialog
            ] else ...[
              _buildStartScreen(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGameHud() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: _endGame,
              child: const Icon(Icons.close_rounded,
                  color: Colors.white, size: 28),
            ),
            Column(
              children: [
                const Text('SCORE',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 10)),
                Text('${_game.score}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              children: [
                const Text('CAUGHT',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 10)),
                Text('${_game.caught}',
                    style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConstants.primary.withValues(alpha: 0.15),
              ),
              child: const Icon(Icons.touch_app_rounded,
                  size: 64, color: ColorConstants.primary),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tap Catch',
              style: TextStyle(
                  fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Catch the good items!\nAvoid the bad ones!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: Colors.grey[500], height: 1.5),
            ),
            const SizedBox(height: 8),
            Text(
              'High Score: ${_game.highScore}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.coinColor),
            ),
            const SizedBox(height: 32),
            GameButton(
              text: 'Start Game',
              icon: Icons.play_arrow_rounded,
              onPressed: _startGame,
            ),
          ],
        ),
      ),
    );
  }
}

class _TapCatchPainter extends CustomPainter {
  final List<_FallingItem> items;

  _TapCatchPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    for (final item in items) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(item.x, item.y, 50, 50),
        const Radius.circular(12),
      );

      if (item.type == _ItemType.good) {
        final paint = Paint()
          ..shader = LinearGradient(
            colors: [
              ColorConstants.success,
              ColorConstants.success.withValues(alpha: 0.7),
            ],
          ).createShader(rect.outerRect);

        canvas.drawRRect(rect, paint);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '+${item.value}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            item.x + (50 - textPainter.width) / 2,
            item.y + (50 - textPainter.height) / 2,
          ),
        );
      } else {
        final paint = Paint()
          ..shader = LinearGradient(
            colors: [
              ColorConstants.error,
              ColorConstants.error.withValues(alpha: 0.7),
            ],
          ).createShader(rect.outerRect);

        canvas.drawRRect(rect, paint);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '✕',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            item.x + (50 - textPainter.width) / 2,
            item.y + (50 - textPainter.height) / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_TapCatchPainter oldDelegate) => true;
}
