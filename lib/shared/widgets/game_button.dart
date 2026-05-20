import 'package:flutter/material.dart';
import 'package:ai_pet_companion_pro/core/constants/color_constants.dart';

class GameButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool expanded;
  final List<Color>? gradient;
  final Color? textColor;
  final double? fontSize;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const GameButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.expanded = true,
    this.gradient,
    this.textColor,
    this.fontSize,
    this.borderRadius = 16,
    this.padding,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.gradient ?? ColorConstants.premiumGradient;

    return ListenableBuilder(
      listenable: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: SizedBox(
            width: widget.expanded ? double.infinity : null,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTapDown: widget.onPressed != null && !widget.isLoading
                    ? (_) {
                        _pulseController.forward();
                        setState(() => _isPressed = true);
                      }
                    : null,
                onTapUp: widget.onPressed != null && !widget.isLoading
                    ? (_) {
                        _pulseController.reverse();
                        setState(() => _isPressed = false);
                      }
                    : null,
                onTapCancel: () {
                  _pulseController.reverse();
                  setState(() => _isPressed = false);
                },
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                splashColor: Colors.white.withValues(alpha: 0.1),
                highlightColor: Colors.transparent,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius),
                    gradient: LinearGradient(
                      colors: _isPressed
                          ? [
                              gradient[0].withValues(alpha: 0.8),
                              gradient[1].withValues(alpha: 0.8),
                            ]
                          : gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withValues(alpha: _isPressed ? 0.2 : 0.4),
                        blurRadius: _isPressed ? 8 : 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: widget.isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon,
                                  color: widget.textColor ?? Colors.white,
                                  size: 20),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.text,
                              style: TextStyle(
                                color: widget.textColor ?? Colors.white,
                                fontSize: widget.fontSize ?? 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
