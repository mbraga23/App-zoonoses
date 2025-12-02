import 'dart:io';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/daily_record.dart';

class CsvExporter {
  Future<File> generate({
    required List<DailyRecord> records,
    required DateTime start,
    required DateTime end,
  }) async {
    final formatter = DateFormat('dd/MM/yyyy');
    final rows = <List<dynamic>>[
      [
        'Data',
        'Agente',
        'Zoneamento',
        'Rua',
        'Imóvel/Ponto',
        'Situação',
        'Atividade',
        'Focos',
        'Tratamento',
        'Observações'
      ]
    ];
    for (final record in records) {
      rows.add([
        formatter.format(record.date),
        record.agentId,
        record.zoneId,
        record.streetId,
        record.propertyIdentifier,
        record.status,
        record.activityType,
        record.fociFound,
        record.treatmentApplied ? 'Sim' : 'Não',
        record.observations,
      ]);
    }

    final data = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final filename = 'registros_${formatter.format(start)}_${formatter.format(end)}.csv'.replaceAll('/', '-');
    final file = File('${dir.path}/$filename');
    await file.writeAsString(data);
    return file;
  }
}
