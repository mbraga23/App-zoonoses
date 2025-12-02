import '../entities/zone.dart';

abstract class ZoneRepository {
  Future<List<Zone>> all();
  Future<Zone?> getById(String id);
}
