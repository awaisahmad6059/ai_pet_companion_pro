import 'package:flutter/material.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';
import 'package:ai_pet_companion_pro/domain/entities/pet_entity.dart';

class PetAvatar extends StatefulWidget {
  final PetEntity? pet;
  final double size;
  final bool animated;

  const PetAvatar({
    super.key,
    this.pet,
    this.size = 120,
    this.animated = true,
  });

  @override
  State<PetAvatar> createState() => _PetAvatarState();
}

class _PetAvatarState extends State<PetAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bounceAnimation = Tween<double>(begin: 0, end: 0.05).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Color _getMoodColor() {
    if (widget.pet == null) return ColorConstants.primary;
    return switch (widget.pet!.mood) {
      PetMood.joyful => Colors.green,
      PetMood.happy => Colors.lightGreen,
      PetMood.neutral => Colors.orange,
      PetMood.sad => Colors.deepOrange,
      PetMood.miserable => Colors.red,
    };
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    final moodColor = _getMoodColor();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          setState(() => _isHovered = !_isHovered);
        },
        child: ListenableBuilder(
          listenable: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _bounceAnimation.value * widget.size),
              child: child,
            );
          },
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  ColorConstants.primary,
                  ColorConstants.secondary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: moodColor.withValues(alpha: _isHovered ? 0.6 : 0.3),
                  blurRadius: _isHovered ? 30 : 15,
                  spreadRadius: _isHovered ? 5 : 2,
                ),
              ],
            ),
            child: CustomPaint(
              painter: _PetFacePainter(
                mood: pet?.mood ?? PetMood.happy,
                isSleeping: pet?.isSleeping ?? false,
                personality: pet?.personality ?? Personality.playful,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PetFacePainter extends CustomPainter {
  final PetMood mood;
  final bool isSleeping;
  final Personality personality;

  _PetFacePainter({
    required this.mood,
    required this.isSleeping,
    required this.personality,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    if (isSleeping) {
      _drawSleepingFace(canvas, center, radius, size);
      return;
    }

    _drawEyes(canvas, center, radius, size);
    _drawMouth(canvas, center, radius, size);
    _drawCheeks(canvas, center, radius, size);
    _drawAccessories(canvas, center, radius, size);
  }

  void _drawEyes(Canvas canvas, Offset center, double r, Size size) {
    final eyeY = center.dy - r * 0.2;
    final eyeSpacing = r * 0.35;
    final eyeRadius = r * 0.12;

    final leftEye = Offset(center.dx - eyeSpacing, eyeY);
    final rightEye = Offset(center.dx + eyeSpacing, eyeY);

    if (mood == PetMood.sad || mood == PetMood.miserable) {
      _drawSadEyes(canvas, leftEye, rightEye, eyeRadius);
    } else {
      _drawHappyEyes(canvas, leftEye, rightEye, eyeRadius);
    }
  }

  void _drawHappyEyes(Canvas canvas, Offset left, Offset right, double r) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(left, r * 1.5, paint);
    canvas.drawCircle(right, r * 1.5, paint);

    final pupilPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    canvas.drawCircle(left, r * 0.8, pupilPaint);
    canvas.drawCircle(right, r * 0.8, pupilPaint);

    final highlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(left.dx - r * 0.3, left.dy - r * 0.3), r * 0.3,
        highlightPaint);
    canvas.drawCircle(Offset(right.dx - r * 0.3, right.dy - r * 0.3), r * 0.3,
        highlightPaint);
  }

  void _drawSadEyes(Canvas canvas, Offset left, Offset right, double r) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(left, r * 1.3, paint);
    canvas.drawCircle(right, r * 1.3, paint);

    final pupilPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(left.dx, left.dy + r * 0.2), r * 0.7, pupilPaint);
    canvas.drawCircle(
        Offset(right.dx, right.dy + r * 0.2), r * 0.7, pupilPaint);
  }

  void _drawMouth(Canvas canvas, Offset center, double r, Size size) {
    final mouthY = center.dy + r * 0.4;
    final mouthPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    switch (mood) {
      case PetMood.joyful:
        _drawBigSmile(canvas, center, r, mouthY);
        break;
      case PetMood.happy:
        _drawSmile(canvas, center, r, mouthY);
        break;
      case PetMood.neutral:
        canvas.drawLine(
          Offset(center.dx - r * 0.2, mouthY),
          Offset(center.dx + r * 0.2, mouthY),
          mouthPaint,
        );
        break;
      case PetMood.sad:
        _drawFrown(canvas, center, r, mouthY);
        break;
      case PetMood.miserable:
        _drawFrown(canvas, center, r, mouthY);
        _drawTear(canvas, center, r);
        break;
    }
  }

  void _drawSmile(Canvas canvas, Offset center, double r, double mouthY) {
    final path = Path()
      ..moveTo(center.dx - r * 0.25, mouthY)
      ..quadraticBezierTo(
          center.dx, mouthY + r * 0.2, center.dx + r * 0.25, mouthY);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  void _drawBigSmile(Canvas canvas, Offset center, double r, double mouthY) {
    final path = Path()
      ..moveTo(center.dx - r * 0.3, mouthY)
      ..quadraticBezierTo(
          center.dx, mouthY + r * 0.3, center.dx + r * 0.3, mouthY);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  void _drawFrown(Canvas canvas, Offset center, double r, double mouthY) {
    final path = Path()
      ..moveTo(center.dx - r * 0.2, mouthY + r * 0.1)
      ..quadraticBezierTo(
          center.dx, mouthY - r * 0.05, center.dx + r * 0.2, mouthY + r * 0.1);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
  }

  void _drawTear(Canvas canvas, Offset center, double r) {
    final tearPaint = Paint()
      ..color = const Color(0xFF64B5F6).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(center.dx - r * 0.4, center.dy + r * 0.2), r * 0.08, tearPaint);
  }

  void _drawCheeks(Canvas canvas, Offset center, double r, Size size) {
    if (mood == PetMood.happy || mood == PetMood.joyful) {
      final cheekPaint = Paint()
        ..color = Colors.pink.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          Offset(center.dx - r * 0.5, center.dy + r * 0.15), r * 0.12,
          cheekPaint);
      canvas.drawCircle(
          Offset(center.dx + r * 0.5, center.dy + r * 0.15), r * 0.12,
          cheekPaint);
    }
  }

  void _drawAccessories(Canvas canvas, Offset center, double r, Size size) {
    if (personality == Personality.grumpy) {
      final browPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(center.dx - r * 0.4, center.dy - r * 0.4),
        Offset(center.dx - r * 0.2, center.dy - r * 0.3),
        browPaint,
      );
      canvas.drawLine(
        Offset(center.dx + r * 0.4, center.dy - r * 0.4),
        Offset(center.dx + r * 0.2, center.dy - r * 0.3),
        browPaint,
      );
    }
  }

  void _drawSleepingFace(
      Canvas canvas, Offset center, double r, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx - r * 0.25, center.dy - r * 0.1),
      Offset(center.dx - r * 0.1, center.dy - r * 0.15),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - r * 0.1, center.dy - r * 0.15),
      Offset(center.dx + r * 0.05, center.dy - r * 0.1),
      paint,
    );

    canvas.drawLine(
      Offset(center.dx + r * 0.05, center.dy - r * 0.1),
      Offset(center.dx + r * 0.2, center.dy - r * 0.15),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + r * 0.2, center.dy - r * 0.15),
      Offset(center.dx + r * 0.35, center.dy - r * 0.1),
      paint,
    );

    final zPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(center.dx + r * 0.3, center.dy - r * 0.3),
      Offset(center.dx + r * 0.3, center.dy - r * 0.4),
      zPaint,
    );
    canvas.drawLine(
      Offset(center.dx + r * 0.3, center.dy - r * 0.4),
      Offset(center.dx + r * 0.4, center.dy - r * 0.4),
      zPaint,
    );
  }

  @override
  bool shouldRepaint(_PetFacePainter oldDelegate) =>
      oldDelegate.mood != mood ||
      oldDelegate.isSleeping != isSleeping ||
      oldDelegate.personality != personality;
}
