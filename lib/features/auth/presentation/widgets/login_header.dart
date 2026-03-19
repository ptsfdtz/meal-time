import 'package:flutter/material.dart';
import 'package:mealtime/core/theme/app_theme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 36),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.accentColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              '食',
              style: TextStyle(
                fontSize: 36,
                color: AppTheme.backgroundColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '食时',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 44,
              letterSpacing: 4,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            'SHI SHI',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
