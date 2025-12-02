class Agent {
  final String id;
  final String name;
  final String username;
  final String activeZoneId;

  const Agent({
    required this.id,
    required this.name,
    required this.username,
    required this.activeZoneId,
  });

  Agent copyWith({String? activeZoneId}) {
    return Agent(
      id: id,
      name: name,
      username: username,
      activeZoneId: activeZoneId ?? this.activeZoneId,
    );
  }
}
