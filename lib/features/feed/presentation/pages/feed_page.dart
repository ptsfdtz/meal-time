import 'package:flutter/material.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/core/navigation/app_route_names.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/auth/presentation/widgets/entrance_section.dart';
import 'package:mealtime/features/discover/presentation/pages/discover_page.dart';
import 'package:mealtime/features/feed/presentation/models/feed_models.dart';
import 'package:mealtime/features/feed/presentation/widgets/feed_header.dart';
import 'package:mealtime/features/feed/presentation/widgets/feed_reminder_card.dart';
import 'package:mealtime/features/feed/presentation/widgets/feed_social_cards.dart';
import 'package:mealtime/features/home/presentation/widgets/floating_bottom_nav.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.args});

  final FeedPageArgs args;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late FeedTab _activeTab;
  bool _showHeader = false;
  bool _showContent = false;
  bool _showBottomNav = false;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.args.initialTab;
    _startEntranceAnimation();
  }

  void _startEntranceAnimation() {
    Future<void>.delayed(
      const Duration(milliseconds: 50),
      () => _updateIfMounted(() => _showHeader = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 180),
      () => _updateIfMounted(() => _showContent = true),
    );
    Future<void>.delayed(
      const Duration(milliseconds: 280),
      () => _updateIfMounted(() => _showBottomNav = true),
    );
  }

  void _updateIfMounted(VoidCallback callback) {
    if (!mounted) {
      return;
    }
    setState(callback);
  }

  void _showHint(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _handleBottomNavTap(int index) {
    if (index == 2 || index == 3) {
      return;
    }
    if (index == 0) {
      if (widget.args.origin == FeedOrigin.home) {
        Navigator.of(context).pop();
        return;
      }
      Navigator.of(context).popUntil(ModalRoute.withName(AppRouteNames.home));
      return;
    }
    if (widget.args.origin == FeedOrigin.discover) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: AppRouteNames.discover),
        builder: (_) => const DiscoverPage(config: DiscoverPageConfig.all),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double contentBottomPadding =
        152 + MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              children: <Widget>[
                EntranceSection(
                  visible: _showHeader,
                  child: FeedHeader(
                    activeTab: _activeTab,
                    onTabChanged: (FeedTab tab) {
                      if (_activeTab == tab) {
                        return;
                      }
                      setState(() {
                        _activeTab = tab;
                      });
                    },
                    onSearchTap: () => _showHint('搜索功能即将开放'),
                    onSettingsTap: () => _showHint('提醒设置正在准备中'),
                  ),
                ),
                Expanded(
                  child: EntranceSection(
                    visible: _showContent,
                    child: AnimatedSwitcher(
                      duration: AppTheme.slowDuration,
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeOutCubic,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            final Animation<Offset> slide =
                                Tween<Offset>(
                                  begin: const Offset(0.05, 0),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic,
                                  ),
                                );
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: slide,
                                child: child,
                              ),
                            );
                          },
                      child: _activeTab == FeedTab.reminders
                          ? _ReminderView(
                              key: const ValueKey<String>('reminders'),
                              bottomPadding: contentBottomPadding,
                              onCardTap: (FeedReminderItem item) {
                                _showHint('${item.title} 已更新');
                              },
                              onPromoTap: () {
                                setState(() {
                                  _activeTab = FeedTab.social;
                                });
                              },
                            )
                          : _SocialView(
                              key: const ValueKey<String>('social'),
                              bottomPadding: contentBottomPadding,
                              onVoteTap: () => _showHint('投票功能即将开放'),
                              onMoreTap: () => _showHint('更多会话即将开放'),
                              onUpcomingTap: () => _showHint('已为你打开会话详情'),
                              onActivityTap: (FeedFriendActivity item) =>
                                  _showHint('${item.name} 的动态已同步'),
                            ),
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
                items: const <BottomNavItemData>[
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
                selectedIndex: 2,
                onTap: _handleBottomNavTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderView extends StatelessWidget {
  const _ReminderView({
    super.key,
    required this.bottomPadding,
    required this.onCardTap,
    required this.onPromoTap,
  });

  final double bottomPadding;
  final ValueChanged<FeedReminderItem> onCardTap;
  final VoidCallback onPromoTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 18, 16, bottomPadding),
      child: Column(
        children: <Widget>[
          ...List<Widget>.generate(feedReminderItems.length, (int index) {
            final FeedReminderItem item = feedReminderItems[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == feedReminderItems.length - 1 ? 20 : 14,
              ),
              child: FeedReminderCard(item: item, onTap: () => onCardTap(item)),
            );
          }),
          FeedPromoCard(onTap: onPromoTap),
        ],
      ),
    );
  }
}

class _SocialView extends StatelessWidget {
  const _SocialView({
    super.key,
    required this.bottomPadding,
    required this.onVoteTap,
    required this.onMoreTap,
    required this.onUpcomingTap,
    required this.onActivityTap,
  });

  final double bottomPadding;
  final VoidCallback onVoteTap;
  final VoidCallback onMoreTap;
  final VoidCallback onUpcomingTap;
  final ValueChanged<FeedFriendActivity> onActivityTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 18, 16, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FeedSectionHeader(
            title: '组队会话',
            trailingText: '更多',
            onTrailingTap: onMoreTap,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 272,
            child: FeedConversationPanel(
              conversation: feedConversationItem,
              upcomingMeet: feedUpcomingMeetItem,
              onVoteTap: onVoteTap,
              onUpcomingTap: onUpcomingTap,
            ),
          ),
          const SizedBox(height: 34),
          const FeedSectionHeader(title: '好友动态'),
          const SizedBox(height: 16),
          ...List<Widget>.generate(feedFriendActivities.length, (int index) {
            final FeedFriendActivity item = feedFriendActivities[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == feedFriendActivities.length - 1 ? 0 : 14,
              ),
              child: FeedFriendActivityCard(
                item: item,
                onTap: () => onActivityTap(item),
              ),
            );
          }),
        ],
      ),
    );
  }
}
