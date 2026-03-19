import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/auth/presentation/widgets/entrance_section.dart';
import 'package:mealtime/features/discover/presentation/models/discover_filter_state.dart';
import 'package:mealtime/features/discover/presentation/pages/discover_filter_page.dart';
import 'package:mealtime/features/discover/presentation/widgets/discover_store_card.dart';
import 'package:mealtime/features/home/presentation/widgets/floating_bottom_nav.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key, required this.config});

  final DiscoverPageConfig config;

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  bool _showHeader = false;
  bool _showBody = false;
  bool _showBottomNav = false;
  bool _isMapView = false;
  int _selectedIndex = 0;
  int _sortIndex = 0;
  late DiscoverFilterState _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.config.initialFilter;
    _startEntranceAnimation();
  }

  void _startEntranceAnimation() {
    Future<void>.delayed(
      const Duration(milliseconds: 50),
      () => _setIfMounted(() => _showHeader = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 180),
      () => _setIfMounted(() => _showBody = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 320),
      () => _setIfMounted(() => _showBottomNav = true),
    );
  }

  void _setIfMounted(VoidCallback callback) {
    if (!mounted) {
      return;
    }
    setState(callback);
  }

  List<DiscoverStoreCardData> get _visibleCards {
    final List<DiscoverStoreCardData> cards = widget.config.cards
        .where((DiscoverStoreCardData card) => _filter.matches(card))
        .toList();
    switch (_sortIndex) {
      case 1:
        cards.sort((DiscoverStoreCardData a, DiscoverStoreCardData b) {
          return a.distanceKm.compareTo(b.distanceKm);
        });
      case 2:
        cards.sort((DiscoverStoreCardData a, DiscoverStoreCardData b) {
          return a.estimatedWaitMinutes.compareTo(b.estimatedWaitMinutes);
        });
      case 3:
        cards.sort((DiscoverStoreCardData a, DiscoverStoreCardData b) {
          final double aRating = double.tryParse(a.rating) ?? 0;
          final double bRating = double.tryParse(b.rating) ?? 0;
          return bRating.compareTo(aRating);
        });
      default:
        break;
    }
    return cards;
  }

  int _safeIndex(int count, int index) {
    if (count <= 0) {
      return 0;
    }
    if (index < 0) {
      return 0;
    }
    if (index >= count) {
      return count - 1;
    }
    return index;
  }

  Future<void> _openFilterPage() async {
    final DiscoverFilterState? next = await Navigator.of(context).push(
      PageRouteBuilder<DiscoverFilterState>(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) => DiscoverFilterPage(
              initialFilter: _filter,
              sourceCards: widget.config.cards,
            ),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              final Animation<Offset> slide =
                  Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  );
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slide, child: child),
              );
            },
      ),
    );
    if (next == null) {
      return;
    }
    setState(() {
      _filter = next;
      _selectedIndex = _safeIndex(_visibleCards.length, _selectedIndex);
    });
  }

  void _openMap({int? selectedIndex}) {
    final int nextIndex = selectedIndex ?? _selectedIndex;
    setState(() {
      _isMapView = true;
      _selectedIndex = _safeIndex(_visibleCards.length, nextIndex);
    });
  }

  void _openList() {
    setState(() {
      _isMapView = false;
    });
  }

  List<String> get _chips => <String>[
    _filter.waitChipLabel,
    _filter.cuisineChipLabel,
    _filter.distanceChipLabel,
  ];

  @override
  Widget build(BuildContext context) {
    final List<DiscoverStoreCardData> cards = _visibleCards;
    final int selectedIndex = _safeIndex(cards.length, _selectedIndex);
    final String refreshKey = [
      _filter.maxWaitMinutes.toString(),
      _filter.cuisine ?? 'all',
      _filter.maxDistanceKm?.toString() ?? 'any',
      _sortIndex.toString(),
      cards.length.toString(),
    ].join('-');

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                EntranceSection(
                  visible: _showHeader,
                  child: _DiscoverHeader(
                    mapMode: _isMapView,
                    chips: _chips,
                    sortIndex: _sortIndex,
                    onOpenFilter: _openFilterPage,
                    onChipTap: (_) => _openFilterPage(),
                    onSortTap: (int index) {
                      if (_sortIndex == index) {
                        return;
                      }
                      setState(() {
                        _sortIndex = index;
                        _selectedIndex = _safeIndex(
                          cards.length,
                          _selectedIndex,
                        );
                      });
                    },
                  ),
                ),
                Expanded(
                  child: EntranceSection(
                    visible: _showBody,
                    child: AnimatedSwitcher(
                      duration: AppTheme.slowDuration,
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeOutCubic,
                      child: _isMapView
                          ? _DiscoverMapView(
                              key: ValueKey<String>('map-$refreshKey'),
                              cards: cards,
                              selectedIndex: selectedIndex,
                              onSelect: (int index) {
                                setState(() {
                                  _selectedIndex = _safeIndex(
                                    cards.length,
                                    index,
                                  );
                                });
                              },
                              onOpenFilter: _openFilterPage,
                            )
                          : _DiscoverListView(
                              key: ValueKey<String>('list-$refreshKey'),
                              cards: cards,
                              onCardTap: (int index) =>
                                  _openMap(selectedIndex: index),
                              onOpenFilter: _openFilterPage,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!_isMapView && cards.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 96,
              child: Center(
                child: _ModeToggleButton(
                  iconAsset: AppAssets.discoverMapButton,
                  text: '地图视图',
                  onTap: _openMap,
                ),
              ),
            ),
          if (_isMapView && cards.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 144,
              child: Center(
                child: _ModeToggleButton(
                  iconAsset: AppAssets.discoverMapListView,
                  text: '列表视图',
                  onTap: _openList,
                ),
              ),
            ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: EntranceSection(
              visible: _showBottomNav,
              child: FloatingBottomNav(
                items: const <BottomNavItemData>[
                  BottomNavItemData(
                    iconAsset: AppAssets.discoverNavHome,
                    label: '首页',
                  ),
                  BottomNavItemData(
                    iconAsset: AppAssets.discoverNavStore,
                    label: '寻店',
                  ),
                  BottomNavItemData(
                    iconAsset: AppAssets.discoverNavFeed,
                    label: '动态',
                  ),
                  BottomNavItemData(
                    iconAsset: AppAssets.discoverNavProfile,
                    label: '我的',
                  ),
                ],
                selectedIndex: 1,
                onTap: (int index) {
                  if (index == 0) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverPageConfig {
  const DiscoverPageConfig({
    required this.cards,
    this.initialFilter = DiscoverFilterState.initial,
  });

  final List<DiscoverStoreCardData> cards;
  final DiscoverFilterState initialFilter;

  static const DiscoverPageConfig all = DiscoverPageConfig(
    initialFilter: DiscoverFilterState(
      maxWaitMinutes: 20,
      cuisine: '日料',
      maxDistanceKm: 1,
    ),
    cards: <DiscoverStoreCardData>[
      DiscoverStoreCardData(
        imageAsset: AppAssets.discoverShopAkita,
        title: '秋田丼屋 · B座3F',
        cuisine: '日料',
        distanceKm: 0.85,
        estimatedWaitMinutes: 20,
        distance: '850m · 步行约12分钟',
        waiting: '预计等待: 15-25min',
        tag: '符合你的口味偏好',
        tagBackground: Color(0x80E2E8F0),
        tagTextColor: AppTheme.backgroundColor,
        waitDotColor: Color(0xFF9EC5F0),
        rating: '4.5',
        price: '¥120 / 人',
      ),
      DiscoverStoreCardData(
        imageAsset: AppAssets.discoverShopMota,
        title: '摩打食堂 · A座1F',
        cuisine: '川菜',
        distanceKm: 1.2,
        estimatedWaitMinutes: 38,
        distance: '1.2km · 步行约18分钟',
        waiting: '预计等待: 30-45min',
        tag: '比同类店快20分钟',
        tagBackground: Color(0x66F1AA9E),
        tagTextColor: AppTheme.backgroundColor,
        waitDotColor: Color(0xFFF1AA9E),
        rating: '4.8',
        price: '¥158 / 人',
      ),
      DiscoverStoreCardData(
        imageAsset: AppAssets.discoverShopHakata,
        title: '博多一幸舍 · C座4F',
        cuisine: '日料',
        distanceKm: 1.5,
        estimatedWaitMinutes: 8,
        distance: '1.5km · 步行约22分钟',
        waiting: '预计等待: 5-10min',
        tag: '老字号推荐 · 建议即刻前往',
        tagBackground: Color(0xFFDCFCE7),
        tagTextColor: Color(0xFF166534),
        waitDotColor: Color(0xFF9EC5F0),
        rating: '4.3',
        price: '¥85 / 人',
      ),
    ],
  );

  static const DiscoverPageConfig globalHarbor = all;

  static const DiscoverPageConfig wanda = DiscoverPageConfig(
    initialFilter: DiscoverFilterState(
      maxWaitMinutes: 30,
      cuisine: null,
      maxDistanceKm: 3,
    ),
    cards: <DiscoverStoreCardData>[
      DiscoverStoreCardData(
        imageAsset: AppAssets.discoverShopMota,
        title: '新元素 Element Fresh · 万达1F',
        cuisine: '简餐',
        distanceKm: 2.5,
        estimatedWaitMinutes: 5,
        distance: '2.5km · 骑行约10分钟',
        waiting: '预计等待: 无需等待',
        tag: '环境清静 · 适合聊天',
        tagBackground: Color(0x809EC5F0),
        tagTextColor: AppTheme.backgroundColor,
        waitDotColor: Color(0xFF9EC5F0),
        rating: '4.7',
        price: '¥98 / 人',
      ),
      DiscoverStoreCardData(
        imageAsset: AppAssets.discoverShopAkita,
        title: '喜茶 HEYTEA · 万达2F',
        cuisine: '茶饮',
        distanceKm: 2.5,
        estimatedWaitMinutes: 18,
        distance: '2.5km · 骑行约10分钟',
        waiting: '预计等待: 15-20min',
        tag: '当前人流平稳',
        tagBackground: Color(0x80E2E8F0),
        tagTextColor: AppTheme.backgroundColor,
        waitDotColor: Color(0xFFF1AA9E),
        rating: '4.6',
        price: '¥32 / 人',
      ),
      DiscoverStoreCardData(
        imageAsset: AppAssets.discoverShopHakata,
        title: 'Manner Coffee · 万达B1',
        cuisine: '咖啡',
        distanceKm: 2.6,
        estimatedWaitMinutes: 8,
        distance: '2.6km · 骑行约11分钟',
        waiting: '预计等待: 5-10min',
        tag: '出杯快 · 适合赶时间',
        tagBackground: Color(0xFFDCFCE7),
        tagTextColor: Color(0xFF166534),
        waitDotColor: Color(0xFF9EC5F0),
        rating: '4.5',
        price: '¥26 / 人',
      ),
    ],
  );
}

class _DiscoverHeader extends StatelessWidget {
  const _DiscoverHeader({
    required this.mapMode,
    required this.chips,
    required this.sortIndex,
    required this.onOpenFilter,
    required this.onChipTap,
    required this.onSortTap,
  });

  final bool mapMode;
  final List<String> chips;
  final int sortIndex;
  final VoidCallback onOpenFilter;
  final ValueChanged<int> onChipTap;
  final ValueChanged<int> onSortTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _CircleButton(
                    asset: mapMode
                        ? AppAssets.discoverMapBack
                        : AppAssets.discoverBack,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const Center(
                  child: Text(
                    '寻店结果',
                    style: TextStyle(
                      color: Color(0xFFF1F5F9),
                      fontSize: 20,
                      height: 1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: _CircleButton(
                    asset: mapMode
                        ? AppAssets.discoverMapFilter
                        : AppAssets.discoverFilter,
                    onTap: onOpenFilter,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List<Widget>.generate(chips.length, (int index) {
                return Padding(
                  padding: EdgeInsets.only(
                    right: index == chips.length - 1 ? 0 : 8,
                  ),
                  child: _FilterChip(
                    text: chips[index],
                    chevronAsset: mapMode
                        ? AppAssets.discoverMapChipChevron
                        : AppAssets.discoverChipChevron,
                    rounded: mapMode ? 12 : 999,
                    backgroundAlpha: mapMode ? 0.2 : 0.1,
                    onTap: () => onChipTap(index),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (!mapMode) _SortTabs(activeIndex: sortIndex, onTap: onSortTap),
      ],
    );
  }
}

class _DiscoverListView extends StatelessWidget {
  const _DiscoverListView({
    super.key,
    required this.cards,
    required this.onCardTap,
    required this.onOpenFilter,
  });

  final List<DiscoverStoreCardData> cards;
  final ValueChanged<int> onCardTap;
  final VoidCallback onOpenFilter;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return _DiscoverEmptyState(onOpenFilter: onOpenFilter, mapMode: false);
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 116),
      itemBuilder: (_, int index) {
        return DiscoverStoreCard(
          data: cards[index],
          onTap: () => onCardTap(index),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemCount: cards.length,
    );
  }
}

class _DiscoverMapView extends StatelessWidget {
  const _DiscoverMapView({
    super.key,
    required this.cards,
    required this.selectedIndex,
    required this.onSelect,
    required this.onOpenFilter,
  });

  final List<DiscoverStoreCardData> cards;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onOpenFilter;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              AppAssets.discoverMapBackground,
              fit: BoxFit.cover,
            ),
          ),
          _DiscoverEmptyState(onOpenFilter: onOpenFilter, mapMode: true),
        ],
      );
    }

    final DiscoverStoreCardData selected = cards[selectedIndex];
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            AppAssets.discoverMapBackground,
            fit: BoxFit.cover,
          ),
        ),
        ..._buildMarkers(),
        Positioned(right: 16, top: 290, child: _MapControls()),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: _MapPreviewCard(data: selected),
        ),
      ],
    );
  }

  List<Widget> _buildMarkers() {
    const List<Alignment> positions = <Alignment>[
      Alignment(-0.45, -0.18),
      Alignment(0.42, 0.18),
      Alignment(0.0, 0.56),
      Alignment(-0.20, 0.16),
      Alignment(0.15, -0.10),
      Alignment(0.35, -0.30),
    ];

    return List<Widget>.generate(cards.length, (int index) {
      final DiscoverStoreCardData card = cards[index];
      final bool selected = index == selectedIndex;
      final _MarkerStyle style = _markerStyle(card, selected);
      return Positioned.fill(
        child: Align(
          alignment: positions[index % positions.length],
          child: GestureDetector(
            onTap: () => onSelect(index),
            child: _MapMarker(
              waitLabel: '${card.estimatedWaitMinutes}min',
              iconAsset: style.iconAsset,
              color: style.color,
              selected: selected,
              label: selected ? card.title.split(' · ').first : null,
            ),
          ),
        ),
      );
    });
  }

  _MarkerStyle _markerStyle(DiscoverStoreCardData card, bool selected) {
    if (selected) {
      return const _MarkerStyle(
        AppAssets.discoverMapSelected,
        AppTheme.accentColor,
      );
    }
    if (card.estimatedWaitMinutes <= 10) {
      return const _MarkerStyle(
        AppAssets.discoverMapMarkerEmpty,
        Color(0xFF9EC5F0),
      );
    }
    if (card.estimatedWaitMinutes <= 25) {
      return const _MarkerStyle(
        AppAssets.discoverMapMarkerCrowded2,
        Color(0xFFBFD7F3),
      );
    }
    return const _MarkerStyle(
      AppAssets.discoverMapMarkerCrowded,
      Color(0xFFF1AA9E),
    );
  }
}

class _MarkerStyle {
  const _MarkerStyle(this.iconAsset, this.color);

  final String iconAsset;
  final Color color;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.waitLabel,
    required this.iconAsset,
    required this.color,
    required this.selected,
    this.label,
  });

  final String waitLabel;
  final String iconAsset;
  final Color color;
  final bool selected;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            waitLabel,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedContainer(
          duration: AppTheme.normalDuration,
          curve: Curves.easeOutCubic,
          width: selected ? 48 : 32,
          height: selected ? 48 : 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: selected ? 1 : 0.5),
              width: selected ? 4 : 2,
            ),
          ),
          alignment: Alignment.center,
          child: SizedBox(
            width: selected ? 15 : 12.8,
            height: selected ? 20 : 10,
            child: SvgPicture.asset(iconAsset, fit: BoxFit.contain),
          ),
        ),
        if (selected && label != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xCC0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label!,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
      ],
    );
  }
}

