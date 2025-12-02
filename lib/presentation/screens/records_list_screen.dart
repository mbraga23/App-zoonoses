import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/zone_change_log.dart';
import '../providers/app_providers.dart';
import 'export_screen.dart';
import 'login_screen.dart';
import 'record_form_screen.dart';

class RecordsListScreen extends ConsumerWidget {
  static const route = '/records';
  const RecordsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agent = ref.watch(sessionProvider);
    final zone = ref.watch(activeZoneProvider);

    if (agent == null || zone == null) {
      return const LoginScreen();
    }

    final recordsAsync = ref.watch(recordsByZoneProvider(zone.id));
    final formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text('Registros - ${zone.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => Navigator.pushNamed(context, ExportScreen.route),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(sessionProvider.notifier).state = null;
              Navigator.of(context)
                  .pushReplacementNamed(LoginScreen.route);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, RecordFormScreen.route),
        icon: const Icon(Icons.add),
        label: const Text('Novo registro'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text('Agente: ${agent.name} (${agent.username})'),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    final zones = await ref.read(zonesProvider.future);
                    final newZone = await showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          title: const Text('Trocar zoneamento'),
                          children: zones
                              .map(
                                (z) => SimpleDialogOption(
                                  onPressed: () => Navigator.pop(context, z),
                                  child: Text(z.name),
                                ),
                              )
                              .toList(),
                        );
                      },
                    );
                    if (newZone != null && newZone.id != zone.id) {
                      final logRepo = ref.read(zoneChangeLogRepositoryProvider);
                      await logRepo.save(
                        ZoneChangeLog(
                          id: const Uuid().v4(),
                          agentId: agent.id,
                          previousZoneId: zone.id,
                          newZoneId: newZone.id,
                          changedAt: DateTime.now(),
                        ),
                      );
                      final updated = await ref.read(agentRepositoryProvider).updateActiveZone(agent.id, newZone.id);
                      ref.read(sessionProvider.notifier).state = updated;
                      ref.read(activeZoneProvider.notifier).state = newZone;
                    }
                  },
                  icon: const Icon(Icons.map),
                  label: Text('Zoneamento: ${zone.name}'),
                )
              ],
            ),
          ),
          Expanded(
            child: recordsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return const Center(child: Text('Nenhum registro para este zoneamento'));
                }
                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return ListTile(
                      leading: const Icon(Icons.assignment),
                      title: Text('${record.activityType} - ${record.status}'),
                      subtitle: Text('Data: ${formatter.format(record.date)}\nRua: ${record.streetId}\nFocos: ${record.fociFound}'),
                      isThreeLine: true,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erro ao carregar registros: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
