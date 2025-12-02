import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/agent_repository_impl.dart';
import '../../data/repositories/daily_record_repository_impl.dart';
import '../../data/repositories/street_repository_impl.dart';
import '../../data/repositories/zone_change_log_repository_impl.dart';
import '../../data/repositories/zone_repository_impl.dart';
import '../../domain/entities/agent.dart';
import '../../domain/entities/daily_record.dart';
import '../../domain/entities/zone.dart';
import '../../domain/entities/street.dart';
import '../../domain/entities/zone_change_log.dart';

final agentRepositoryProvider = Provider((ref) => AgentRepositoryImpl());
final zoneRepositoryProvider = Provider((ref) => ZoneRepositoryImpl());
final streetRepositoryProvider = Provider((ref) => StreetRepositoryImpl());
final dailyRecordRepositoryProvider = Provider((ref) => DailyRecordRepositoryImpl());
final zoneChangeLogRepositoryProvider = Provider((ref) => ZoneChangeLogRepositoryImpl());

final sessionProvider = StateProvider<Agent?>((ref) => null);
final activeZoneProvider = StateProvider<Zone?>((ref) => null);

final streetsByZoneProvider = FutureProvider.family<List<Street>, String>((ref, zoneId) async {
  final repo = ref.watch(streetRepositoryProvider);
  return repo.byZone(zoneId);
});

final recordsByZoneProvider = FutureProvider.family<List<DailyRecord>, String>((ref, zoneId) async {
  final repo = ref.watch(dailyRecordRepositoryProvider);
  return repo.allByZone(zoneId);
});

final zonesProvider = FutureProvider<List<Zone>>((ref) async {
  final repo = ref.watch(zoneRepositoryProvider);
  return repo.all();
});

final agentsProvider = FutureProvider<List<Agent>>((ref) async {
  final repo = ref.watch(agentRepositoryProvider);
  return repo.all();
});

final zoneChangeLogProvider = Provider((ref) => ref.watch(zoneChangeLogRepositoryProvider));
final dailyRecordRepository = Provider((ref) => ref.watch(dailyRecordRepositoryProvider));
