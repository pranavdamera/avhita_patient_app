import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/theme.dart';
import '../../../models/models.dart';
import '../../../repositories/mock_repository.dart';
import '../../../widgets/widgets.dart';

/// Home screen = patient's daily monitoring dashboard.
/// Mirrors the HTML mockup's Monitor screen with:
/// - Patient header with device status icons + SOS
/// - Horizontal device selector chips
/// - Alert banner (if any)
/// - Hero status card with encouraging message
/// - Current vitals 2×2 grid
/// - Live ECG card
/// - "What This Means" info box
/// - Health tips / insights
/// - Quick actions (Message Doctor, Full Report, Learn More)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Vitals? _vitals;
  List<Device> _devices = [];
  List<HealthAlert> _alerts = [];
  bool _isLoading = true;
  DeviceType _activeDevice = DeviceType.ecg;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      MockRepo.getVitals(),
      MockRepo.getDevices(),
      MockRepo.getAlerts(),
    ]);
    if (mounted) {
      setState(() {
        _vitals = results[0] as Vitals;
        _devices = results[1] as List<Device>;
        _alerts = results[2] as List<HealthAlert>;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final patient = MockRepo.patient;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            // ── Sticky Header (patient info + devices + SOS) ─
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: AppColors.surface,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 80,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('avhita', style: AppTypography.h4.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(patient.fullName, style: AppTypography.h3),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text('👤', style: TextStyle(fontSize: 11)),
                      const SizedBox(width: 3),
                      Text('${patient.age} yrs', style: AppTypography.labelSmall),
                      const SizedBox(width: 10),
                      Text('🆔', style: TextStyle(fontSize: 11)),
                      const SizedBox(width: 3),
                      Text(patient.patientId, style: AppTypography.labelSmall),
                    ],
                  ),
                ],
              ),
              actions: [
                // Connected device mini icons
                ..._buildDeviceIcons(),
                const SizedBox(width: 8),
                SosButton(onTap: () => _showSosSheet(context)),
                const SizedBox(width: 12),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    // ── Monitoring status bar ─────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const PulsingDot(size: 8),
                          const SizedBox(width: 8),
                          Text('Monitoring Active', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
                          const Spacer(),
                          Text('Synced 2 min ago', style: AppTypography.labelSmall),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Device selector chips (horizontal scroll) ─
                    SizedBox(
                      height: 46,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: DeviceType.values.map((type) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: DeviceChip(
                            type: type,
                            isActive: type == _activeDevice,
                            onTap: () => setState(() => _activeDevice = type),
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Alert banner (if any) ────────────────────────
            if (_alerts.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AlertBanner(
                    alert: _alerts.first,
                    onDismiss: () => setState(() => _alerts.clear()),
                    onContactDoctor: () {},
                  ),
                ),
              ),

            if (_alerts.isNotEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── Device-specific content ──────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _isLoading
                    ? _buildLoadingSkeleton()
                    : _buildDeviceContent(),
              ),
            ),

            // ── Quick actions (matches HTML .actions) ────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(child: QuickActionCard(
                      emoji: '👨‍⚕️', label: 'Message\nDoctor',
                      description: 'Get help anytime', isPrimary: true,
                      onTap: () {},
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: QuickActionCard(
                      emoji: '📊', label: 'Full\nReport',
                      onTap: () {},
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: QuickActionCard(
                      emoji: '📚', label: 'Learn\nMore',
                      onTap: () {},
                    )),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  /// Build device-specific content based on selected device chip
  Widget _buildDeviceContent() {
    switch (_activeDevice) {
      case DeviceType.ecg:
        return _buildEcgWorkflow();
      case DeviceType.glucose:
        return _buildGlucoseWorkflow();
      case DeviceType.bp:
        return _buildBpWorkflow();
      case DeviceType.spo2:
        return _buildSpo2Workflow();
      case DeviceType.temperature:
        return _buildTempWorkflow();
    }
  }

  /// ECG workflow (matches HTML #ecgWorkflow)
  Widget _buildEcgWorkflow() {
    return Column(
      children: [
        // Hero card
        HeroStatusCard(
          emoji: '💚',
          title: 'Heart Looking Good',
          subtitle: 'Normal rhythm detected',
          gradient: AppColors.heroHeartGradient,
          titleColor: AppColors.green,
          stats: [
            HeroStat(value: '${_vitals!.heartRate}', label: 'BPM'),
            HeroStat(value: '${_vitals!.spO2}%', label: 'O₂'),
            HeroStat(value: '7d', label: 'TRACKED'),
          ],
        ),
        const SizedBox(height: 16),

        // Current vitals 2×2 grid
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📊', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('Current Vitals', style: AppTypography.h4),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: MetricTile(
                    emoji: '❤️', label: 'Heart Rate',
                    value: '${_vitals!.heartRate}', range: '60-100 normal',
                    valueColor: AppColors.red, borderColor: AppColors.green,
                    bgColor: AppColors.greenSurface, onTap: () {},
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: MetricTile(
                    emoji: '⚡', label: 'Rhythm',
                    value: _vitals!.rhythm, range: 'Steady beat',
                    valueColor: AppColors.green, borderColor: AppColors.green,
                    bgColor: AppColors.greenSurface,
                  )),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Live ECG card
        EcgPreviewCard(onTap: () {}),
        const SizedBox(height: 10),
        const InfoBox(
          title: 'What This Means',
          text: 'Your heart is beating in a regular, healthy rhythm with strong electrical signals.',
        ),
        const SizedBox(height: 16),

        // Insights
        InsightsSection(
          emoji: '💡', title: 'Heart Health Tips',
          titleColor: const Color(0xFF92400E),
          gradient: AppColors.heroGlucoseGradient,
          borderColor: const Color(0xFFFDE68A),
          numberColor: AppColors.amber,
          insights: MockRepo.getHeartInsights(),
        ),
      ],
    );
  }

  /// Glucose workflow (matches HTML #glucoseWorkflow)
  Widget _buildGlucoseWorkflow() {
    return Column(
      children: [
        HeroStatusCard(
          emoji: '🩸', title: 'Glucose in Range',
          subtitle: 'Levels are stable',
          gradient: AppColors.heroGlucoseGradient,
          titleColor: AppColors.green,
          stats: [
            HeroStat(value: '${_vitals!.glucose ?? 105}', label: 'mg/dL'),
            HeroStat(value: '78%', label: 'IN RANGE'),
            HeroStat(value: '14d', label: 'TRACKED'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('📊', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text('Current Readings', style: AppTypography.h4),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: MetricTile(emoji: '🩸', label: 'Glucose', value: '105',
                    range: '70-130 target', valueColor: AppColors.amber, borderColor: AppColors.green, bgColor: AppColors.greenSurface)),
                const SizedBox(width: 10),
                Expanded(child: MetricTile(emoji: '📈', label: 'Trend', value: 'Stable',
                    range: 'No spikes', valueColor: AppColors.green, borderColor: AppColors.green, bgColor: AppColors.greenSurface)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: MetricTile(emoji: '⏱️', label: 'Time in Range', value: '78%',
                    range: 'Target: 70%+', valueColor: AppColors.green, borderColor: AppColors.green, bgColor: AppColors.greenSurface)),
                const SizedBox(width: 10),
                Expanded(child: MetricTile(emoji: '📉', label: 'A1C Est.', value: '6.2%',
                    range: 'Based on 14d', valueColor: AppColors.blue, borderColor: AppColors.blue)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 10),
        InfoBox(
          title: 'Pattern Detected',
          text: 'Your glucose tends to rise slightly after lunch. Consider a 10-minute walk after eating.',
          borderColor: AppColors.amber, bgColor: AppColors.amberSurface,
          titleColor: const Color(0xFF92400E), textColor: const Color(0xFF78350F),
        ),
        const SizedBox(height: 16),
        InsightsSection(
          emoji: '💡', title: 'Diabetes Tips',
          titleColor: const Color(0xFF92400E),
          gradient: AppColors.heroGlucoseGradient,
          borderColor: const Color(0xFFFDE68A),
          numberColor: AppColors.amber,
          insights: MockRepo.getGlucoseInsights(),
        ),
      ],
    );
  }

  /// BP workflow (matches HTML #bpWorkflow)
  Widget _buildBpWorkflow() {
    return Column(
      children: [
        HeroStatusCard(
          emoji: '💉', title: 'BP Normal',
          subtitle: 'Healthy blood pressure',
          gradient: AppColors.heroBpGradient,
          titleColor: AppColors.green,
          stats: [
            HeroStat(value: _vitals!.bloodPressure, label: 'mmHg'),
            HeroStat(value: '68', label: 'PULSE'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('📊', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text('Latest Reading', style: AppTypography.h4),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: MetricTile(emoji: '💉', label: 'Systolic', value: '118',
                    range: '<120 normal', valueColor: AppColors.blue, borderColor: AppColors.green, bgColor: AppColors.greenSurface)),
                const SizedBox(width: 10),
                Expanded(child: MetricTile(emoji: '💉', label: 'Diastolic', value: '76',
                    range: '<80 normal', valueColor: AppColors.blue, borderColor: AppColors.green, bgColor: AppColors.greenSurface)),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  /// SpO2 workflow
  Widget _buildSpo2Workflow() {
    return Column(
      children: [
        HeroStatusCard(
          emoji: '💧', title: 'Oxygen Excellent',
          subtitle: 'Saturation levels healthy',
          gradient: AppColors.heroSpo2Gradient,
          titleColor: AppColors.green,
          stats: [
            HeroStat(value: '${_vitals!.spO2}%', label: 'SpO₂'),
            HeroStat(value: '${_vitals!.heartRate}', label: 'PULSE'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('📊', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text('Current Readings', style: AppTypography.h4),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: MetricTile(emoji: '💧', label: 'SpO₂', value: '${_vitals!.spO2}%',
                    range: '95-100 normal', valueColor: AppColors.purple, borderColor: AppColors.green, bgColor: AppColors.greenSurface)),
                const SizedBox(width: 10),
                Expanded(child: MetricTile(emoji: '❤️', label: 'Heart Rate', value: '${_vitals!.heartRate}',
                    range: '60-100 normal', valueColor: AppColors.red, borderColor: AppColors.green, bgColor: AppColors.greenSurface)),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  /// Temperature workflow
  Widget _buildTempWorkflow() {
    return Column(
      children: [
        HeroStatusCard(
          emoji: '🌡️', title: 'Temperature Normal',
          subtitle: 'Body temp in healthy range',
          gradient: AppColors.heroHeartGradient,
          titleColor: AppColors.green,
          stats: [HeroStat(value: '${_vitals!.temperature}°F', label: 'CURRENT')],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Text('📊', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text('Current Reading', style: AppTypography.h4),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: MetricTile(emoji: '🌡️', label: 'Temperature',
                    value: '${_vitals!.temperature}°F', range: '97-99°F normal',
                    valueColor: AppColors.orange, borderColor: AppColors.green, bgColor: AppColors.greenSurface)),
                const SizedBox(width: 10),
                Expanded(child: MetricTile(emoji: '⏰', label: 'Measured',
                    value: '10 min ago', range: 'Continuous',
                    valueColor: AppColors.textPrimary, borderColor: AppColors.blue)),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDeviceIcons() {
    if (_devices.isEmpty) return [];
    return _devices.take(5).map((d) => Padding(
      padding: const EdgeInsets.only(right: 3),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 26, height: 26,
            decoration: BoxDecoration(
              color: d.isConnected ? AppColors.blueLight : AppColors.inputBg,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(d.type.emoji, style: const TextStyle(fontSize: 13)),
          ),
          Positioned(
            top: -2, right: -2,
            child: Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: d.isConnected ? AppColors.green : AppColors.textTertiary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: List.generate(3, (_) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          height: 140,
          decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(20)),
        ),
      )),
    );
  }

  void _showSosSheet(BuildContext context) {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🆘', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text('Emergency Help', style: AppTypography.h2),
            const SizedBox(height: 8),
            Text('Are you experiencing a medical emergency?', style: AppTypography.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(
              onPressed: () {}, icon: const Icon(Icons.phone), label: const Text('Call 911'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            )),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(
              onPressed: () {}, icon: const Icon(Icons.medical_services_rounded), label: const Text('Contact My Doctor'),
            )),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(
              onPressed: () {}, icon: const Icon(Icons.person_rounded), label: const Text('Call Emergency Contact'),
            )),
            const SizedBox(height: 10),
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }
}
