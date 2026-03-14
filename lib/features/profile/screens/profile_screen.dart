import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/theme.dart';
import '../../../models/models.dart';
import '../../../repositories/mock_repository.dart';
import '../../../widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Device> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final d = await MockRepo.getDevices();
    if (mounted) setState(() { _devices = d; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final p = MockRepo.patient;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true, snap: true,
            backgroundColor: AppColors.surface,
            surfaceTintColor: Colors.transparent,
            title: Text('Profile', style: AppTypography.h2),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Patient profile card ────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: AppDecorations.card(),
                    child: Column(
                      children: [
                        Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.primary, shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12)],
                          ),
                          alignment: Alignment.center,
                          child: Text(p.initials, style: AppTypography.h2.copyWith(color: Colors.white)),
                        ),
                        const SizedBox(height: 14),
                        Text(p.fullName, style: AppTypography.h2),
                        const SizedBox(height: 4),
                        Text(p.patientId, style: AppTypography.bodySmall),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        _InfoRow(icon: Icons.cake_outlined, label: 'Date of Birth',
                            value: '${_monthName(p.dob.month)} ${p.dob.day}, ${p.dob.year} (${p.age} yrs)'),
                        const SizedBox(height: 10),
                        _InfoRow(icon: Icons.email_outlined, label: 'Email', value: p.email),
                        const SizedBox(height: 10),
                        _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: p.phone),
                        if (p.healthConditions != null && p.healthConditions!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _InfoRow(icon: Icons.medical_services_outlined, label: 'Health Conditions',
                              value: p.healthConditions!),
                        ],
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── My Devices (matches HTML settings .device-card) ─
                  _SectionTitle(label: 'My Devices'),
                  const SizedBox(height: 12),
                  if (_isLoading)
                    ..._deviceSkeletons()
                  else
                    ..._devices.map((d) => _DeviceCard(device: d)),

                  // ── Add new device ─────────────────────────
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _ActionTile(
                        emoji: '🔍', label: 'Scan for Devices',
                        onTap: () => HapticFeedback.lightImpact(),
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: _ActionTile(
                        emoji: '➕', label: 'Manual Setup',
                        onTap: () => HapticFeedback.lightImpact(),
                      )),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Emergency Contact ──────────────────────
                  _SectionTitle(label: 'Emergency Contact'),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.redSurface,
                      borderRadius: BorderRadius.circular(AppDecorations.cardRadius),
                      border: Border.all(color: AppColors.redLight),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.redLight, borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text('🆘', style: TextStyle(fontSize: 22)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.iceName ?? 'Not set', style: AppTypography.h4),
                            Text(p.iceContact ?? 'Add emergency contact', style: AppTypography.bodySmall),
                          ],
                        )),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Preferences (matches HTML preferences section) ─
                  _SectionTitle(label: 'Preferences'),
                  const SizedBox(height: 12),
                  _PreferenceTile(
                    emoji: '🔔', label: 'Notifications',
                    subtitle: 'Alerts for critical readings',
                    trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  _PreferenceTile(
                    emoji: '📱', label: 'Data Sync',
                    subtitle: 'Auto-sync to cloud every hour',
                    trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  _PreferenceTile(
                    emoji: '🎨', label: 'Appearance',
                    subtitle: 'Light mode',
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 8),
                  _PreferenceTile(
                    emoji: '❓', label: 'Help & Support',
                    subtitle: 'FAQ, contact support',
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 8),
                  _PreferenceTile(
                    emoji: 'ℹ️', label: 'About Avhita',
                    subtitle: 'Version 1.0.0',
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 24),

                  // ── Logout ─────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => HapticFeedback.mediumImpact(),
                      icon: const Icon(Icons.logout_rounded, color: AppColors.red),
                      label: Text('Sign Out', style: AppTypography.h4.copyWith(color: AppColors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
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

  List<Widget> _deviceSkeletons() => List.generate(3, (_) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(height: 90, decoration: BoxDecoration(color: AppColors.inputBg, borderRadius: BorderRadius.circular(16))),
  ));

  String _monthName(int m) => const ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];
}

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle({required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 20, decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Text(label, style: AppTypography.h4),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textTertiary),
        const SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.labelSmall),
            const SizedBox(height: 2),
            Text(value, style: AppTypography.body),
          ],
        )),
      ],
    );
  }
}

/// Device card matching HTML settings .device-card
class _DeviceCard extends StatefulWidget {
  final Device device;
  const _DeviceCard({required this.device});
  @override
  State<_DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<_DeviceCard> {
  late bool _isOn;

  @override
  void initState() {
    super.initState();
    _isOn = widget.device.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.device;
    final gradient = _deviceGradient(d.type);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: AppDecorations.card(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(d.type.emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(d.name, style: AppTypography.h4),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          color: d.isConnected ? AppColors.green : AppColors.textTertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(child: Text(
                        d.isConnected ? 'Connected · Model: ${d.model}' : 'Not Connected',
                        style: AppTypography.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                ],
              )),
              // Toggle matching HTML .toggle
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _isOn = !_isOn);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52, height: 32,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _isOn ? AppColors.primary : AppColors.inputBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: _isOn ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 2))],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (d.isConnected) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (d.batteryLevel != null) ...[
                  Icon(
                    d.batteryLevel! > 50 ? Icons.battery_std_rounded : Icons.battery_2_bar_rounded,
                    size: 14, color: d.batteryLevel! > 20 ? AppColors.green : AppColors.red,
                  ),
                  const SizedBox(width: 4),
                  Text('${d.batteryLevel}%', style: AppTypography.labelSmall),
                  const SizedBox(width: 16),
                ],
                const Icon(Icons.sync_rounded, size: 14, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text('Synced ${_syncAgo(d.lastSync)}', style: AppTypography.labelSmall),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                  child: const Text('Configure'),
                )),
                const SizedBox(width: 10),
                Expanded(child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                  child: Text(d.type == DeviceType.ecg ? 'Calibrate' : 'Set Alerts'),
                )),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                child: const Text('Connect Device'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _syncAgo(DateTime? t) {
    if (t == null) return 'never';
    final m = DateTime.now().difference(t).inMinutes;
    if (m < 1) return 'just now';
    if (m < 60) return '${m}m ago';
    return '${m ~/ 60}h ago';
  }

  List<Color> _deviceGradient(DeviceType t) {
    switch (t) {
      case DeviceType.ecg: return [const Color(0xFFDBEAFE), const Color(0xFFBFDBFE)];
      case DeviceType.glucose: return [const Color(0xFFFEF3C7), const Color(0xFFFDE68A)];
      case DeviceType.bp: return [const Color(0xFFDBEAFE), const Color(0xFFBFDBFE)];
      case DeviceType.spo2: return [const Color(0xFFE0E7FF), const Color(0xFFC7D2FE)];
      case DeviceType.temperature: return [const Color(0xFFFED7AA), const Color(0xFFFDBA74)];
    }
  }
}

class _ActionTile extends StatelessWidget {
  final String emoji; final String label; final VoidCallback onTap;
  const _ActionTile({required this.emoji, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return AnimatedPressCard(
      onTap: onTap,
      decoration: AppDecorations.card(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(label, style: AppTypography.label.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  final String emoji; final String label; final String subtitle; final Widget trailing;
  const _PreferenceTile({required this.emoji, required this.label, required this.subtitle, required this.trailing});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: AppDecorations.card(),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.h4.copyWith(fontSize: 14)),
              Text(subtitle, style: AppTypography.labelSmall),
            ],
          )),
          trailing,
        ],
      ),
    );
  }
}
