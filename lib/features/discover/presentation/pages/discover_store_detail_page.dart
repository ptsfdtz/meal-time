import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/assets/app_assets.dart';
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
  bool _showHero = false;
  bool _showTrend = false;
  bool _showDecision = false;
  double _waitTolerance = 25;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(
      const Duration(milliseconds: 40),
      () => _setIfMounted(() => _showHero = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 150),
      () => _setIfMounted(() => _showTrend = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 280),
      () => _setIfMounted(() => _showDecision = true),
    );
  }

  void _setIfMounted(VoidCallback callback) {
    if (!mounted) {
      return;
    }
    setState(callback);
  }

  String get _storeName => widget.store.title.split(' · ').first;

  String get _locationText {
    final String area = widget.store.title.split(' · ').last;
    final String distance = widget.store.distance
        .replaceAll('·', '')
        .replaceAll('步行约', '')
        .trim();
    return '$area · $distance';
  }

  String get _headerTitle {
    if (widget.store.cuisine == '咖啡' || widget.store.cuisine == '茶饮') {
      return '精品咖啡馆';
    }
    return '热门餐厅';
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;
    final double topHeaderHeight = topInset + 64;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, topHeaderHeight + 12, 0, 28),
            child: Column(
              children: [
                EntranceSection(
                  visible: _showHero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _StoreHero(
                      storeName: _storeName,
                      locationText: _locationText,
                      imageAsset: widget.store.imageAsset,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                EntranceSection(
                  visible: _showTrend,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _TrendCard(),
                  ),
                ),
                const SizedBox(height: 16),
                EntranceSection(
                  visible: _showTrend,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _WaitConfidenceRow(),
                  ),
                ),
                const SizedBox(height: 24),
                EntranceSection(
                  visible: _showDecision,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _DecisionToolsCard(
                      waitTolerance: _waitTolerance,
                      onChanged: (double value) {
                        setState(() {
                          _waitTolerance = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          _TopHeader(
            topInset: topInset,
            title: _headerTitle,
            onBack: () => Navigator.of(context).pop(),
            onShare: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('分享功能开发中')));
            },
          ),
        ],
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({
    required this.topInset,
    required this.title,
    required this.onBack,
    required this.onShare,
  });

  final double topInset;
  final String title;
  final VoidCallback onBack;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: topInset + 64,
          color: const Color(0xE648416B),
          padding: EdgeInsets.fromLTRB(16, topInset + 8, 16, 16),
          child: Row(
            children: [
              _HeaderIconButton(asset: AppAssets.detailBack, onTap: onBack),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ),
              _HeaderIconButton(asset: AppAssets.detailShare, onTap: onShare),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.asset, this.onTap});

  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SizedBox(
          width: 16,
          height: 16,
          child: SvgPicture.asset(
            asset,
            fit: BoxFit.contain,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class _StoreHero extends StatelessWidget {
  const _StoreHero({
    required this.storeName,
    required this.locationText,
    required this.imageAsset,
  });

  final String storeName;
  final String locationText;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.accentColor, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 15,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Image.asset(AppAssets.detailHeroBg, fit: BoxFit.cover),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  height: 0.95,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  SizedBox(
                    width: 8,
                    height: 10,
                    child: SvgPicture.asset(AppAssets.detailLocation),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      locationText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0x3322C55E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '营业中',
                  style: TextStyle(
                    color: Color(0xFF4ADE80),
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '实时人流量趋势',
                    style: TextStyle(color: Color(0x99FFFFFF), fontSize: 12),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '适中状态',
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    '较昨日',
                    style: TextStyle(color: Color(0x99FFFFFF), fontSize: 12),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '+5.2%',
                    style: TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 0.95,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const _TrendBars(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AxisLabel(text: '10:30'),
              _AxisLabel(text: '13:00 (高峰)'),
              _AxisLabel(text: '16:30'),
              _AxisLabel(text: '21:00 (高峰)'),
              _AxisLabel(text: '22:00'),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: Color(0xFF9EC5F0), text: '空闲'),
              SizedBox(width: 16),
              _LegendDot(color: Color(0xFFEDC28D), text: '适中'),
              SizedBox(width: 16),
              _LegendDot(color: Color(0xFFF1AA9E), text: '拥挤'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendBars extends StatelessWidget {
  const _TrendBars();

  @override
  Widget build(BuildContext context) {
    const List<_BarData> bars = <_BarData>[
      _BarData(height: 48, color: Color(0xFF9EC5F0)),
      _BarData(height: 64, color: Color(0xFF9EC5F0)),
      _BarData(height: 80, color: Color(0xFFEDC28D)),
      _BarData(height: 96, color: Color(0xFFF1AA9E)),
      _BarData(height: 56, color: Color(0xFF9EC5F0)),
      _BarData(height: 40, color: Color(0xFF9EC5F0)),
      _BarData(height: 58, color: Color(0xFFEDC28D)),
      _BarData(height: 80, color: Color(0xFFEDC28D)),
      _BarData(height: 96, color: Color(0xFFF1AA9E)),
      _BarData(height: 112, color: Color(0xFFF1AA9E), current: true),
      _BarData(height: 80, color: Color(0x4D9EC5F0), predict: true),
    ];

    return SizedBox(
      height: 128,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars.map((_BarData bar) => _BarWidget(data: bar)).toList(),
      ),
    );
  }
}

class _BarData {
  const _BarData({
    required this.height,
    required this.color,
    this.current = false,
    this.predict = false,
  });

  final double height;
  final Color color;
  final bool current;
  final bool predict;
}

class _BarWidget extends StatelessWidget {
  const _BarWidget({required this.data});

  final _BarData data;

  @override
  Widget build(BuildContext context) {
    final Widget bar = data.predict
        ? Container(
            width: 24,
            height: data.height,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
              border: Border.all(color: const Color(0x6648416B), width: 2),
            ),
          )
        : data.current
        ? Container(
            width: 24,
            height: data.height,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0.2),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: data.height,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1AA9E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                ),
              ),
            ),
          )
        : Container(
            width: 24,
            height: data.height,
            decoration: BoxDecoration(
              color: data.color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
            ),
          );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (data.current || data.predict)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: SizedBox(
              width: 20,
              height: 9,
              child: SvgPicture.asset(
                data.current
                    ? AppAssets.detailChartCurrent
                    : AppAssets.detailChartPredict,
              ),
            ),
          ),
        bar,
      ],
    );
  }
}

