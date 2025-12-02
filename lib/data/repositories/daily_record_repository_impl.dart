import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/daily_record.dart';
import '../../domain/repositories/daily_record_repository.dart';
import '../datasources/local_database.dart';
import '../models/daily_record_model.dart';

class DailyRecordRepositoryImpl implements DailyRecordRepository {
  final _uuid = const Uuid();
  Future<Database> get _db async => LocalDatabase.database;

  @override
  Future<List<DailyRecord>> allByZone(String zoneId) async {
    final db = await _db;
    final result = await db.query('daily_records', where: 'zoneId = ?', whereArgs: [zoneId], orderBy: 'date DESC');
    return result.map((e) => DailyRecordModel.fromMap(e)).toList();
  }

  @override
  Future<List<DailyRecord>> byPeriod({required DateTime start, required DateTime end, String? zoneId}) async {
    final db = await _db;
    final where = StringBuffer('date BETWEEN ? AND ?');
    final args = <Object>[start.toIso8601String(), end.toIso8601String()];
    if (zoneId != null) {
      where.write(' AND zoneId = ?');
      args.add(zoneId);
    }
    final result = await db.query('daily_records', where: where.toString(), whereArgs: args, orderBy: 'date DESC');
    return result.map((e) => DailyRecordModel.fromMap(e)).toList();
  }

  @override
  Future<DailyRecord> save(DailyRecord record) async {
    final db = await _db;
    final model = DailyRecordModel(
      id: record.id.isEmpty ? _uuid.v4() : record.id,
      agentId: record.agentId,
      zoneId: record.zoneId,
      streetId: record.streetId,
      propertyIdentifier: record.propertyIdentifier,
      date: record.date,
      status: record.status,
      activityType: record.activityType,
      fociFound: record.fociFound,
      treatmentApplied: record.treatmentApplied,
      observations: record.observations,
    );
    await db.insert('daily_records', model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return model;
  }
}
