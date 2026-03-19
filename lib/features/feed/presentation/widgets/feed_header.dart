import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/features/feed/presentation/models/feed_models.dart';
import 'package:mealtime/features/feed/presentation/widgets/feed_tab_switcher.dart';

class FeedHeader extends StatelessWidget {
  const FeedHeader({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
    required this.onSearchTap,
    required this.onSettingsTap,
  });

  final FeedTab activeTab;
  final ValueChanged<FeedTab> onTabChanged;
  final VoidCallback onSearchTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Transform.translate(
            offset: const Offset(0, -2),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 72,
                  height: 26,
                  child: SvgPicture.asset(
                    AppAssets.feedLogo,
                    fit: BoxFit.contain,
                  ),
                ),
                const Spacer(),
                _HeaderActionButton(
                  asset: AppAssets.feedHeaderSearch,
                  onTap: onSearchTap,
                ),
                const SizedBox(width: 14),
                _HeaderActionButton(
                  asset: AppAssets.feedHeaderSettings,
                  onTap: onSettingsTap,
                ),
              ],
            ),
          ),
          const SizedBox(height: 0),
          Transform.translate(
            offset: const Offset(0, -12),
            child: FeedTabSwitcher(
              activeTab: activeTab,
              onChanged: onTabChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 24,
        height: 24,
        child: SvgPicture.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}