class _AxisLabel extends StatelessWidget {
  const _AxisLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0x66FFFFFF),
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _WaitConfidenceRow extends StatelessWidget {
  const _WaitConfidenceRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: Row(
        children: const [
          Expanded(child: _WaitCard()),
          SizedBox(width: 16),
          Expanded(child: _ConfidenceCard()),
        ],
      ),
    );
  }
}

class _WaitCard extends StatelessWidget {
  const _WaitCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Column(
        children: [
          const Text(
            '预计等待',
            style: TextStyle(color: AppTheme.accentColor, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0x3348416B),
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9EC5F0),
                      Color(0xFFEDC28D),
                      Color(0xFFF1AA9E),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: AppTheme.accentColor),
              children: [
                TextSpan(
                  text: '15',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    height: 0.95,
                  ),
                ),
                TextSpan(text: ' 分钟', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfidenceCard extends StatelessWidget {
  const _ConfidenceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Column(
        children: [
          const Text(
            '置信度 85%',
            style: TextStyle(color: Color(0xB348416B), fontSize: 12),
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0x3348416B),
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.85,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(999),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '高可靠性',
            style: TextStyle(color: Color(0x8048416B), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _DecisionToolsCard extends StatelessWidget {
  const _DecisionToolsCard({
    required this.waitTolerance,
    required this.onChanged,
  });

  final double waitTolerance;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 10.5,
                height: 10.5,
                child: SvgPicture.asset(AppAssets.detailDecisionIcon),
              ),
              const SizedBox(width: 8),
              const Text(
                '决策助手',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  height: 0.95,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
              children: [
                const TextSpan(text: '我愿意等：'),
                TextSpan(
                  text: '${waitTolerance.round()}分钟',
                  style: const TextStyle(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: AppTheme.accentColor,
              inactiveTrackColor: const Color(0xFF334155),
              thumbColor: AppTheme.accentColor,
            ),
            child: Slider(
              value: waitTolerance,
              min: 5,
              max: 60,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '5 min',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 0.95,
                ),
              ),
              Text(
                '60+ min',
                style: TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 0.95,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '如果不想等待，为您推荐 Plan B：',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          const _PlanBCard(
            imageAsset: AppAssets.detailPlanBManner,
            title: 'Manner Coffee',
            subtitle: '步行 3min · 无需排队',
          ),
          const SizedBox(height: 12),
          const _PlanBCard(
            imageAsset: AppAssets.detailPlanBSeesaw,
            title: 'Seesaw Coffee',
            subtitle: '步行 5min · 等待 < 5min',
          ),
        ],
      ),
    );
  }
}

class _PlanBCard extends StatelessWidget {
  const _PlanBCard({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  final String imageAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageAsset,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Image.asset(
                  AppAssets.detailHeroBg,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5.55,
              height: 9,
              child: SvgPicture.asset(AppAssets.detailChevronRight),
            ),
          ],
        ),
      ),
    );
  }
}