class _MapControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SquareButton(asset: AppAssets.discoverMapPlus),
        SizedBox(height: 8),
        _SquareButton(asset: AppAssets.discoverMapMinus),
        SizedBox(height: 16),
        _SquareButton(
          asset: AppAssets.discoverMapLocate,
          color: Color(0xFFF1AA9E),
        ),
      ],
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.asset, this.color = Colors.white});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 14,
        height: 14,
        child: SvgPicture.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}

class _MapPreviewCard extends StatelessWidget {
  const _MapPreviewCard({required this.data});

  final DiscoverStoreCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              data.imageAsset,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Image.asset(
                AppAssets.discoverMapPreviewBg,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title.split(' · ').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 24,
                    height: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.distance,
                  style: TextStyle(
                    color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.waiting.replaceFirst('预计等待: ', ''),
                  style: TextStyle(
                    color: const Color(0xFF1E293B).withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      data.price,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: const Text(
                        '详情',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverEmptyState extends StatelessWidget {
  const _DiscoverEmptyState({
    required this.onOpenFilter,
    required this.mapMode,
  });

  final VoidCallback onOpenFilter;
  final bool mapMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF101A2A).withValues(alpha: mapMode ? 0.84 : 1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '没有符合条件的餐厅',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '请调整筛选条件后再试',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onOpenFilter,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.backgroundColor,
              ),
              child: const Text('重新筛选'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeToggleButton extends StatelessWidget {
  const _ModeToggleButton({
    required this.iconAsset,
    required this.text,
    required this.onTap,
  });

  final String iconAsset;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 13),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 15,
              height: 15,
              child: SvgPicture.asset(iconAsset, fit: BoxFit.contain),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.asset, this.onTap});

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
          child: SvgPicture.asset(asset, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.text,
    required this.chevronAsset,
    required this.rounded,
    required this.backgroundAlpha,
    required this.onTap,
  });

  final String text;
  final String chevronAsset;
  final double rounded;
  final double backgroundAlpha;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: backgroundAlpha),
          borderRadius: BorderRadius.circular(rounded),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 12),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 8.17,
              height: 8.17,
              child: SvgPicture.asset(chevronAsset),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortTabs extends StatelessWidget {
  const _SortTabs({required this.activeIndex, required this.onTap});

  final int activeIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const List<String> tabs = <String>['智能推荐', '距离最近', '等待最短', '评分最高'];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 46,
        child: Row(
          children: List<Widget>.generate(tabs.length, (int index) {
            final bool active = index == activeIndex;
            return Padding(
              padding: EdgeInsets.only(
                right: index == tabs.length - 1 ? 0 : 24,
              ),
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: active
                            ? AppTheme.accentColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: active
                          ? AppTheme.accentColor
                          : const Color(0xFFF1F5F9).withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
