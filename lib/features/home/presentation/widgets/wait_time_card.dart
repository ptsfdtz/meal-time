import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtime/core/assets/app_assets.dart';
import 'package:mealtime/core/theme/app_theme.dart';

class WaitTimeCard extends StatelessWidget {
  const WaitTimeCard({
    super.key,
    required this.waitMinutes,
    required this.onChanged,
  });

  final double waitMinutes;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
      child: Column(
        children: [
          Row(
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: AppTheme.backgroundColor,
                    fontSize: 20,
                    height: 1,
                  ),
                  children: [
                    const TextSpan(
                      text: '我愿意等',
                      style: TextStyle(fontSize: 20),
                    ),
                    TextSpan(
                      text: ' ${waitMinutes.round()} ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF1AA9E),
                        fontSize: 30,
                      ),
                    ),
                    const TextSpan(text: '分钟', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0x1A48416B),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.5),
                  child: SvgPicture.asset(
                    AppAssets.homeTimer,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _GradientSlider(waitMinutes: waitMinutes, onChanged: onChanged),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ScaleLabel(text: '0'),
              _ScaleLabel(text: '15'),
              _ScaleLabel(text: '30'),
              _ScaleLabel(text: '45'),
              _ScaleLabel(text: '60+'),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradientSlider extends StatelessWidget {
  const _GradientSlider({required this.waitMinutes, required this.onChanged});

  final double waitMinutes;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9EC5F0),
                  Color(0xFFEDC28D),
                  Color(0xFFF1AA9E),
                ],
              ),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 8,
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
              overlayShape: SliderComponentShape.noOverlay,
              thumbColor: AppTheme.backgroundColor,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            ),
            child: Slider(
              value: waitMinutes,
              min: 0,
              max: 60,
              divisions: 4,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScaleLabel extends StatelessWidget {
  const _ScaleLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppTheme.backgroundColor,
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
    );
  }
}
