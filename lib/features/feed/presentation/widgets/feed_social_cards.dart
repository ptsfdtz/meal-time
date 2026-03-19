import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/feed/presentation/models/feed_models.dart';

class FeedSectionHeader extends StatelessWidget {
  const FeedSectionHeader({
    super.key,
    required this.title,
    this.trailingText,
    this.onTrailingTap,
  });

  final String title;
  final String? trailingText;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.accentColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (trailingText != null)
          GestureDetector(
            onTap: onTrailingTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: <Widget>[
                Text(
                  trailingText!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  AppAssets.feedChevron,
                  width: 10,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class FeedConversationPanel extends StatefulWidget {
  const FeedConversationPanel({
    super.key,
    required this.conversation,
    required this.upcomingMeet,
    required this.onVoteTap,
    required this.onUpcomingTap,
  });

  final FeedConversationItem conversation;
  final FeedUpcomingMeetItem upcomingMeet;
  final VoidCallback onVoteTap;
  final VoidCallback onUpcomingTap;

  @override
  State<FeedConversationPanel> createState() => _FeedConversationPanelState();
}

class _FeedConversationPanelState extends State<FeedConversationPanel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.82);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      padEnds: false,
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _ConversationCard(
            conversation: widget.conversation,
            onVoteTap: widget.onVoteTap,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _UpcomingMeetCard(
            item: widget.upcomingMeet,
            onTap: widget.onUpcomingTap,
          ),
        ),
      ],
    );
  }
}

class FeedFriendActivityCard extends StatelessWidget {
  const FeedFriendActivityCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final FeedFriendActivity item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Avatar(asset: item.avatarAsset, size: 42),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: AppTheme.accentColor,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item.timeAgo,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.68),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.84),
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (item.imageAsset != null) ...<Widget>[
              const SizedBox(height: 0),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  item.imageAsset!,
                  width: double.infinity,
                  height: 112,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const SizedBox(height: 0),
            Row(
              children: <Widget>[
                _MetaButton(iconAsset: AppAssets.feedLike, label: item.likes),
                const SizedBox(width: 20),
                _MetaButton(
                  iconAsset: AppAssets.feedComment,
                  label: item.comments,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  const _ConversationCard({
    required this.conversation,
    required this.onVoteTap,
  });

  final FeedConversationItem conversation;
  final VoidCallback onVoteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _Avatar(asset: AppAssets.feedAvatarZhang, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  conversation.initiator,
                  style: const TextStyle(
                    color: AppTheme.backgroundColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            conversation.title,
            style: const TextStyle(
              color: AppTheme.backgroundColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...conversation.options.map(
            (FeedVoteOption option) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      option.label,
                      style: const TextStyle(
                        color: AppTheme.backgroundColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      option.votes,
                      style: const TextStyle(
                        color: AppTheme.backgroundColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: <Widget>[
              SizedBox(
                width: 72,
                height: 28,
                child: Stack(
                  children: <Widget>[
                    for (
                      int index = 0;
                      index < conversation.memberAvatars.length;
                      index++
                    )
                      Positioned(
                        left: index * 18,
                        child: _Avatar(
                          asset: conversation.memberAvatars[index],
                          size: 28,
                          borderColor: AppTheme.accentColor,
                        ),
                      ),
                    Positioned(
                      left: conversation.memberAvatars.length * 18,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor.withValues(
                            alpha: 0.9,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.accentColor,
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '+${conversation.overflowCount}',
                          style: const TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onVoteTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    conversation.ctaLabel,
                    style: const TextStyle(
                      color: AppTheme.accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingMeetCard extends StatelessWidget {
  const _UpcomingMeetCard({required this.item, required this.onTap});

  final FeedUpcomingMeetItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(21, 21, 21, 21),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  AppAssets.feedSessionClock,
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                Text(
                  item.statusLabel,
                  style: const TextStyle(
                    color: Color(0xFF9EC5F0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              item.title,
              style: const TextStyle(
                color: AppTheme.accentColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.location,
              style: TextStyle(
                color: const Color(0xFF9EC5F0).withValues(alpha: 0.96),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const Spacer(),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 48,
                  height: 28,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      for (
                        int index = 0;
                        index < item.memberAvatars.length;
                        index++
                      )
                        Positioned(
                          left: index * 20,
                          child: _Avatar(
                            asset: item.memberAvatars[index],
                            size: 28,
                            borderColor: AppTheme.backgroundColor,
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  item.participantLabel,
                  style: const TextStyle(
                    color: AppTheme.accentColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaButton extends StatelessWidget {
  const _MetaButton({required this.iconAsset, required this.label});

  final String iconAsset;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SvgPicture.asset(iconAsset, width: 14, fit: BoxFit.contain),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFB7D5F5).withValues(alpha: 0.92),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.asset,
    required this.size,
    this.borderColor = Colors.white,
  });

  final String asset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        image: DecorationImage(image: AssetImage(asset), fit: BoxFit.cover),
      ),
    );
  }
}
