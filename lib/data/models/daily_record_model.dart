import '../../domain/entities/daily_record.dart';

class DailyRecordModel extends DailyRecord {
  const DailyRecordModel({
    required super.id,
    required super.agentId,
    required super.zoneId,
    required super.streetId,
    required super.propertyIdentifier,
    required super.date,
    required super.status,
    required super.activityType,
    required super.fociFound,
    required super.treatmentApplied,
    required super.observations,
  });

  factory DailyRecordModel.fromMap(Map<String, dynamic> map) {
    return DailyRecordModel(
      id: map['id'] as String,
      agentId: map['agentId'] as String,
      zoneId: map['zoneId'] as String,
      streetId: map['streetId'] as String,
      propertyIdentifier: map['propertyIdentifier'] as String,
      date: DateTime.parse(map['date'] as String),
      status: map['status'] as String,
      activityType: map['activityType'] as String,
      fociFound: map['fociFound'] as int,
      treatmentApplied: (map['treatmentApplied'] as int) == 1,
      observations: map['observations'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agentId': agentId,
      'zoneId': zoneId,
      'streetId': streetId,
      'propertyIdentifier': propertyIdentifier,
      'date': date.toIso8601String(),
      'status': status,
      'activityType': activityType,
      'fociFound': fociFound,
      'treatmentApplied': treatmentApplied ? 1 : 0,
      'observations': observations,
    };
  }
}
