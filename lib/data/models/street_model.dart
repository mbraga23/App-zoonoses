import '../../domain/entities/street.dart';

class StreetModel extends Street {
  const StreetModel({
    required super.id,
    required super.zoneId,
    required super.name,
    required super.block,
    required super.sector,
    required super.reference,
  });

  factory StreetModel.fromMap(Map<String, dynamic> map) {
    return StreetModel(
      id: map['id'] as String,
      zoneId: map['zoneId'] as String,
      name: map['name'] as String,
      block: map['block'] as String,
      sector: map['sector'] as String,
      reference: map['reference'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'zoneId': zoneId,
      'name': name,
      'block': block,
      'sector': sector,
      'reference': reference,
    };
  }
}
