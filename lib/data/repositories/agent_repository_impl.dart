import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/agent.dart';
import '../../domain/repositories/agent_repository.dart';
import '../datasources/local_database.dart';
import '../models/agent_model.dart';
import '../models/zone_change_log_model.dart';
import '../../domain/entities/zone_change_log.dart';

class AgentRepositoryImpl implements AgentRepository {
  final _uuid = const Uuid();

  Future<Database> get _db async => LocalDatabase.database;

  @override
  Future<List<Agent>> all() async {
    final db = await _db;
    final result = await db.query('agents');
    return result.map((e) => AgentModel.fromMap(e)).toList();
  }

  @override
  Future<Agent?> getByUsername(String username) async {
    final db = await _db;
    final result = await db.query('agents', where: 'username = ?', whereArgs: [username]);
    if (result.isEmpty) return null;
    return AgentModel.fromMap(result.first);
  }

  @override
  Future<Agent> save(Agent agent) async {
    final db = await _db;
    final model = AgentModel(
      id: agent.id.isEmpty ? _uuid.v4() : agent.id,
      name: agent.name,
      username: agent.username,
      activeZoneId: agent.activeZoneId,
    );
    await db.insert('agents', model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return model;
  }

  @override
  Future<Agent> updateActiveZone(String agentId, String zoneId) async {
    final db = await _db;
    await db.update('agents', {'activeZoneId': zoneId}, where: 'id = ?', whereArgs: [agentId]);
    final updated = await db.query('agents', where: 'id = ?', whereArgs: [agentId]);
    return AgentModel.fromMap(updated.first);
  }

  Future<void> logZoneChange(ZoneChangeLog log) async {
    final db = await _db;
    final model = ZoneChangeLogModel(
      id: log.id.isEmpty ? _uuid.v4() : log.id,
      agentId: log.agentId,
      previousZoneId: log.previousZoneId,
      newZoneId: log.newZoneId,
      changedAt: log.changedAt,
    );
    await db.insert('zone_change_logs', model.toMap());
  }
}
