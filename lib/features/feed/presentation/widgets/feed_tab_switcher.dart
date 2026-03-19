import 'package:flutter/material.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/feed/presentation/models/feed_models.dart';

class FeedTabSwitcher extends StatelessWidget {
  const FeedTabSwitcher({
    super.key,
    required this.activeTab,
    required this.onChanged,
  });

  final FeedTab activeTab;
  final ValueChanged<FeedTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _TabButton(
          label: '提醒',
          active: activeTab == FeedTab.reminders,
          onTap: () => onChanged(FeedTab.reminders),
        ),
        const SizedBox(width: 34),
        _TabButton(
          label: '社交',
          active: activeTab == FeedTab.social,
          onTap: () => onChanged(FeedTab.social),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedDefaultTextStyle(
              duration: AppTheme.normalDuration,
              curve: Curves.easeOutCubic,
              style: TextStyle(
                color: active
                    ? AppTheme.accentColor
                    : const Color(0xFFD8D6E6).withValues(alpha: 0.82),
                fontSize: 18,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: AppTheme.normalDuration,
              curve: Curves.easeOutCubic,
              width: active ? 34 : 0,
              height: 2.5,
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
