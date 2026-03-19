import 'package:flutter/material.dart';
import 'package:mealtime/core/navigation/app_route_names.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/auth/presentation/pages/login_page.dart';
import 'package:mealtime/features/feed/presentation/models/feed_models.dart';
import 'package:mealtime/features/feed/presentation/pages/feed_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '食时',
      theme: AppTheme.materialTheme,
      home: const LoginPage(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == AppRouteNames.feed) {
          final FeedPageArgs args = settings.arguments is FeedPageArgs
              ? settings.arguments! as FeedPageArgs
              : const FeedPageArgs();
          return PageRouteBuilder<void>(
            settings: settings,
            pageBuilder:
                (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) => FeedPage(args: args),
            transitionsBuilder:
                (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  final Animation<Offset> slide =
                      Tween<Offset>(
                        begin: const Offset(0.06, 0),
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
          );
        }
        return null;
      },
    );
  }
}
