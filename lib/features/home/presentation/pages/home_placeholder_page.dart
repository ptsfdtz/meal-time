import 'package:flutter/material.dart';
import 'package:mealtime/core/theme/app_theme.dart';

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key, required this.account});

  final String account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('食时'),
        backgroundColor: AppTheme.backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('欢迎回来，$account', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              '第一个界面（登录页）已完成',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
            ),
          ],
        ),
      ),
    );
  }
}
