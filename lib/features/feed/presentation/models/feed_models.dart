import 'package:mealtime/core/assets/app_assets.dart';

enum FeedTab { reminders, social }

enum FeedOrigin { home, discover }

class FeedPageArgs {
  const FeedPageArgs({
    this.initialTab = FeedTab.social,
    this.origin = FeedOrigin.home,
  });

  final FeedTab initialTab;
  final FeedOrigin origin;
}

enum FeedReminderTone { spotlight, neutral, warning, info }

class FeedReminderItem {
  const FeedReminderItem({
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.iconAsset,
    required this.tone,
  });

  final String title;
  final String description;
  final String timeAgo;
  final String iconAsset;
  final FeedReminderTone tone;
}

class FeedVoteOption {
  const FeedVoteOption({required this.label, required this.votes});

  final String label;
  final String votes;
}

class FeedConversationItem {
  const FeedConversationItem({
    required this.initiator,
    required this.title,
    required this.options,
    required this.memberAvatars,
    required this.overflowCount,
    required this.ctaLabel,
  });

  final String initiator;
  final String title;
  final List<FeedVoteOption> options;
  final List<String> memberAvatars;
  final int overflowCount;
  final String ctaLabel;
}

class FeedUpcomingMeetItem {
  const FeedUpcomingMeetItem({
    required this.statusLabel,
    required this.title,
    required this.location,
    required this.memberAvatars,
    required this.participantLabel,
  });

  final String statusLabel;
  final String title;
  final String location;
  final List<String> memberAvatars;
  final String participantLabel;
}

class FeedFriendActivity {
  const FeedFriendActivity({
    required this.name,
    required this.timeAgo,
    required this.description,
    required this.avatarAsset,
    required this.likes,
    required this.comments,
    this.imageAsset,
  });

  final String name;
  final String timeAgo;
  final String description;
  final String avatarAsset;
  final String likes;
  final String comments;
  final String? imageAsset;
}

const List<FeedReminderItem> feedReminderItems = <FeedReminderItem>[
  FeedReminderItem(
    title: '叫号提醒',
    description: '太二酸菜鱼 前方还有3桌',
    timeAgo: '5分钟前',
    iconAsset: AppAssets.feedReminderCall,
    tone: FeedReminderTone.spotlight,
  ),
  FeedReminderItem(
    title: '人流预警',
    description: '你关注的海底捞 排队人数已降至10桌以下',
    timeAgo: '10分钟前',
    iconAsset: AppAssets.feedReminderFlow,
    tone: FeedReminderTone.neutral,
  ),
  FeedReminderItem(
    title: '预测峰值',
    description: '凌凌火锅 预计30分钟后进入午市高峰',
    timeAgo: '30分钟前',
    iconAsset: AppAssets.feedReminderClock,
    tone: FeedReminderTone.neutral,
  ),
  FeedReminderItem(
    title: '过号提醒',
    description: '太二酸菜鱼 您的号码已过号',
    timeAgo: '1小时前',
    iconAsset: AppAssets.feedReminderWarning,
    tone: FeedReminderTone.warning,
  ),
  FeedReminderItem(
    title: '系统通知',
    description: '食时新功能：组队投票已上线啦',
    timeAgo: '2小时前',
    iconAsset: AppAssets.feedReminderSystem,
    tone: FeedReminderTone.info,
  ),
];

const FeedConversationItem feedConversationItem = FeedConversationItem(
  initiator: '张三 发起了投票',
  title: '周末聚餐选址',
  options: <FeedVoteOption>[
    FeedVoteOption(label: '太二', votes: '3票'),
    FeedVoteOption(label: '凌凌', votes: '1票'),
  ],
  memberAvatars: <String>[AppAssets.feedAvatarVote1, AppAssets.feedAvatarVote2],
  overflowCount: 2,
  ctaLabel: '去投票',
);

const FeedUpcomingMeetItem feedUpcomingMeetItem = FeedUpcomingMeetItem(
  statusLabel: '剩余 1小时',
  title: '周五晚火锅局',
  location: '望京 SOHO 附近',
  memberAvatars: <String>[AppAssets.feedAvatarVote1, AppAssets.feedAvatarVote2],
  participantLabel: '5人参与',
);

const List<FeedFriendActivity> feedFriendActivities = <FeedFriendActivity>[
  FeedFriendActivity(
    name: '李四',
    timeAgo: '20分钟前',
    description: '参与了组队投票：周末聚餐去哪儿',
    avatarAsset: AppAssets.feedAvatarLisi,
    likes: '12',
    comments: '3',
  ),
  FeedFriendActivity(
    name: '王五',
    timeAgo: '1小时前',
    description: '收藏了 太二酸菜鱼',
    avatarAsset: AppAssets.feedAvatarWangwu,
    likes: '45',
    comments: '8',
    imageAsset: AppAssets.feedPostRestaurant,
  ),
  FeedFriendActivity(
    name: '赵六',
    timeAgo: '3小时前',
    description: '通过 Plan B 发现了 新元素',
    avatarAsset: AppAssets.feedAvatarZhaoliu,
    likes: '22',
    comments: '1',
  ),
];
