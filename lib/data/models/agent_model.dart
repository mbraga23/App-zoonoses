import 'package:uuid/uuid.dart';

import '../../domain/entities/agent.dart';

class AgentModel extends Agent {
  const AgentModel({
    required super.id,
    required super.name,
    required super.username,
    required super.activeZoneId,
  });

  factory AgentModel.fromMap(Map<String, dynamic> map) {
    return AgentModel(
      id: map['id'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      activeZoneId: map['activeZoneId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.isEmpty ? const Uuid().v4() : id,
      'name': name,
      'username': username,
      'activeZoneId': activeZoneId,
    };
  }
}
