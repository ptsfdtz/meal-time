import 'package:flutter/material.dart';
import 'package:mealtime/core/theme/app_theme.dart';
import 'package:mealtime/features/auth/presentation/widgets/login_input_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.accountController,
    required this.passwordController,
    required this.isSubmitting,
    required this.isButtonPressed,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
    required this.onSubmit,
  });

  final TextEditingController accountController;
  final TextEditingController passwordController;
  final bool isSubmitting;
  final bool isButtonPressed;
  final GestureTapDownCallback onTapDown;
  final GestureTapUpCallback onTapUp;
  final GestureTapCancelCallback onTapCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginInputField(
          key: const ValueKey<String>('accountField'),
          label: '账号',
          hintText: '手机号/邮箱',
          controller: accountController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        LoginInputField(
          key: const ValueKey<String>('passwordField'),
          label: '密码',
          hintText: '请输入密码',
          trailingLabel: '忘记密码？',
          obscureText: true,
          controller: passwordController,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 28),
        AnimatedScale(
          scale: isButtonPressed ? 0.98 : 1,
          duration: AppTheme.fastDuration,
          curve: Curves.easeOut,
          child: GestureDetector(
            onTapDown: onTapDown,
            onTapUp: onTapUp,
            onTapCancel: onTapCancel,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                key: const ValueKey<String>('loginButton'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isSubmitting ? null : onSubmit,
                child: AnimatedSwitcher(
                  duration: AppTheme.fastDuration,
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          '登 录',
                          style: TextStyle(fontSize: 22, letterSpacing: 2),
                        ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '还没有账号？',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              '立即注册',
              style: TextStyle(
                color: AppTheme.accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
