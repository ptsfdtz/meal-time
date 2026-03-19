import 'package:flutter/material.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/auth/presentation/widgets/entrance_section.dart';
import 'package:mealtime/features/discover/presentation/widgets/discover_store_card.dart';

class DiscoverStoreDetailPage extends StatefulWidget {
  const DiscoverStoreDetailPage({super.key, required this.store});

  final DiscoverStoreCardData store;

  @override
  State<DiscoverStoreDetailPage> createState() =>
      _DiscoverStoreDetailPageState();
}

class _DiscoverStoreDetailPageState extends State<DiscoverStoreDetailPage> {
  bool _showHeader = false;
  bool _showContent = false;
  bool _showAction = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(
      const Duration(milliseconds: 40),
      () => _setIfMounted(() => _showHeader = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 180),
      () => _setIfMounted(() => _showContent = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 300),
      () => _setIfMounted(() => _showAction = true),
    );
  }

  void _setIfMounted(VoidCallback callback) {
    if (!mounted) {
      return;
    }
    setState(callback);
  }

  @override
  Widget build(BuildContext context) {
    final DiscoverStoreCardData store = widget.store;
    final String title = store.title.split(' · ').first;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EntranceSection(
                  visible: _showHeader,
                  child: _StoreHeader(
                    title: title,
                    subtitle: store.title.split(' · ').last,
                    imageAsset: store.imageAsset,
                    onBack: () => Navigator.of(context).pop(),
                  ),
                ),
                EntranceSection(
                  visible: _showContent,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _MetaTag(text: store.cuisine),
                            _MetaTag(text: '评分 ${store.rating}'),
                            _MetaTag(text: store.price),
                            _MetaTag(
                              text:
                                  '等待 ${store.waiting.replaceFirst('预计等待: ', '')}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '店铺信息',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _InfoRow(
                                label: '位置',
                                value: store.title.split(' · ').last,
                              ),
                              _InfoRow(label: '距离', value: store.distance),
                              _InfoRow(
                                label: '排队',
                                value: store.waiting.replaceFirst('预计等待: ', ''),
                              ),
                              _InfoRow(label: '推荐理由', value: store.tag),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Text(
                            '根据你当前筛选偏好，系统推荐这家店。当前人流与出餐节奏较稳定，适合现在出发。',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.78),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: EntranceSection(
              visible: _showAction,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('已为你打开预约入口')));
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.backgroundColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  '立即预约',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  const _StoreHeader({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final String imageAsset;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imageAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Container(color: const Color(0xFF1E293B)),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x22000000), Color(0xCC0B1220)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _RoundIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: onBack,
                      ),
                      const Spacer(),
                      const _RoundIconButton(icon: Icons.share_outlined),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.82),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.88),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
