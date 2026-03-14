import '../models/models.dart';

/// Mock data matching the HTML mockup's patient (Sarah Johnson, PT-2024-1847)
/// and multi-device monitoring setup.
class MockRepo {
  static const _delay = Duration(milliseconds: 500);

  // ── Patient Profile ────────────────────────────────────────
  static final PatientProfile patient = PatientProfile(
    id: '1',
    firstName: 'Sarah',
    lastName: 'Johnson',
    dob: DateTime(1979, 6, 15),
    email: 'sarah.johnson@email.com',
    phone: '+1 (555) 234-5678',
    healthConditions: 'Hypertension, Type 2 Diabetes',
    primaryDoctorContact: '+1 (555) 100-2000',
    iceContact: '+1 (555) 987-6543',
    iceName: 'Michael Johnson (Spouse)',
    patientId: 'PT-2024-1847',
  );

  // ── Doctor ─────────────────────────────────────────────────
  static final Doctor doctor = Doctor(
    id: 'd1',
    name: 'Dr. James Wilson',
    specialty: 'Cardiology',
    hospital: 'Metro Heart Center',
    phone: '+1 (555) 100-2000',
    lastReview: DateTime.now().subtract(const Duration(hours: 6)),
  );

  // ── Current Vitals (matching HTML hero card values) ────────
  static Future<Vitals> getVitals() async {
    await Future.delayed(_delay);
    return Vitals(
      heartRate: 72,
      bloodPressure: '118/76',
      spO2: 98,
      temperature: 98.4,
      rhythm: 'Regular',
      glucose: 105,
      heartStatus: HealthStatus.normal,
      bpStatus: HealthStatus.normal,
      spo2Status: HealthStatus.normal,
      tempStatus: HealthStatus.normal,
      glucoseStatus: HealthStatus.normal,
      timestamp: DateTime.now(),
    );
  }

