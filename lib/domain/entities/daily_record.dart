class DailyRecord {
  final String id;
  final String agentId;
  final String zoneId;
  final String streetId;
  final String propertyIdentifier;
  final DateTime date;
  final String status;
  final String activityType;
  final int fociFound;
  final bool treatmentApplied;
  final String observations;

  const DailyRecord({
    required this.id,
    required this.agentId,
    required this.zoneId,
    required this.streetId,
    required this.propertyIdentifier,
    required this.date,
    required this.status,
    required this.activityType,
    required this.fociFound,
    required this.treatmentApplied,
    required this.observations,
  });
}
