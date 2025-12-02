class ZoneChangeLog {
  final String id;
  final String agentId;
  final String previousZoneId;
  final String newZoneId;
  final DateTime changedAt;

  const ZoneChangeLog({
    required this.id,
    required this.agentId,
    required this.previousZoneId,
    required this.newZoneId,
    required this.changedAt,
  });
}
