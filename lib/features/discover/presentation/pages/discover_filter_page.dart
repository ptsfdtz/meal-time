import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/discover/presentation/models/discover_filter_state.dart';
import 'package:mealtime/features/discover/presentation/widgets/discover_store_card.dart';

class DiscoverFilterPage extends StatefulWidget {
  const DiscoverFilterPage({
    super.key,
    required this.initialFilter,
    required this.sourceCards,
  });

  final DiscoverFilterState initialFilter;
  final List<DiscoverStoreCardData> sourceCards;

  @override
  State<DiscoverFilterPage> createState() => _DiscoverFilterPageState();
}

class _DiscoverFilterPageState extends State<DiscoverFilterPage> {
  static const List<String> _cuisineOptions = <String>[
    '火锅',
    '日料',
    '川菜',
    '粤菜',
    '西餐',
    '简餐',
    '咖啡',
    '茶饮',
    '烧烤',
    '东南亚菜',
  ];
  static const List<double?> _distanceOptions = <double?>[0.5, 1, 3, 5, null];

  late DiscoverFilterState _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialFilter;
  }

  int get _resultCount => widget.sourceCards
      .where((DiscoverStoreCardData d) => _draft.matches(d))
      .length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWaitSection(),
                    const SizedBox(height: 32),
                    _buildCuisineSection(),
                    const SizedBox(height: 32),
                    _buildDistanceSection(),
                    const SizedBox(height: 25),
                    _buildMoreConditions(),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
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
                  child: SvgPicture.asset(AppAssets.discoverBack),
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              '筛选条件',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            right: 16,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _draft = DiscoverFilterState.initial;
                });
              },
              child: Text(
                '重置',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '我愿意等多久',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '系统将推荐等待时间≤此值的餐厅',
                      style: TextStyle(color: Color(0x80FFFFFF), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                _draft.maxWaitMinutes >= 60
                    ? '60+分钟'
                    : '${_draft.maxWaitMinutes}分钟',
                style: const TextStyle(
                  color: AppTheme.accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: AppTheme.accentColor,
              inactiveTrackColor: const Color(0xFF9EC5F0),
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: _draft.maxWaitMinutes.toDouble(),
              min: 0,
              max: 60,
              divisions: 12,
              onChanged: (double value) {
                setState(() {
                  _draft = _draft.copyWith(maxWaitMinutes: value.round());
                });
              },
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ScaleLabel('0'),
              _ScaleLabel('15'),
              _ScaleLabel('30'),
              _ScaleLabel('45'),
              _ScaleLabel('60+'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCuisineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '想吃点什么',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _cuisineOptions.map((String option) {
            final bool selected = _draft.cuisine == option;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _draft = _draft.copyWith(
                    cuisine: selected ? null : option,
                    clearCuisine: selected,
                  );
                });
              },
              child: Container(
                constraints: const BoxConstraints(minWidth: 80),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.accentColor
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? AppTheme.backgroundColor
                        : Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDistanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '距离多远',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _distanceOptions.map((double? km) {
            final bool selected = _draft.maxDistanceKm == km;
            final String label = _distanceLabel(km);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _draft = _draft.copyWith(
                    maxDistanceKm: km,
                    clearDistance: km == null,
                  );
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 21,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppTheme.accentColor
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? AppTheme.backgroundColor
                        : Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMoreConditions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              '更多条件',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          SizedBox(
            width: 12,
            height: 7.4,
            child: SvgPicture.asset(AppAssets.discoverFilter),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 32),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Column(
        children: [
          Text(
            '找到 $_resultCount 家餐厅',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(_draft),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('查看结果', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  String _distanceLabel(double? km) {
    if (km == null) {
      return '不限';
    }
    if (km == 0.5) {
      return '500m';
    }
    if (km == 1) {
      return '1km';
    }
    if (km == 3) {
      return '3km';
    }
    if (km == 5) {
      return '5km';
    }
    return '${km.toStringAsFixed(1)}km';
  }
}

class _ScaleLabel extends StatelessWidget {
  const _ScaleLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Color(0x66FFFFFF), fontSize: 12),
    );
  }
}
