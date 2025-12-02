import 'package:sqflite/sqflite.dart';

import '../../domain/entities/street.dart';
import '../../domain/repositories/street_repository.dart';
import '../datasources/local_database.dart';
import '../models/street_model.dart';

class StreetRepositoryImpl implements StreetRepository {
  Future<Database> get _db async => LocalDatabase.database;

  @override
  Future<List<Street>> byZone(String zoneId) async {
    final db = await _db;
    final result = await db.query('streets', where: 'zoneId = ?', whereArgs: [zoneId], orderBy: 'name');
    return result.map((e) => StreetModel.fromMap(e)).toList();
  }

  @override
  Future<Street?> getById(String id) async {
    final db = await _db;
    final result = await db.query('streets', where: 'id = ?', whereArgs: [id]);
    if (result.isEmpty) return null;
    return StreetModel.fromMap(result.first);
  }
}
