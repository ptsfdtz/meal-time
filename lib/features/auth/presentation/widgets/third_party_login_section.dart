import 'package:flutter/material.dart';
import 'package:mealtime/core/theme/app_theme.dart';

class ThirdPartyLoginSection extends StatelessWidget {
  const ThirdPartyLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(color: Colors.white.withValues(alpha: 0.15)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '第三方账号登录',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: Colors.white.withValues(alpha: 0.15)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ThirdPartyButton(
                icon: Icon(Icons.wechat_rounded, color: Colors.white, size: 22),
              ),
              SizedBox(width: 30),
              _ThirdPartyButton(
                icon: Icon(Icons.apple, color: Colors.white, size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThirdPartyButton extends StatefulWidget {
  const _ThirdPartyButton({required this.icon});

  final Widget icon;

  @override
  State<_ThirdPartyButton> createState() => _ThirdPartyButtonState();
}

class _ThirdPartyButtonState extends State<_ThirdPartyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.92 : 1,
      duration: AppTheme.fastDuration,
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          alignment: Alignment.center,
          child: widget.icon,
        ),
      ),
    );
  }
}
