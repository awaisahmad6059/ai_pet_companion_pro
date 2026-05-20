import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Helpers {
  Helpers._();

  static double lerpDouble(double a, double b, double t) =>
      a + (b - a) * t.clamp(0.0, 1.0);

  static String formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  static String formatCoins(int coins) {
    if (coins >= 1000000) return '${(coins / 1000000).toStringAsFixed(1)}M';
    if (coins >= 1000) return '${(coins / 1000).toStringAsFixed(1)}K';
    return coins.toString();
  }

  static int xpForLevel(int level) {
    return (100 * level * 1.5).round();
  }

  static double clampStat(double value) => value.clamp(0, 100);

  static int randomInRange(int min, int max) =>
      min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1));

  static void vibrate(BuildContext context) {
    HapticFeedback.lightImpact();
  }

  static String moodEmoji(double happiness) {
    if (happiness >= 80) return '😄';
    if (happiness >= 60) return '🙂';
    if (happiness >= 40) return '😐';
    if (happiness >= 20) return '😢';
    return '😭';
  }

  static String moodText(double happiness) {
    if (happiness >= 80) return 'Joyful';
    if (happiness >= 60) return 'Happy';
    if (happiness >= 40) return 'Neutral';
    if (happiness >= 20) return 'Sad';
    return 'Miserable';
  }

  static Color moodColor(double happiness) {
    if (happiness >= 80) return Colors.green;
    if (happiness >= 60) return Colors.lightGreen;
    if (happiness >= 40) return Colors.orange;
    if (happiness >= 20) return Colors.deepOrange;
    return Colors.red;
  }
}
