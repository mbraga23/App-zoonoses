import '../entities/agent.dart';

abstract class AgentRepository {
  Future<Agent?> getByUsername(String username);
  Future<Agent> save(Agent agent);
  Future<List<Agent>> all();
  Future<Agent> updateActiveZone(String agentId, String zoneId);
}
