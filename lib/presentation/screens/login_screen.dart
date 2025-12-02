import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/agent.dart';
import '../../domain/entities/zone.dart';
import '../../domain/entities/zone_change_log.dart';
import '../providers/app_providers.dart';
import 'records_list_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const route = '/';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  Zone? _selectedZone;
  final _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final zonesAsync = ref.watch(zonesProvider);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Registro Antivetorial', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Usuário (agente)'),
                      onSaved: (value) => _username = value?.trim(),
                      validator: (value) => value == null || value.isEmpty ? 'Informe o usuário' : null,
                    ),
                    const SizedBox(height: 12),
                    zonesAsync.when(
                      data: (zones) => DropdownButtonFormField<Zone>(
                        decoration: const InputDecoration(labelText: 'Zoneamento'),
                        items: zones
                            .map((z) => DropdownMenuItem(
                                  value: z,
                                  child: Text(z.name),
                                ))
                            .toList(),
                        onChanged: (z) => setState(() => _selectedZone = z),
                        validator: (value) => value == null ? 'Selecione o zoneamento' : null,
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, _) => Text('Erro ao carregar zoneamentos: $e'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();
                        if (_selectedZone == null || _username == null) return;
                        final agentRepo = ref.read(agentRepositoryProvider);
                        final logRepo = ref.read(zoneChangeLogRepositoryProvider);
                        final existing = await agentRepo.getByUsername(_username!);
                        Agent agent;
                        if (existing == null) {
                          agent = await agentRepo.save(
                            Agent(
                              id: _uuid.v4(),
                              name: _username!,
                              username: _username!,
                              activeZoneId: _selectedZone!.id,
                            ),
                          );
                        } else {
                          if (existing.activeZoneId != _selectedZone!.id) {
                            await logRepo.save(
                              ZoneChangeLog(
                                id: _uuid.v4(),
                                agentId: existing.id,
                                previousZoneId: existing.activeZoneId,
                                newZoneId: _selectedZone!.id,
                                changedAt: DateTime.now(),
                              ),
                            );
                          }
                          agent = await agentRepo.updateActiveZone(existing.id, _selectedZone!.id);
                        }
                        ref.read(sessionProvider.notifier).state = agent;
                        ref.read(activeZoneProvider.notifier).state = _selectedZone;
                        if (mounted) {
                          Navigator.of(context).pushReplacementNamed(RecordsListScreen.route);
                        }
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Entrar'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
