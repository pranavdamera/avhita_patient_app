# Avhita Patient App — Remote Health Monitoring

## Overview

Patient-facing Flutter mobile app for the Avhita RPM (Remote Patient Monitoring) platform. Designed to mirror the clinician dashboard's visual DNA while providing a calmer, simpler, more reassuring experience for patients wearing ECG patches and health sensors.

**Built from two reference sources:**
1. The Avhita clinician web dashboard (teal brand, severity system, medical SaaS aesthetic)
2. Your dad's HTML mockup (`Health_Monitor.html`) — multi-device health monitor with hero cards, device selector chips, "What This Means" info boxes, insights/tips, and SOS button

## Architecture

```
lib/
├── main.dart                              # App entry → Onboarding
├── models/models.dart                     # Patient, Vitals, Device, Doctor, Report, Alert, TrendPoint, HealthInsight
├── repositories/mock_repository.dart      # Mock data (Sarah Johnson, PT-2024-1847)
├── theme/
│   ├── colors.dart                        # HTML mockup CSS vars → Flutter (--green, --blue, --red, --amber)
│   ├── typography.dart                    # Inter font, patient-friendly larger sizing
│   ├── spacing.dart                       # 20px card radius, left-border metrics, hero gradients
│   ├── app_theme.dart                     # Material 3 ThemeData
│   └── theme.dart                         # Barrel export
├── widgets/widgets.dart                   # All reusable components (see below)
├── navigation/app_shell.dart              # Bottom nav: Home, Health, Reports, Doctor, Profile
└── features/
    ├── onboarding/screens/                # 3-step: Personal → Health/Emergency → Device Pairing
    ├── home/screens/                      # Multi-device monitor (matches HTML Monitor screen)
    ├── health/screens/                    # Trend charts, weekly summary, activity
    ├── reports/screens/                   # Patient-viewable reports from care team
    ├── doctor/screens/                    # Communication hub: call, video, message, schedule
    └── profile/screens/                   # Patient info, device management, preferences, ICE
```

## Design System Mapping: HTML Mockup → Flutter

| HTML Mockup Element         | Flutter Widget              | Notes |
|-----------------------------|----------------------------|-------|
| `.hero` with gradient bg    | `HeroStatusCard`           | Same gradient colors, emoji, stats layout |
| `.metric` with left border  | `MetricTile`               | Colored left border, value + range |
| `.ecg-box` animated wave    | `EcgPreviewCard`           | CustomPainter PQRST waveform, blue theme |
| `.info-box` with left bar   | `InfoBox`                  | "What This Means" pattern |
| `.insights` section         | `InsightsSection`          | Numbered tips, amber gradient bg |
| `.alert` banner             | `AlertBanner`              | Red gradient, left border, CTA buttons |
| `.device-chip` selector     | `DeviceChip`               | Horizontal scroll, emoji + label |
| `.device-card` in settings  | `_DeviceCard` (Profile)    | Toggle switch, battery, sync, configure |
| `.help-btn` (🆘)           | `SosButton`                | Red circle, heavy haptic, bottom sheet |
| `.status-dot` pulsing       | `PulsingDot`               | Animated opacity matching CSS @keyframes pulse |
| `.action` cards             | `QuickActionCard`          | Message Doctor, Full Report, Learn More |
| `.nav` bottom nav           | `AppShell` BottomNav       | Monitor→Home, Trends→Health, Messages→Doctor, Settings→Profile |
| `.toggle` on/off switch     | Custom `AnimatedContainer`  | Profile device cards, matching CSS toggle |
| `.badge` (Strong Signal)    | Container + badge style    | Blue bg pill |
| `.device-icon-mini` header  | `_buildDeviceIcons()`      | Tiny emoji squares with green/gray dots |

## Color System

```dart
// Direct from HTML mockup :root CSS variables
--green:  #10b981 → AppColors.green
--blue:   #3b82f6 → AppColors.blue
--red:    #ef4444 → AppColors.red
--amber:  #f59e0b → AppColors.amber
--purple: #8b5cf6 → AppColors.purple

// Hero card gradients (exact CSS gradient values)
heroHeartGradient:    #ecfdf5 → #d1fae5
heroGlucoseGradient:  #fef3c7 → #fde68a
heroBpGradient:       #dbeafe → #bfdbfe
heroSpo2Gradient:     #e0e7ff → #c7d2fe

// Shared with clinician dashboard
primary: #0D9488 (Avhita teal)
```

