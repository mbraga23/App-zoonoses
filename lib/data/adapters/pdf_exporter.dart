import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/daily_record.dart';
import '../../domain/entities/agent.dart';
import '../../domain/entities/zone.dart';

/// Generates a PDF summary of daily records filtered by period/zone.
class PdfExporter {
  Future<File> generate({
    required Agent agent,
    required Zone zone,
    required DateTime start,
    required DateTime end,
    required List<DailyRecord> records,
  }) async {
    final doc = pw.Document();
    final formatter = DateFormat('dd/MM/yyyy');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Relatório de Serviço Antivetorial', style: pw.TextStyle(fontSize: 20)),
            ),
            pw.Text('Agente: ${agent.name} (${agent.username})'),
            pw.Text('Zoneamento: ${zone.name}'),
            pw.Text('Período: ${formatter.format(start)} - ${formatter.format(end)}'),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: [
                'Data',
                'Rua',
                'Imóvel/Ponto',
                'Situação',
                'Atividade',
                'Focos',
                'Tratamento',
                'Obs.',
              ],
              data: records.map((r) {
                return [
                  formatter.format(r.date),
                  r.streetId,
                  r.propertyIdentifier,
                  r.status,
                  r.activityType,
                  r.fociFound.toString(),
                  r.treatmentApplied ? 'Sim' : 'Não',
                  r.observations,
                ];
              }).toList(),
            )
          ];
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final filename =
        'relatorio_${agent.username}_${formatter.format(start)}_${formatter.format(end)}.pdf'.replaceAll('/', '-');
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(await doc.save());
    return file;
  }
}
