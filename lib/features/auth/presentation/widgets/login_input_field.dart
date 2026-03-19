import 'package:flutter/material.dart';
import 'package:mealtime/core/theme/app_theme.dart';

class LoginInputField extends StatefulWidget {
  const LoginInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.trailingLabel,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  final String label;
  final String hintText;
  final String? trailingLabel;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<LoginInputField> createState() => _LoginInputFieldState();
}

class _LoginInputFieldState extends State<LoginInputField> {
  late final FocusNode _focusNode;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (!mounted) {
      return;
    }
    setState(() {
      _focused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (widget.trailingLabel != null)
              Text(
                widget.trailingLabel!,
                style: TextStyle(
                  color: AppTheme.accentColor.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: AppTheme.normalDuration,
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: AppTheme.inputBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _focused
                  ? AppTheme.accentColor.withValues(alpha: 0.9)
                  : const Color(0xFF6B7280),
              width: _focused ? 1.4 : 1,
            ),
            boxShadow: _focused
                ? const [
                    BoxShadow(
                      color: Color(0x1AFFFFFF),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : const [],
          ),
          child: TextField(
            focusNode: _focusNode,
            controller: widget.controller,
            obscureText: widget.obscureText,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            style: const TextStyle(
              color: AppTheme.backgroundColor,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: AppTheme.backgroundColor.withValues(alpha: 0.45),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
