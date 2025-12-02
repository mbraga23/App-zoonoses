import '../entities/zone_change_log.dart';

abstract class ZoneChangeLogRepository {
  Future<void> save(ZoneChangeLog log);
}
