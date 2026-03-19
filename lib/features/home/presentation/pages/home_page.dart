import 'package:flutter/material.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/core/navigation/app_route_names.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/auth/presentation/widgets/entrance_section.dart';
import 'package:mealtime/features/discover/presentation/pages/discover_page.dart';
import 'package:mealtime/features/feed/presentation/models/feed_models.dart';
import 'package:mealtime/features/home/presentation/widgets/floating_bottom_nav.dart';
import 'package:mealtime/features/home/presentation/widgets/home_header.dart';
import 'package:mealtime/features/home/presentation/widgets/mall_card.dart';
import 'package:mealtime/features/home/presentation/widgets/wait_time_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _waitMinutes = 30;
  bool _showHeader = false;
  bool _showQuickCard = false;
  bool _showMallCards = false;
  bool _showBottomNav = false;

  final List<MallCardData> _malls = const [
    MallCardData(
      name: '环球港购物中心',
      imageAsset: AppAssets.homeMallGlobalHarbor,
      distance: '1.2km · 步行15分钟',
      tag: '目前较拥挤',
      tagIconAsset: AppAssets.homeTagCrowded,
      tagColor: Color(0xCCF1AA9E),
      primaryShop: '海底捞火锅',
      primaryWait: '15-25 min',
      secondaryShop: '太二酸菜鱼',
      secondaryWait: '10 min',
      favorite: true,
    ),
    MallCardData(
      name: '万达广场',
      imageAsset: AppAssets.homeMallWanda,
      distance: '2.5km · 骑行10分钟',
      tag: '环境清静',
      tagIconAsset: AppAssets.homeTagQuiet,
      tagColor: Color(0xCC9EC5F0),
      primaryShop: '新元素 Element Fresh',
      primaryWait: '无需等待',
      secondaryShop: '喜茶 HEYTEA',
      secondaryWait: '15 min',
      favorite: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startEntranceAnimation();
  }

  void _startEntranceAnimation() {
    Future<void>.delayed(
      const Duration(milliseconds: 50),
      () => _setIfMounted(() => _showHeader = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 150),
      () => _setIfMounted(() => _showQuickCard = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 250),
      () => _setIfMounted(() => _showMallCards = true),
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

  void _openDiscover(DiscoverPageConfig config) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: AppRouteNames.discover),
        builder: (_) => DiscoverPage(config: config),
      ),
    );
  }

  Future<void> _openFeed(FeedTab tab) {
    return Navigator.of(context).pushNamed(
      AppRouteNames.feed,
      arguments: FeedPageArgs(initialTab: tab, origin: FeedOrigin.home),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                EntranceSection(
                  visible: _showHeader,
                  child: HomeHeader(
                    onBellTap: () {
                      _openFeed(FeedTab.reminders);
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 116),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EntranceSection(
                          visible: _showQuickCard,
                          child: WaitTimeCard(
                            waitMinutes: _waitMinutes,
                            onChanged: (double value) {
                              setState(() {
                                _waitMinutes = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        EntranceSection(
                          visible: _showMallCards,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      '附近商场',
                                      style: TextStyle(
                                        color: Color(0xFFF1F5F9),
                                        fontSize: 20,
                                        height: 1,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '查看全部',
                                      style: TextStyle(
                                        color: AppTheme.accentColor.withValues(
                                          alpha: 0.85,
                                        ),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () =>
                                          _openDiscover(DiscoverPageConfig.all),
                                      child: const Icon(
                                        Icons.chevron_right,
                                        color: AppTheme.accentColor,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              MallCard(
                                data: _malls[0],
                                onTap: () => _openDiscover(
                                  DiscoverPageConfig.globalHarbor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              MallCard(
                                data: _malls[1],
                                onTap: () =>
                                    _openDiscover(DiscoverPageConfig.wanda),
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
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: EntranceSection(
              visible: _showBottomNav,
              child: FloatingBottomNav(
                items: const [
                  BottomNavItemData(
                    iconAsset: AppAssets.homeNavHome,
                    label: '首页',
                  ),
                  BottomNavItemData(
                    iconAsset: AppAssets.homeNavStore,
                    label: '寻店',
                  ),
                  BottomNavItemData(
                    iconAsset: AppAssets.homeNavFeed,
                    label: '动态',
                  ),
                  BottomNavItemData(
                    iconAsset: AppAssets.homeNavProfile,
                    label: '我的',
                  ),
                ],
                selectedIndex: 0,
                onTap: (int index) {
                  if (index == 1) {
                    _openDiscover(DiscoverPageConfig.all);
                  }
                  if (index == 2) {
                    _openFeed(FeedTab.social);
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
