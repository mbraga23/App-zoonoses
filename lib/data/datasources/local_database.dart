import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Simple local database helper built with sqflite.
/// It handles migrations and seed data from assets/data/seed.json
class LocalDatabase {
  static const _dbName = 'zoonoses.db';
  static const _dbVersion = 1;
  static Database? _instance;

  static Future<Database> get database async {
    if (_instance != null) return _instance!;
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, _dbName);
    _instance = await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (db, version) async {
        await _createTables(db);
        await _seed(db);
      },
    );
    return _instance!;
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE agents(
        id TEXT PRIMARY KEY,
        name TEXT,
        username TEXT UNIQUE,
        activeZoneId TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE zones(
        id TEXT PRIMARY KEY,
        name TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE streets(
        id TEXT PRIMARY KEY,
        zoneId TEXT,
        name TEXT,
        block TEXT,
        sector TEXT,
        reference TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE daily_records(
        id TEXT PRIMARY KEY,
        agentId TEXT,
        zoneId TEXT,
        streetId TEXT,
        propertyIdentifier TEXT,
        date TEXT,
        status TEXT,
        activityType TEXT,
        fociFound INTEGER,
        treatmentApplied INTEGER,
        observations TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE zone_change_logs(
        id TEXT PRIMARY KEY,
        agentId TEXT,
        previousZoneId TEXT,
        newZoneId TEXT,
        changedAt TEXT
      );
    ''');
  }

  static Future<void> _seed(Database db) async {
    final dataString = await rootBundle.loadString('assets/data/seed.json');
    final data = jsonDecode(dataString) as Map<String, dynamic>;
    final batch = db.batch();
    for (final zone in data['zones'] as List<dynamic>) {
      batch.insert('zones', Map<String, Object?>.from(zone));
    }
    for (final street in data['streets'] as List<dynamic>) {
      batch.insert('streets', Map<String, Object?>.from(street));
    }
    for (final agent in data['agents'] as List<dynamic>) {
      batch.insert('agents', Map<String, Object?>.from(agent));
    }
    await batch.commit(noResult: true);
  }
}