## Screens

### 1. Onboarding (3 steps)
- **Personal Info**: Name, DOB (date picker), email, phone
- **Health & Emergency**: Health conditions, doctor contact, ICE contact (in red-tinted card)
- **Device Pairing**: Bluetooth scan simulation → connection confirmation
- Progress bar, validation, large friendly fields

### 2. Home (Monitor)
- Sticky header: patient name, age, ID, mini device status icons, SOS button
- "Monitoring Active" status bar with pulsing green dot
- **Device selector chips** (horizontal scroll): Heart, Glucose, Blood Pressure, Oxygen, Temperature
- Each device shows its own workflow:
  - **Heart**: Hero card ("Heart Looking Good") + vitals grid + live ECG + info box + health tips
  - **Glucose**: Hero card ("Glucose in Range") + 4-metric grid + pattern detection + diabetes tips
  - **BP**: Hero card ("BP Normal") + systolic/diastolic metrics
  - **SpO₂**: Hero card ("Oxygen Excellent") + SpO₂/HR metrics
  - **Temperature**: Hero card ("Temperature Normal") + temp/measured metrics
- Quick action row: Message Doctor (primary), Full Report, Learn More
- SOS bottom sheet: Call 911, Contact Doctor, Call Emergency Contact

### 3. Health
- Weekly summary hero card with avg HR/BP/SpO₂ pills
- 7-day heart rate trend (line chart with fl_chart)
- 7-day blood pressure trend
- Insight info boxes below each chart
- Activity summary: Steps, Calories, Sleep

### 4. Reports
- Report cards with: title, doctor name, date, type badge, status chip, summary
- Actions per report: View ECG, Download PDF, Share

### 5. Doctor
- Doctor profile hero card with avatar, specialty, hospital
- Communication buttons: Call, Video, Message (colored teal cards)
- Schedule Checkup action
- Consultation notes display
- "Preparing for Your Visit" info box

### 6. Profile
- Patient profile card with edit button
- **Device management** (matching HTML settings exactly):
  - Device cards with emoji icons, connection status, toggle switches
  - Battery level, last sync time
  - Configure/Calibrate buttons for connected devices
  - "Connect Device" button for disconnected ones
- Scan for Devices / Manual Setup actions
- Emergency contact card (red-tinted)
- Preferences: Notifications, Data Sync, Appearance, Help, About
- Sign Out button

## Reusable Widgets (10)

| Widget | Purpose |
|--------|---------|
| `AnimatedPressCard` | Scale 0.97 + haptic on tap |
| `PulsingDot` | Animated status indicator |
| `HeroStatusCard` | Gradient hero with emoji + stats |
| `MetricTile` | Left-bordered vital reading |
| `EcgPreviewCard` | Animated ECG waveform |
| `InfoBox` | "What This Means" explanations |
| `InsightsSection` | Numbered health tips |
| `AlertBanner` | Alert with CTA buttons |
| `DeviceChip` | Device type selector |
| `SosButton` | Emergency help trigger |

## Running

```bash
cd avhita_patient
flutter pub get
flutter run
```

## Mock Data

Patient: Sarah Johnson, 45 yrs, PT-2024-1847 (matching HTML mockup)
Doctor: Dr. James Wilson, Cardiology, Metro Heart Center
Vitals: HR 72, BP 118/76, SpO₂ 98%, Temp 98.4°F, Glucose 105 mg/dL
Devices: 5 (ECG, CGM, BP, SpO₂, Thermometer — 3 connected, 2 disconnected)

## Dependencies

- `google_fonts` — Inter font family
- `fl_chart` — Trend line charts
- `flutter_animate` — Declarative animations
- `shimmer` — Loading skeletons
- `provider` — State management
- `smooth_page_indicator` — Onboarding dots
- `percent_indicator` — Progress rings
