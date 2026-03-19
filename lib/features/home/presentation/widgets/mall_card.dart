import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/core/theme/app_theme.dart';

class MallCardData {
  const MallCardData({
    required this.name,
    required this.imageAsset,
    required this.distance,
    required this.tag,
    required this.tagIconAsset,
    required this.tagColor,
    required this.primaryShop,
    required this.primaryWait,
    required this.secondaryShop,
    required this.secondaryWait,
    this.favorite = false,
  });

  final String name;
  final String imageAsset;
  final String distance;
  final String tag;
  final String tagIconAsset;
  final Color tagColor;
  final String primaryShop;
  final String primaryWait;
  final String secondaryShop;
  final String secondaryWait;
  final bool favorite;
}

class MallCard extends StatelessWidget {
  const MallCard({super.key, required this.data, this.onTap});

  final MallCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    data.imageAsset,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 64,
                      height: 64,
                      color: Colors.white.withValues(alpha: 0.2),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppTheme.backgroundColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SizedBox(
                            width: 10.5,
                            height: 10.5,
                            child: SvgPicture.asset(
                              AppAssets.homeLocation,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            data.distance,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: data.tagColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 10.5,
                              height: 10.5,
                              child: SvgPicture.asset(
                                data.tagIconAsset,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              data.tag,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                  height: 18.35,
                  child: SvgPicture.asset(
                    data.favorite
                        ? AppAssets.homeHeartActive
                        : AppAssets.homeHeart,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _ShopRow(name: data.primaryShop, wait: data.primaryWait),
                  Divider(color: Colors.black.withValues(alpha: 0.08)),
                  _ShopRow(name: data.secondaryShop, wait: data.secondaryWait),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopRow extends StatelessWidget {
  const _ShopRow({required this.name, required this.wait});

  final String name;
  final String wait;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
          ),
        ),
        Text(
          wait,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.backgroundColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
