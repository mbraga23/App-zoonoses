import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/daily_record.dart';
import '../../domain/entities/street.dart';
import '../providers/app_providers.dart';

class RecordFormScreen extends ConsumerStatefulWidget {
  static const route = '/record-form';
  const RecordFormScreen({super.key});

  @override
  ConsumerState<RecordFormScreen> createState() => _RecordFormScreenState();
}

class _RecordFormScreenState extends ConsumerState<RecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  DateTime _date = DateTime.now();
  String _property = '';
  String _status = 'Visitado';
  String _activity = 'Inspeção';
  int _fociFound = 0;
  bool _treatmentApplied = false;
  String _observations = '';
  Street? _selectedStreet;

  @override
  Widget build(BuildContext context) {
    final agent = ref.watch(sessionProvider);
    final zone = ref.watch(activeZoneProvider);
    if (agent == null || zone == null) {
      return const Scaffold(body: Center(child: Text('Faça login novamente.')));
    }
    final streetsAsync = ref.watch(streetsByZoneProvider(zone.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Novo registro diário')),
      body: streetsAsync.when(
        data: (streets) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<Street>(
                    decoration: const InputDecoration(labelText: 'Rua'),
                    items: streets
                        .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedStreet = value),
                    validator: (value) => value == null ? 'Selecione a rua' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Imóvel / Ponto'),
                    onSaved: (value) => _property = value?.trim() ?? '',
                    validator: (value) => value == null || value.isEmpty ? 'Informe o imóvel/ponto' : null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Data da visita'),
                          child: Row(
                            children: [
                              Text(DateFormat('dd/MM/yyyy').format(_date)),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _date,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) setState(() => _date = picked);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Situação do imóvel'),
                    items: const [
                      DropdownMenuItem(value: 'Visitado', child: Text('Visitado')),
                      DropdownMenuItem(value: 'Fechado', child: Text('Fechado')),
                      DropdownMenuItem(value: 'Recusado', child: Text('Recusado')),
                      DropdownMenuItem(value: 'Desabitado', child: Text('Desabitado')),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? 'Visitado'),
                  ),
                  DropdownButtonFormField<String>(
                    value: _activity,
                    decoration: const InputDecoration(labelText: 'Tipo de atividade'),
                    items: const [
                      DropdownMenuItem(value: 'Inspeção', child: Text('Inspeção')),
                      DropdownMenuItem(value: 'Tratamento', child: Text('Tratamento')),
                      DropdownMenuItem(value: 'Orientação', child: Text('Orientação')),
                      DropdownMenuItem(value: 'Busca ativa', child: Text('Busca ativa')),
                    ],
                    onChanged: (v) => setState(() => _activity = v ?? 'Inspeção'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Focos encontrados'),
                    initialValue: '0',
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _fociFound = int.tryParse(value ?? '0') ?? 0,
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tratamento aplicado'),
                    value: _treatmentApplied,
                    onChanged: (v) => setState(() => _treatmentApplied = v),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Observações'),
                    maxLines: 3,
                    onSaved: (value) => _observations = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();
                        if (_selectedStreet == null) return;
                        final repo = ref.read(dailyRecordRepositoryProvider);
                        await repo.save(
                          DailyRecord(
                            id: _uuid.v4(),
                            agentId: agent.id,
                            zoneId: zone.id,
                            streetId: _selectedStreet!.id,
                            propertyIdentifier: _property,
                            date: _date,
                            status: _status,
                            activityType: _activity,
                            fociFound: _fociFound,
                            treatmentApplied: _treatmentApplied,
                            observations: _observations,
                          ),
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Registro salvo localmente')),);
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar'),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro ao carregar ruas: $e')),
      ),
    );
  }
}
