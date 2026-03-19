import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/theme/app_theme.dart';

class BottomNavItemData {
  const BottomNavItemData({required this.iconAsset, required this.label});

  final String iconAsset;
  final String label;
}

class FloatingBottomNav extends StatelessWidget {
  const FloatingBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.onTap,
  }) : assert(items.length == 4, 'Bottom nav expects exactly 4 items.');

  final List<BottomNavItemData> items;
  final int selectedIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 40,
            offset: Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<Widget>.generate(items.length, (int index) {
          final BottomNavItemData item = items[index];
          return _NavItem(
            iconAsset: item.iconAsset,
            label: item.label,
            active: index == selectedIndex,
            onTap: () => onTap?.call(index),
          );
        }),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.iconAsset,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String iconAsset;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = active
        ? AppTheme.accentColor
        : Colors.white.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        duration: AppTheme.fastDuration,
        scale: active ? 1.04 : 1,
        child: SizedBox(
          width: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  iconAsset,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
