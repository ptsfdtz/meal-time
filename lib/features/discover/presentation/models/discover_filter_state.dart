import 'package:mealtime/features/discover/presentation/widgets/discover_store_card.dart';

class DiscoverFilterState {
  const DiscoverFilterState({
    required this.maxWaitMinutes,
    required this.cuisine,
    required this.maxDistanceKm,
  });

  final int maxWaitMinutes;
  final String? cuisine;
  final double? maxDistanceKm;

  static const DiscoverFilterState initial = DiscoverFilterState(
    maxWaitMinutes: 60,
    cuisine: null,
    maxDistanceKm: null,
  );

  DiscoverFilterState copyWith({
    int? maxWaitMinutes,
    String? cuisine,
    double? maxDistanceKm,
    bool clearCuisine = false,
    bool clearDistance = false,
  }) {
    return DiscoverFilterState(
      maxWaitMinutes: maxWaitMinutes ?? this.maxWaitMinutes,
      cuisine: clearCuisine ? null : (cuisine ?? this.cuisine),
      maxDistanceKm: clearDistance
          ? null
          : (maxDistanceKm ?? this.maxDistanceKm),
    );
  }

  bool matches(DiscoverStoreCardData data) {
    if (data.estimatedWaitMinutes > maxWaitMinutes) {
      return false;
    }
    if (cuisine != null && cuisine!.isNotEmpty && data.cuisine != cuisine) {
      return false;
    }
    if (maxDistanceKm != null && data.distanceKm > maxDistanceKm!) {
      return false;
    }
    return true;
  }

  String get waitChipLabel {
    if (maxWaitMinutes >= 60) {
      return '等待不限';
    }
    return '等待<$maxWaitMinutes分钟';
  }

  String get cuisineChipLabel => cuisine ?? '全部类型';

  String get distanceChipLabel {
    if (maxDistanceKm == null) {
      return '不限距离';
    }
    if (maxDistanceKm == 0.5) {
      return '附近500m';
    }
    if (maxDistanceKm == 1) {
      return '附近1km';
    }
    if (maxDistanceKm == 3) {
      return '附近3km';
    }
    if (maxDistanceKm == 5) {
      return '附近5km';
    }
    return '附近${maxDistanceKm!.toStringAsFixed(1)}km';
  }
}
