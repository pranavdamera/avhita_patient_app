import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/theme.dart';
import '../../../models/models.dart';
import '../../../repositories/mock_repository.dart';
import '../../../widgets/widgets.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});
  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  List<TrendPoint> _hrTrend = [];
  List<TrendPoint> _bpTrend = [];
  Vitals? _vitals;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      MockRepo.getHeartTrend(),
      MockRepo.getBpTrend(),
      MockRepo.getVitals(),
    ]);
    if (mounted) setState(() {
      _hrTrend = results[0] as List<TrendPoint>;
      _bpTrend = results[1] as List<TrendPoint>;
      _vitals = results[2] as Vitals;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            SliverAppBar(
              floating: true, snap: true,
              backgroundColor: AppColors.surface,
              surfaceTintColor: Colors.transparent,
              title: Text('Health Insights', style: AppTypography.h2),
            ),
            SliverToBoxAdapter(
              child: _isLoading ? _skeleton() : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Weekly summary hero ───────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: AppDecorations.heroCard(AppColors.heroHeartGradient),
                      child: Column(
                        children: [
                          const Text('💚', style: TextStyle(fontSize: 36)),
                          const SizedBox(height: 8),
                          Text('Weekly Summary', style: AppTypography.h3.copyWith(color: AppColors.green)),
                          const SizedBox(height: 4),
                          Text('All vitals within healthy range', style: AppTypography.bodySmall),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _SummaryPill(emoji: '❤️', label: 'Avg HR', value: '73 bpm'),
                              _SummaryPill(emoji: '💉', label: 'Avg BP', value: '119/77'),
                              _SummaryPill(emoji: '💧', label: 'Avg SpO₂', value: '97%'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Heart Rate Trend ──────────────────────
                    Text('Heart Rate Trend', style: AppTypography.h3),
                    const SizedBox(height: 4),
                    Text('Last 7 days', style: AppTypography.bodySmall),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.card(),
                      height: 220,
                      child: _buildChart(_hrTrend, AppColors.red, 50, 110, 'bpm'),
                    ),
                    const SizedBox(height: 10),
                    const InfoBox(
                      title: 'Heart Rate Insight',
                      text: 'Your average resting heart rate this week is 73 bpm — well within the healthy range of 60-100 bpm.',
                    ),
                    const SizedBox(height: 24),

                    // ── Blood Pressure Trend ──────────────────
                    Text('Blood Pressure Trend', style: AppTypography.h3),
                    const SizedBox(height: 4),
                    Text('Systolic - last 7 days', style: AppTypography.bodySmall),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.card(),
                      height: 220,
                      child: _buildChart(_bpTrend, AppColors.blue, 100, 150, 'mmHg'),
                    ),
                    const SizedBox(height: 10),
                    InfoBox(
                      title: 'BP Trending Down',
                      text: 'Average systolic pressure decreased 5 points this month. Keep it up!',
                      borderColor: AppColors.green, bgColor: AppColors.greenSurface,
                      titleColor: const Color(0xFF065F46), textColor: const Color(0xFF064E3B),
                    ),
                    const SizedBox(height: 24),

                    // ── Activity & Sleep placeholders ─────────
                    Text('Activity Summary', style: AppTypography.h3),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: AppDecorations.card(),
                      child: Row(
                        children: [
                          _ActivityItem(emoji: '🚶', label: 'Steps', value: '6,842', target: 'Goal: 8,000'),
                          const SizedBox(width: 12),
                          _ActivityItem(emoji: '🔥', label: 'Calories', value: '1,850', target: 'Goal: 2,000'),
                          const SizedBox(width: 12),
                          _ActivityItem(emoji: '😴', label: 'Sleep', value: '7.2h', target: 'Goal: 7-9h'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<TrendPoint> data, Color color, double minY, double maxY, String unit) {
    if (data.isEmpty) return const SizedBox.shrink();
    return LineChart(
      LineChartData(
        minY: minY, maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.divider.withOpacity(0.5), strokeWidth: 0.8),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28,
              getTitlesWidget: (val, _) {
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final i = val.toInt();
                if (i >= 0 && i < days.length) {
                  return Text(days[i], style: AppTypography.labelSmall.copyWith(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 36,
              getTitlesWidget: (val, _) =>
                  Text('${val.toInt()}', style: AppTypography.labelSmall.copyWith(fontSize: 10)),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList(),
            isCurved: true, curveSmoothness: 0.3,
            color: color, barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) =>
              FlDotCirclePainter(radius: 4, color: color, strokeWidth: 2, strokeColor: Colors.white)),
            belowBarData: BarAreaData(show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeleton() => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(children: List.generate(4, (_) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(height: 120, decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(20))),
    ))),
  );
}

class _SummaryPill extends StatelessWidget {
  final String emoji, label, value;
  const _SummaryPill({required this.emoji, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 2),
          Text(value, style: AppTypography.h4.copyWith(fontSize: 13)),
          Text(label, style: AppTypography.labelSmall.copyWith(fontSize: 9)),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String emoji, label, value, target;
  const _ActivityItem({required this.emoji, required this.label, required this.value, required this.target});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(value, style: AppTypography.h4),
            Text(label, style: AppTypography.label),
            const SizedBox(height: 2),
            Text(target, style: AppTypography.labelSmall.copyWith(fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
