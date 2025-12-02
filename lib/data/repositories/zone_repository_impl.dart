import 'package:sqflite/sqflite.dart';

import '../../domain/entities/zone.dart';
import '../../domain/repositories/zone_repository.dart';
import '../datasources/local_database.dart';
import '../models/zone_model.dart';

class ZoneRepositoryImpl implements ZoneRepository {
  Future<Database> get _db async => LocalDatabase.database;

  @override
  Future<List<Zone>> all() async {
    final db = await _db;
    final result = await db.query('zones', orderBy: 'name');
    return result.map((e) => ZoneModel.fromMap(e)).toList();
  }

  @override
  Future<Zone?> getById(String id) async {
    final db = await _db;
    final result = await db.query('zones', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return ZoneModel.fromMap(result.first);
  }
}
