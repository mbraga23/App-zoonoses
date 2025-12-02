import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/zone_change_log.dart';
import '../../domain/repositories/zone_change_log_repository.dart';
import '../datasources/local_database.dart';
import '../models/zone_change_log_model.dart';

class ZoneChangeLogRepositoryImpl implements ZoneChangeLogRepository {
  final _uuid = const Uuid();
  Future<Database> get _db async => LocalDatabase.database;

  @override
  Future<void> save(ZoneChangeLog log) async {
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
