import 'package:flutter/material.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/auth/presentation/pages/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '食时',
      theme: AppTheme.materialTheme,
      home: const LoginPage(),
    );
  }
}
