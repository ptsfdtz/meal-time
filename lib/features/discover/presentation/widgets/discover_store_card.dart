import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/core/theme/app_theme.dart';

class DiscoverStoreCardData {
  const DiscoverStoreCardData({
    required this.imageAsset,
    required this.title,
    required this.cuisine,
    required this.distanceKm,
    required this.estimatedWaitMinutes,
    required this.distance,
    required this.waiting,
    required this.tag,
    required this.tagBackground,
    required this.tagTextColor,
    required this.waitDotColor,
    required this.rating,
    required this.price,
  });

  final String imageAsset;
  final String title;
  final String cuisine;
  final double distanceKm;
  final int estimatedWaitMinutes;
  final String distance;
  final String waiting;
  final String tag;
  final Color tagBackground;
  final Color tagTextColor;
  final Color waitDotColor;
  final String rating;
  final String price;
}

class DiscoverStoreCard extends StatelessWidget {
  const DiscoverStoreCard({super.key, required this.data, this.onTap});

  final DiscoverStoreCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      data.imageAsset,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 96,
                        height: 96,
                        color: Colors.white.withValues(alpha: 0.25),
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                data.title,
                                style: const TextStyle(
                                  color: AppTheme.backgroundColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _IconButtonAsset(asset: AppAssets.discoverFavorite),
                            const SizedBox(width: 8),
                            _IconButtonAsset(asset: AppAssets.discoverShare),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.distance,
                          style: TextStyle(
                            color: AppTheme.backgroundColor.withValues(
                              alpha: 0.9,
                            ),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: data.waitDotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              data.waiting,
                              style: const TextStyle(
                                color: AppTheme.backgroundColor,
                                fontSize: 14,
                                height: 1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: data.tagBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(
                            data.tag,
                            style: TextStyle(
                              color: data.tagTextColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.backgroundColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 11.67,
                    height: 11.08,
                    child: SvgPicture.asset(
                      AppAssets.discoverStar,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    data.rating,
                    style: const TextStyle(
                      color: AppTheme.backgroundColor,
                      fontSize: 14,
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    data.price,
                    style: const TextStyle(
                      color: AppTheme.backgroundColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: const Text(
                      '预约',
                      style: TextStyle(
                        color: AppTheme.accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButtonAsset extends StatelessWidget {
  const _IconButtonAsset({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.67,
      height: 16.67,
      child: SvgPicture.asset(asset, fit: BoxFit.contain),
    );
  }
}
