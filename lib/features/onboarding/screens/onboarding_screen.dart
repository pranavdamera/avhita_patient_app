import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../widgets/widgets.dart';
import '../../../theme/theme.dart';
import '../../../navigation/app_shell.dart';

/// Multi-step onboarding: Personal Info → Health Info → Device Pairing
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  // Step 1 fields
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  DateTime? _dob;

  // Step 2 fields
  final _conditions = TextEditingController();
  final _doctorContact = TextEditingController();
  final _iceContact = TextEditingController();
  final _iceName = TextEditingController();

  // Step 3 - pairing state
  bool _isPairing = false;
  bool _isPaired = false;

  void _nextStep() {
    if (_currentStep == 0 && !_formKey1.currentState!.validate()) return;
    if (_currentStep == 1 && !_formKey2.currentState!.validate()) return;
    if (_currentStep < 2) {
      HapticFeedback.lightImpact();
      setState(() => _currentStep++);
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _simulatePairing() async {
    HapticFeedback.mediumImpact();
    setState(() => _isPairing = true);
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      HapticFeedback.heavyImpact();
      setState(() { _isPairing = false; _isPaired = true; });
    }
  }

  void _complete() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AppShell()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _firstName.dispose(); _lastName.dispose();
    _email.dispose(); _phone.dispose();
    _conditions.dispose(); _doctorContact.dispose();
    _iceContact.dispose(); _iceName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress header ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('avhita', style: AppTypography.h2.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(3, (i) => Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                        decoration: BoxDecoration(
                          color: i <= _currentStep ? AppColors.primary : AppColors.inputBg,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ['Personal Information', 'Health & Emergency', 'Device Pairing'][_currentStep],
                    style: AppTypography.label,
                  ),
                ],
              ),
            ),

            // ── Page content ─────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildStep1(), _buildStep2(), _buildStep3()],
              ),
            ),

            // ── Bottom buttons ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: _prevStep,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _currentStep == 2
                          ? (_isPaired ? _complete : null)
                          : _nextStep,
                      child: Text(_currentStep == 2 ? 'Get Started' : 'Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Step 1: Personal Info ──────────────────────────────────
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Let\'s get to know you', style: AppTypography.h1),
            const SizedBox(height: 4),
            Text('We need a few details to set up your health profile.',
                style: AppTypography.bodySmall),
            const SizedBox(height: 24),
            _FieldLabel(label: 'First Name'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _firstName,
              decoration: AppDecorations.input(hint: 'Enter first name', prefix: const Icon(Icons.person_outline)),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            _FieldLabel(label: 'Last Name'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _lastName,
              decoration: AppDecorations.input(hint: 'Enter last name'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            _FieldLabel(label: 'Date of Birth'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1980),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: AppColors.primary),
                    ),
                    child: child!,
                  ),
                );
                if (date != null) setState(() => _dob = date);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(AppDecorations.inputRadius),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 20, color: AppColors.textTertiary),
                    const SizedBox(width: 12),
                    Text(
                      _dob != null
                          ? '${_dob!.month}/${_dob!.day}/${_dob!.year}'
                          : 'Select date of birth',
                      style: AppTypography.body.copyWith(
                        color: _dob != null ? AppColors.textPrimary : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _FieldLabel(label: 'Email'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _email,
              decoration: AppDecorations.input(hint: 'you@email.com', prefix: const Icon(Icons.email_outlined)),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null,
            ),
            const SizedBox(height: 16),
            _FieldLabel(label: 'Phone Number'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _phone,
              decoration: AppDecorations.input(hint: '+1 (555) 000-0000', prefix: const Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Step 2: Health & Emergency ─────────────────────────────
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Health & Emergency', style: AppTypography.h1),
            const SizedBox(height: 4),
            Text('This helps us personalize your monitoring experience.',
                style: AppTypography.bodySmall),
            const SizedBox(height: 24),
            _FieldLabel(label: 'Previous Health Conditions'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _conditions,
              decoration: AppDecorations.input(
                  hint: 'e.g., Hypertension, Diabetes Type 2...',
                  prefix: const Icon(Icons.medical_services_outlined)),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            _FieldLabel(label: 'Primary Doctor Contact'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _doctorContact,
              decoration: AppDecorations.input(
                  hint: 'Phone or email', prefix: const Icon(Icons.local_hospital_outlined)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.redSurface, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.redLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🆘', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text('Emergency Contact', style: AppTypography.h4.copyWith(color: AppColors.red)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _FieldLabel(label: 'Contact Name & Relation'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _iceName,
                    decoration: AppDecorations.input(hint: 'e.g., Michael Johnson (Spouse)'),
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  _FieldLabel(label: 'Contact Phone'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _iceContact,
                    decoration: AppDecorations.input(hint: '+1 (555) 000-0000'),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Step 3: Device Pairing ─────────────────────────────────
  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _isPaired
                ? _buildPairedState()
                : _isPairing
                    ? _buildPairingState()
                    : _buildReadyState(),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildReadyState() {
    return Column(
      key: const ValueKey('ready'),
      children: [
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(
            color: AppColors.blueLight, shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.bluetooth_rounded, size: 56, color: AppColors.blue),
        ),
        const SizedBox(height: 24),
        Text('Connect Your Device', style: AppTypography.h2, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Make sure your ECG patch or sensor is nearby and powered on.',
            style: AppTypography.bodySmall, textAlign: TextAlign.center),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _simulatePairing,
            icon: const Icon(Icons.bluetooth_searching_rounded),
            label: const Text('Scan for Devices'),
          ),
        ),
      ],
    );
  }

  Widget _buildPairingState() {
    return Column(
      key: const ValueKey('pairing'),
      children: [
        SizedBox(
          width: 120, height: 120,
          child: CircularProgressIndicator(
            strokeWidth: 4, color: AppColors.primary,
            backgroundColor: AppColors.primarySurface,
          ),
        ),
        const SizedBox(height: 24),
        Text('Searching for devices...', style: AppTypography.h3),
        const SizedBox(height: 8),
        Text('This may take a moment.', style: AppTypography.bodySmall),
      ],
    );
  }

  Widget _buildPairedState() {
    return Column(
      key: const ValueKey('paired'),
      children: [
        Container(
          width: 120, height: 120,
          decoration: BoxDecoration(
            color: AppColors.greenLight, shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.check_circle_rounded, size: 64, color: AppColors.green),
        ),
        const SizedBox(height: 24),
        Text('Device Connected!', style: AppTypography.h2.copyWith(color: AppColors.green)),
        const SizedBox(height: 8),
        Text('CardioTrack Pro is ready to monitor your heart.',
            style: AppTypography.bodySmall, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppDecorations.card(),
          child: Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: AppColors.blueLight, borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text('❤️', style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ECG Monitor', style: AppTypography.h4),
                  Row(
                    children: [
                      PulsingDot(size: 6),
                      const SizedBox(width: 6),
                      Text('Connected · CardioTrack Pro', style: AppTypography.bodySmall),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTypography.label.copyWith(fontWeight: FontWeight.w600));
  }
}
