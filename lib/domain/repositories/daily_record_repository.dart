import '../entities/daily_record.dart';

abstract class DailyRecordRepository {
  Future<DailyRecord> save(DailyRecord record);
  Future<List<DailyRecord>> byPeriod({required DateTime start, required DateTime end, String? zoneId});
  Future<List<DailyRecord>> allByZone(String zoneId);
}
