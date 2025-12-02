import '../../domain/entities/zone_change_log.dart';

class ZoneChangeLogModel extends ZoneChangeLog {
  const ZoneChangeLogModel({
    required super.id,
    required super.agentId,
    required super.previousZoneId,
    required super.newZoneId,
    required super.changedAt,
  });

  factory ZoneChangeLogModel.fromMap(Map<String, dynamic> map) {
    return ZoneChangeLogModel(
      id: map['id'] as String,
      agentId: map['agentId'] as String,
      previousZoneId: map['previousZoneId'] as String,
      newZoneId: map['newZoneId'] as String,
      changedAt: DateTime.parse(map['changedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'agentId': agentId,
      'previousZoneId': previousZoneId,
      'newZoneId': newZoneId,
      'changedAt': changedAt.toIso8601String(),
    };
  }
}
