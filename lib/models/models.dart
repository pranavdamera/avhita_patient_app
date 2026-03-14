/// Health status matching HTML mockup's .normal / .warning / .danger classes
enum HealthStatus { normal, warning, danger }

extension HealthStatusExt on HealthStatus {
  String get label {
    switch (this) {
      case HealthStatus.normal: return 'Normal';
      case HealthStatus.warning: return 'Warning';
      case HealthStatus.danger: return 'Critical';
    }
  }
  String get friendlyLabel {
    switch (this) {
      case HealthStatus.normal: return 'Looking Good';
      case HealthStatus.warning: return 'Needs Attention';
      case HealthStatus.danger: return 'Alert';
    }
  }
}

/// Device types from HTML mockup's device selector chips
enum DeviceType { ecg, glucose, bp, spo2, temperature }

extension DeviceTypeExt on DeviceType {
  String get label {
    switch (this) {
      case DeviceType.ecg: return 'Heart';
      case DeviceType.glucose: return 'Glucose';
      case DeviceType.bp: return 'Blood Pressure';
      case DeviceType.spo2: return 'Oxygen';
      case DeviceType.temperature: return 'Temperature';
    }
  }
  String get emoji {
    switch (this) {
      case DeviceType.ecg: return '❤️';
      case DeviceType.glucose: return '🩸';
      case DeviceType.bp: return '💉';
      case DeviceType.spo2: return '💧';
      case DeviceType.temperature: return '🌡️';
    }
  }
  String get modelName {
    switch (this) {
      case DeviceType.ecg: return 'CardioTrack Pro';
      case DeviceType.glucose: return 'GlucoSense G7';
      case DeviceType.bp: return 'BP Smart Cuff';
      case DeviceType.spo2: return 'PulseOx Mini';
      case DeviceType.temperature: return 'TempSense';
    }
  }
}

/// Connected device model (matches HTML mockup's device cards in settings)
class Device {
  final DeviceType type;
  final String name;
  final String model;
  final bool isConnected;
  final int? batteryLevel;
  final DateTime? lastSync;

  Device({
    required this.type,
    required this.name,
    required this.model,
    required this.isConnected,
    this.batteryLevel,
    this.lastSync,
  });
}

/// Patient profile model
class PatientProfile {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String email;
  final String phone;
  final String? healthConditions;
  final String? primaryDoctorContact;
  final String? iceContact;
  final String? iceName;
  final String patientId; // e.g. PT-2024-1847

  PatientProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.email,
    required this.phone,
    this.healthConditions,
    this.primaryDoctorContact,
    this.iceContact,
    this.iceName,
    required this.patientId,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
  int get age => DateTime.now().year - dob.year;
}

/// Current vitals snapshot (matches HTML mockup's hero stats + metrics grid)
class Vitals {
  final int heartRate;
  final String bloodPressure;
  final int spO2;
  final double temperature;
  final String rhythm;
  final int? glucose;
  final HealthStatus heartStatus;
  final HealthStatus bpStatus;
  final HealthStatus spo2Status;
  final HealthStatus tempStatus;
  final HealthStatus? glucoseStatus;
  final DateTime timestamp;

  Vitals({
    required this.heartRate,
    required this.bloodPressure,
    required this.spO2,
    required this.temperature,
    this.rhythm = 'Regular',
    this.glucose,
    this.heartStatus = HealthStatus.normal,
    this.bpStatus = HealthStatus.normal,
    this.spo2Status = HealthStatus.normal,
    this.tempStatus = HealthStatus.normal,
    this.glucoseStatus,
    required this.timestamp,
  });
}

/// Doctor model
class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String phone;
  final String? avatarUrl;
  final DateTime? lastReview;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.phone,
    this.avatarUrl,
    this.lastReview,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }
}

/// Patient report
class PatientReport {
  final String id;
  final String title;
  final String doctorName;
  final DateTime date;
  final String type; // e.g. "ECG Report", "Weekly Summary"
  final HealthStatus status;
  final String? summary;

  PatientReport({
    required this.id,
    required this.title,
    required this.doctorName,
    required this.date,
    required this.type,
    required this.status,
    this.summary,
  });
}

/// Health alert
class HealthAlert {
  final String id;
  final String title;
  final String message;
  final HealthStatus severity;
  final DateTime timestamp;
  final bool isDismissed;

  HealthAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.isDismissed = false,
  });
}

/// Trend data point for charts
class TrendPoint {
  final DateTime time;
  final double value;
  TrendPoint({required this.time, required this.value});
}

/// Health insight / tip (matches HTML mockup's .insight items)
class HealthInsight {
  final int number;
  final String title;
  final String text;
  HealthInsight({required this.number, required this.title, required this.text});
}
