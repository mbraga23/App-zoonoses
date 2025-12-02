import '../entities/street.dart';

abstract class StreetRepository {
  Future<List<Street>> byZone(String zoneId);
  Future<Street?> getById(String id);
}
