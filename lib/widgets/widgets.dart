import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme.dart';
import '../models/models.dart';
import '../repositories/mock_repository.dart';

// ═══════════════════════════════════════════════════════════════
// ANIMATED PRESS CARD — scale + elevation response on tap
// ═══════════════════════════════════════════════════════════════
class AnimatedPressCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final BoxDecoration? decoration;
  const AnimatedPressCard({super.key, required this.child, this.onTap, this.decoration});

  @override
  State<AnimatedPressCard> createState() => _AnimatedPressCardState();
}

class _AnimatedPressCardState extends State<AnimatedPressCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100),
        reverseDuration: const Duration(milliseconds: 200));
    _scale = Tween(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => _ctrl.forward() : null,
        onTapUp: widget.onTap != null ? (_) => _ctrl.reverse() : null,
        onTapCancel: widget.onTap != null ? () => _ctrl.reverse() : null,
        onTap: () { HapticFeedback.lightImpact(); widget.onTap?.call(); },
        child: Container(decoration: widget.decoration, child: widget.child),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PULSING LIVE INDICATOR (matches HTML .status-dot)
// ═══════════════════════════════════════════════════════════════
class PulsingDot extends StatefulWidget {
  final double size;
  final Color color;
  const PulsingDot({super.key, this.size = 8, this.color = AppColors.green});
  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        width: widget.size, height: widget.size,
        decoration: BoxDecoration(
          color: widget.color, shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: widget.color.withOpacity(0.3 + _ctrl.value * 0.4),
              blurRadius: 3 + _ctrl.value * 4, spreadRadius: _ctrl.value * 2)],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HERO STATUS CARD (matches HTML .hero with gradient bg)
// ═══════════════════════════════════════════════════════════════
class HeroStatusCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final Color titleColor;
  final List<HeroStat> stats;
  final VoidCallback? onTap;

  const HeroStatusCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.titleColor = AppColors.green,
    required this.stats,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPressCard(
      onTap: onTap,
      decoration: AppDecorations.heroCard(gradient),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(title, style: AppTypography.heroTitle.copyWith(color: titleColor)),
            const SizedBox(height: 4),
            Text(subtitle, style: AppTypography.heroSubtitle),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: stats
                  .map((s) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(s.value, style: AppTypography.h2),
                            const SizedBox(height: 2),
                            Text(s.label, style: AppTypography.labelUpper),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroStat {
  final String value;
  final String label;
  HeroStat({required this.value, required this.label});
}

// ═══════════════════════════════════════════════════════════════
// METRIC TILE (matches HTML .metric with colored left border)
// ═══════════════════════════════════════════════════════════════
class MetricTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final String range;
  final Color valueColor;
  final Color borderColor;
  final Color? bgColor;
  final VoidCallback? onTap;

  const MetricTile({
    super.key,
    required this.emoji,
    required this.label,
    required this.value,
    required this.range,
    required this.valueColor,
    required this.borderColor,
    this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPressCard(
      onTap: onTap,
      decoration: AppDecorations.metricTile(borderColor: borderColor, bgColor: bgColor),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(label, style: AppTypography.metricLabel),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: AppTypography.metricValue.copyWith(color: valueColor)),
            const SizedBox(height: 4),
            Text(range, style: AppTypography.metricRange),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ECG PREVIEW (animated waveform, matches HTML .ecg-box)
// ═══════════════════════════════════════════════════════════════
class EcgPreviewCard extends StatefulWidget {
  final double height;
  final bool showHeader;
  final VoidCallback? onTap;
  const EcgPreviewCard({super.key, this.height = 140, this.showHeader = true, this.onTap});
  @override
  State<EcgPreviewCard> createState() => _EcgPreviewCardState();
}

class _EcgPreviewCardState extends State<EcgPreviewCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<double> _data;

  @override
  void initState() {
    super.initState();
    _data = MockRepo.generateEcgData();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedPressCard(
      onTap: widget.onTap,
      decoration: AppDecorations.card(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showHeader) ...[
              Row(
                children: [
                  const Text('📈', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('Live ECG', style: AppTypography.h4),
                  const SizedBox(width: 8),
                  const PulsingDot(size: 6),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blueLight, borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Strong Signal', style: AppTypography.badge),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            Container(
              height: widget.height,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFF8FAFC), Color(0xFFF0F9FF)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blueLight, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => CustomPaint(
                  painter: _EcgPainter(data: _data, offset: _ctrl.value),
                  size: Size(double.infinity, widget.height),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EcgPainter extends CustomPainter {
  final List<double> data;
  final double offset;
  _EcgPainter({required this.data, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    // Grid
    final gridPaint = Paint()..color = AppColors.blueLight.withOpacity(0.4)..strokeWidth = 0.5;
    for (int i = 0; i < 5; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    // Waveform
    final paint = Paint()
      ..color = AppColors.blue..strokeWidth = 2
      ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final path = Path();
    final centerY = size.height * 0.55;
    final amp = size.height * 0.38;
    final start = (offset * data.length).toInt() % data.length;
    for (int i = 0; i < data.length; i++) {
      final x = (i / data.length) * size.width;
      final di = (start + i) % data.length;
      final y = centerY - (data[di] * amp);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
    // Glow
    canvas.drawPath(path, Paint()..color = AppColors.blue.withOpacity(0.12)..strokeWidth = 5
      ..style = PaintingStyle.stroke..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
  }

  @override
  bool shouldRepaint(covariant _EcgPainter old) => offset != old.offset;
}

// ═══════════════════════════════════════════════════════════════
// INFO BOX (matches HTML .info-box with left border)
// ═══════════════════════════════════════════════════════════════
class InfoBox extends StatelessWidget {
  final String title;
  final String text;
  final Color borderColor;
  final Color bgColor;
  final Color titleColor;
  final Color textColor;

  const InfoBox({
    super.key,
    required this.title,
    required this.text,
    this.borderColor = AppColors.blue,
    this.bgColor = AppColors.blueSurface,
    this.titleColor = const Color(0xFF1E40AF),
    this.textColor = const Color(0xFF1E3A8A),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.infoBox(borderColor: borderColor, bgColor: bgColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.h4.copyWith(color: titleColor, fontSize: 14)),
          const SizedBox(height: 4),
          Text(text, style: AppTypography.bodySmall.copyWith(color: textColor, height: 1.5)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// INSIGHTS SECTION (matches HTML .insights)
// ═══════════════════════════════════════════════════════════════
class InsightsSection extends StatelessWidget {
  final String emoji;
  final String title;
  final Color titleColor;
  final List<Color> gradient;
  final Color borderColor;
  final Color numberColor;
  final List<HealthInsight> insights;

  const InsightsSection({
    super.key,
    required this.emoji,
    required this.title,
    required this.titleColor,
    required this.gradient,
    required this.borderColor,
    required this.numberColor,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.insightsCard(gradient, borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Text(title, style: AppTypography.h3.copyWith(color: titleColor)),
            ],
          ),
          const SizedBox(height: 16),
          ...insights.map((i) => _InsightItem(insight: i, numberColor: numberColor)),
        ],
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  final HealthInsight insight;
  final Color numberColor;
  const _InsightItem({required this.insight, required this.numberColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: numberColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text('${insight.number}',
                style: AppTypography.label.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(insight.title, style: AppTypography.h4.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(insight.text, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ALERT BANNER (matches HTML .alert)
// ═══════════════════════════════════════════════════════════════
class AlertBanner extends StatelessWidget {
  final HealthAlert alert;
  final VoidCallback? onDismiss;
  final VoidCallback? onContactDoctor;

  const AlertBanner({super.key, required this.alert, this.onDismiss, this.onContactDoctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.alertBanner(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('⚠️ ${alert.title}',
              style: AppTypography.h4.copyWith(color: const Color(0xFF991B1B))),
          const SizedBox(height: 8),
          Text(alert.message,
              style: AppTypography.bodySmall.copyWith(color: const Color(0xFF7F1D1D), height: 1.6)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onContactDoctor,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
                  child: const Text('Contact Doctor'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onDismiss,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.red),
                  foregroundColor: AppColors.red,
                ),
                child: const Text('Got It'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DEVICE CHIP (matches HTML .device-chip)
// ═══════════════════════════════════════════════════════════════
class DeviceChip extends StatelessWidget {
  final DeviceType type;
  final bool isActive;
  final VoidCallback? onTap;

  const DeviceChip({super.key, required this.type, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); onTap?.call(); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: AppDecorations.deviceChip(active: isActive),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(type.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(type.label, style: AppTypography.body.copyWith(
              color: isActive ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            )),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// QUICK ACTION CARD (matches HTML .action)
// ═══════════════════════════════════════════════════════════════
class QuickActionCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String? description;
  final bool isPrimary;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.emoji,
    required this.label,
    this.description,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPressCard(
      onTap: onTap,
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(label, style: AppTypography.label.copyWith(
              color: isPrimary ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w700,
            ), textAlign: TextAlign.center),
            if (description != null) ...[
              const SizedBox(height: 2),
              Text(description!, style: AppTypography.labelSmall.copyWith(
                color: isPrimary ? Colors.white70 : AppColors.textTertiary,
              ), textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SOS BUTTON (matches HTML .help-btn)
// ═══════════════════════════════════════════════════════════════
class SosButton extends StatelessWidget {
  final VoidCallback? onTap;
  const SosButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { HapticFeedback.heavyImpact(); onTap?.call(); },
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: AppColors.sos, shape: BoxShape.circle,
          boxShadow: AppDecorations.sosShadow(),
        ),
        alignment: Alignment.center,
        child: const Text('🆘', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
