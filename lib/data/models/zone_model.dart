import '../../domain/entities/zone.dart';

class ZoneModel extends Zone {
  const ZoneModel({required super.id, required super.name});

  factory ZoneModel.fromMap(Map<String, dynamic> map) {
    return ZoneModel(id: map['id'] as String, name: map['name'] as String);
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}
