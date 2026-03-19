import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/feed/presentation/models/feed_models.dart';

class FeedReminderCard extends StatelessWidget {
  const FeedReminderCard({super.key, required this.item, required this.onTap});

  final FeedReminderItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final _ReminderPalette palette = _paletteFor(item.tone);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppTheme.normalDuration,
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: palette.backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: palette.borderColor),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.asset(item.iconAsset, fit: BoxFit.contain),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.title,
                      style: TextStyle(
                        color: palette.titleColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: TextStyle(
                        color: palette.contentColor,
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              item.timeAgo,
              style: TextStyle(
                color: palette.timeColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ReminderPalette _paletteFor(FeedReminderTone tone) {
    switch (tone) {
      case FeedReminderTone.spotlight:
        return const _ReminderPalette(
          backgroundColor: AppTheme.accentColor,
          borderColor: Colors.transparent,
          titleColor: AppTheme.backgroundColor,
          contentColor: AppTheme.backgroundColor,
          timeColor: Color(0xB248416B),
        );
      case FeedReminderTone.warning:
        return const _ReminderPalette(
          backgroundColor: Color(0x336F4065),
          borderColor: Color(0x26F7C8BF),
          titleColor: Color(0xFFF7C8BF),
          contentColor: Color(0xFFD9D4E8),
          timeColor: Color(0x99D9D4E8),
        );
      case FeedReminderTone.info:
        return const _ReminderPalette(
          backgroundColor: Color(0x295F7AA7),
          borderColor: Color(0x2EBDDBF7),
          titleColor: Color(0xFF9EC5F0),
          contentColor: Color(0xFFDDE7F4),
          timeColor: Color(0x99DDE7F4),
        );
      case FeedReminderTone.neutral:
        return const _ReminderPalette(
          backgroundColor: Color(0x1EF7E0B6),
          borderColor: Color(0x30EDC28D),
          titleColor: AppTheme.accentColor,
          contentColor: Color(0xFFE6E2F0),
          timeColor: Color(0x99E6E2F0),
        );
    }
  }
}

class FeedPromoCard extends StatelessWidget {
  const FeedPromoCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFF0C78E), Color(0xFFDBA965)],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              right: -8,
              top: -10,
              child: Opacity(
                opacity: 0.22,
                child: SvgPicture.asset(
                  AppAssets.feedReminderPromo,
                  width: 98,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 44),
                const Text(
                  '今日推荐',
                  style: TextStyle(
                    color: AppTheme.backgroundColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '探索周边美食动态',
                  style: TextStyle(
                    color: AppTheme.backgroundColor.withValues(alpha: 0.76),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 22),
                const Row(
                  children: <Widget>[
                    _PromoTag(label: '人气'),
                    SizedBox(width: 8),
                    _PromoTag(label: '限时'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoTag extends StatelessWidget {
  const _PromoTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.accentColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ReminderPalette {
  const _ReminderPalette({
    required this.backgroundColor,
    required this.borderColor,
    required this.titleColor,
    required this.contentColor,
    required this.timeColor,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color titleColor;
  final Color contentColor;
  final Color timeColor;
}
