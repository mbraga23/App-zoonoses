import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../data/adapters/csv_exporter.dart';
import '../../data/adapters/pdf_exporter.dart';
import '../providers/app_providers.dart';

class ExportScreen extends ConsumerStatefulWidget {
  static const route = '/export';
  const ExportScreen({super.key});

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  DateTime _start = DateTime.now().subtract(const Duration(days: 7));
  DateTime _end = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final agent = ref.watch(sessionProvider);
    final zone = ref.watch(activeZoneProvider);

    if (agent == null || zone == null) {
      return const Scaffold(body: Center(child: Text('Faça login novamente.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Exportar dados')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agente: ${agent.name}'),
            Text('Zoneamento: ${zone.name}'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildDateField(context, 'Início', _start, (d) => setState(() => _start = d))),
                const SizedBox(width: 12),
                Expanded(child: _buildDateField(context, 'Fim', _end, (d) => setState(() => _end = d))),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final records = await ref.read(dailyRecordRepositoryProvider).byPeriod(start: _start, end: _end, zoneId: zone.id);
                    final file = await PdfExporter().generate(
                      agent: agent,
                      zone: zone,
                      start: _start,
                      end: _end,
                      records: records,
                    );
                    if (mounted) {
                      await Printing.sharePdf(bytes: await file.readAsBytes(), filename: file.path.split('/').last);
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Gerar PDF'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final records = await ref.read(dailyRecordRepositoryProvider).byPeriod(start: _start, end: _end, zoneId: zone.id);
                    final file = await CsvExporter().generate(records: records, start: _start, end: _end);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('CSV salvo em: ${file.path}')),
                      );
                    }
                  },
                  icon: const Icon(Icons.table_view),
                  label: const Text('Exportar CSV'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Os arquivos são salvos localmente para uso offline. A sincronização com API REST pode ser ligada futuramente através das interfaces em data/adapters.',
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label, DateTime value, ValueChanged<DateTime> onChange) {
    final formatter = DateFormat('dd/MM/yyyy');
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) onChange(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Row(
          children: [
            Text(formatter.format(value)),
            const Spacer(),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
