import 'package:flutter/material.dart';
import 'package:mealtime/core/theme/app_theme.dart';

class EntranceSection extends StatelessWidget {
  const EntranceSection({
    super.key,
    required this.visible,
    required this.child,
  });

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: AppTheme.slowDuration,
      curve: Curves.easeOutCubic,
      offset: visible ? Offset.zero : const Offset(0, 0.12),
      child: AnimatedOpacity(
        duration: AppTheme.slowDuration,
        curve: Curves.easeOutCubic,
        opacity: visible ? 1 : 0,
        child: child,
      ),
    );
  }
}
