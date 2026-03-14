import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/theme.dart';
import '../../../repositories/mock_repository.dart';
import '../../../widgets/widgets.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doc = MockRepo.doctor;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true, snap: true,
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
            title: Text('My Doctor', style: AppTypography.h2),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ── Doctor info card ────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: AppDecorations.heroCard([AppColors.primarySurface, AppColors.primaryMuted]),
                    child: Column(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 16)],
                          ),
                          alignment: Alignment.center,
                          child: Text(doc.initials, style: AppTypography.h2.copyWith(color: Colors.white)),
                        ),
                        const SizedBox(height: 14),
                        Text(doc.name, style: AppTypography.h2),
                        const SizedBox(height: 4),
                        Text(doc.specialty, style: AppTypography.body.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text(doc.hospital, style: AppTypography.bodySmall),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const PulsingDot(size: 6, color: AppColors.green),
                            const SizedBox(width: 6),
                            Text('Last reviewed 6 hours ago', style: AppTypography.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Communication actions ──────────────────
                  Text('Reach Out', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _CommButton(
                        icon: Icons.phone_rounded, label: 'Call',
                        color: AppColors.primary, onTap: () => HapticFeedback.mediumImpact(),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _CommButton(
                        icon: Icons.videocam_rounded, label: 'Video',
                        color: AppColors.primaryDark, onTap: () => HapticFeedback.mediumImpact(),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _CommButton(
                        icon: Icons.chat_rounded, label: 'Message',
                        color: AppColors.primaryLight, onTap: () => HapticFeedback.mediumImpact(),
                      )),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Schedule checkup ───────────────────────
                  AnimatedPressCard(
                    onTap: () {},
                    decoration: AppDecorations.card(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48, height: 48,
                            decoration: BoxDecoration(color: AppColors.amberLight, borderRadius: BorderRadius.circular(12)),
                            alignment: Alignment.center,
                            child: const Icon(Icons.calendar_month_rounded, color: AppColors.amber, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Schedule Checkup', style: AppTypography.h4),
                              Text('Book your next appointment', style: AppTypography.bodySmall),
                            ],
                          )),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Consultation notes placeholder ─────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: AppDecorations.card(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Consultation Notes', style: AppTypography.h4),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            'ECG patch data reviewed. Heart function stable. Blood pressure well-controlled on current medication. Next review in 30 days.',
                            style: AppTypography.body.copyWith(color: AppColors.textSecondary, height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.textTertiary),
                            const SizedBox(width: 4),
                            Text('Last consultation: 3 weeks ago', style: AppTypography.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── What to share info box ─────────────────
                  const InfoBox(
                    title: 'Preparing for Your Visit',
                    text: 'Your doctor can see your vital trends, ECG readings, and glucose data automatically. No need to bring printouts!',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommButton extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _CommButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedPressCard(
      onTap: onTap,
      decoration: BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.white),
            const SizedBox(height: 8),
            Text(label, style: AppTypography.label.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