  // ── Connected Devices (matching HTML settings) ─────────────
  static Future<List<Device>> getDevices() async {
    await Future.delayed(_delay);
    return [
      Device(
        type: DeviceType.ecg,
        name: 'ECG Monitor',
        model: 'CardioTrack Pro',
        isConnected: true,
        batteryLevel: 87,
        lastSync: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      Device(
        type: DeviceType.glucose,
        name: 'Continuous Glucose Monitor',
        model: 'GlucoSense G7',
        isConnected: true,
        batteryLevel: 62,
        lastSync: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Device(
        type: DeviceType.bp,
        name: 'Blood Pressure Monitor',
        model: 'BP Smart Cuff',
        isConnected: true,
        batteryLevel: 91,
        lastSync: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      Device(
        type: DeviceType.spo2,
        name: 'Pulse Oximeter',
        model: 'PulseOx Mini',
        isConnected: false,
        batteryLevel: null,
        lastSync: null,
      ),
      Device(
        type: DeviceType.temperature,
        name: 'Smart Thermometer',
        model: 'TempSense',
        isConnected: false,
        batteryLevel: null,
        lastSync: null,
      ),
    ];
  }

  // ── Heart Rate Trend (7 days) ──────────────────────────────
  static Future<List<TrendPoint>> getHeartTrend() async {
    await Future.delayed(_delay);
    final now = DateTime.now();
    return [
      TrendPoint(time: now.subtract(const Duration(days: 6)), value: 74),
      TrendPoint(time: now.subtract(const Duration(days: 5)), value: 71),
      TrendPoint(time: now.subtract(const Duration(days: 4)), value: 78),
      TrendPoint(time: now.subtract(const Duration(days: 3)), value: 69),
      TrendPoint(time: now.subtract(const Duration(days: 2)), value: 73),
      TrendPoint(time: now.subtract(const Duration(days: 1)), value: 76),
      TrendPoint(time: now, value: 72),
    ];
  }

  static Future<List<TrendPoint>> getBpTrend() async {
    await Future.delayed(_delay);
    final now = DateTime.now();
    return [
      TrendPoint(time: now.subtract(const Duration(days: 6)), value: 122),
      TrendPoint(time: now.subtract(const Duration(days: 5)), value: 119),
      TrendPoint(time: now.subtract(const Duration(days: 4)), value: 125),
      TrendPoint(time: now.subtract(const Duration(days: 3)), value: 116),
      TrendPoint(time: now.subtract(const Duration(days: 2)), value: 120),
      TrendPoint(time: now.subtract(const Duration(days: 1)), value: 118),
      TrendPoint(time: now, value: 118),
    ];
  }

  // ── Reports ────────────────────────────────────────────────
  static Future<List<PatientReport>> getReports() async {
    await Future.delayed(_delay);
    return [
      PatientReport(
        id: 'r1',
        title: 'Weekly ECG Summary',
        doctorName: 'Dr. James Wilson',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: 'ECG Report',
        status: HealthStatus.normal,
        summary: 'Normal sinus rhythm throughout the week. No arrhythmias detected.',
      ),
      PatientReport(
        id: 'r2',
        title: 'Monthly Health Overview',
        doctorName: 'Dr. James Wilson',
        date: DateTime.now().subtract(const Duration(days: 7)),
        type: 'Monthly Report',
        status: HealthStatus.normal,
        summary: 'All vitals within normal range. BP trending down. Continue current medication.',
      ),
      PatientReport(
        id: 'r3',
        title: 'Glucose Management Report',
        doctorName: 'Dr. Priya Sharma',
        date: DateTime.now().subtract(const Duration(days: 14)),
        type: 'Diabetes Report',
        status: HealthStatus.warning,
        summary: 'Time in range 78%. Post-lunch spikes noted. Dietary adjustments recommended.',
      ),
      PatientReport(
        id: 'r4',
        title: 'Cardiology Consultation Notes',
        doctorName: 'Dr. James Wilson',
        date: DateTime.now().subtract(const Duration(days: 21)),
        type: 'Consultation',
        status: HealthStatus.normal,
        summary: 'ECG patch data reviewed. Heart function stable. Next review in 30 days.',
      ),
    ];
  }

  // ── Alerts ─────────────────────────────────────────────────
  static Future<List<HealthAlert>> getAlerts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      HealthAlert(
        id: 'a1',
        title: 'Heart Rate Elevated',
        message: 'Your heart rate reached 105 bpm during rest. This may need attention. Consider relaxing and monitoring.',
        severity: HealthStatus.warning,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  // ── Health Insights (matching HTML mockup's tip sections) ──
  static List<HealthInsight> getHeartInsights() => [
        HealthInsight(
          number: 1,
          title: 'Best time for exercise',
          text: 'Your heart rate is lowest 6-9 AM. Perfect for morning workouts.',
        ),
        HealthInsight(
          number: 2,
          title: 'Great consistency',
          text: 'Your resting heart rate has been stable all week. Keep it up!',
        ),
      ];

  static List<HealthInsight> getGlucoseInsights() => [
        HealthInsight(
          number: 1,
          title: 'Post-meal activity',
          text: 'A 10-15 minute walk after meals helps stabilize glucose levels.',
        ),
        HealthInsight(
          number: 2,
          title: 'Morning readings improving',
          text: 'Fasting glucose down 8 mg/dL this week. Great progress!',
        ),
      ];

  /// Generate mock ECG waveform data
  static List<double> generateEcgData({int points = 200}) {
    final List<double> data = [];
    for (int i = 0; i < points; i++) {
      final pos = (i % 25);
      if (pos == 8) {
        data.add(0.15);
      } else if (pos == 10) {
        data.add(-0.1);
      } else if (pos == 11) {
        data.add(0.9);
      } else if (pos == 12) {
        data.add(-0.2);
      } else if (pos == 15) {
        data.add(0.2);
      } else if (pos == 16) {
        data.add(0.1);
      } else {
        data.add(0.0);
      }
    }
    return data;
  }
}
