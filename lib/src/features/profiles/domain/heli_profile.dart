import '../../../core/models/unit_system.dart';
import '../../blade_angle/domain/blade_angle_models.dart';
import '../../gear_ratio/domain/gear_ratio_models.dart';

class HeliProfile {
  const HeliProfile({
    required this.id,
    required this.name,
    required this.model,
    required this.preferredUnitSystem,
    required this.updatedAt,
    this.bladeRadiusMm,
    this.lastAngleCalibration,
    this.gearTrainType,
    this.gearTeeth = const {},
  });

  final String id;
  final String name;
  final String model;
  final UnitSystem preferredUnitSystem;
  final double? bladeRadiusMm;
  final AngleMeasurementCalibration? lastAngleCalibration;
  final GearTrainType? gearTrainType;
  final Map<String, int> gearTeeth;
  final DateTime updatedAt;

  HeliProfile copyWith({
    String? id,
    String? name,
    String? model,
    UnitSystem? preferredUnitSystem,
    Object? bladeRadiusMm = _sentinel,
    Object? lastAngleCalibration = _sentinel,
    Object? gearTrainType = _sentinel,
    Map<String, int>? gearTeeth,
    DateTime? updatedAt,
  }) {
    return HeliProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      preferredUnitSystem: preferredUnitSystem ?? this.preferredUnitSystem,
      bladeRadiusMm: identical(bladeRadiusMm, _sentinel)
          ? this.bladeRadiusMm
          : bladeRadiusMm as double?,
      lastAngleCalibration: identical(lastAngleCalibration, _sentinel)
          ? this.lastAngleCalibration
          : lastAngleCalibration as AngleMeasurementCalibration?,
      gearTrainType: identical(gearTrainType, _sentinel)
          ? this.gearTrainType
          : gearTrainType as GearTrainType?,
      gearTeeth: gearTeeth ?? this.gearTeeth,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'preferredUnitSystem': preferredUnitSystem.code,
      'bladeRadiusMm': bladeRadiusMm,
      'lastAngleCalibration': lastAngleCalibration?.toJson(),
      'gearTrainType': gearTrainType?.code,
      'gearTeeth': gearTeeth,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory HeliProfile.fromJson(Map<String, dynamic> json) {
    final rawTeeth = json['gearTeeth'] as Map<String, dynamic>? ?? const {};
    return HeliProfile(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      model: json['model'] as String? ?? '',
      preferredUnitSystem:
          UnitSystemX.fromCode(json['preferredUnitSystem'] as String?),
      bladeRadiusMm: (json['bladeRadiusMm'] as num?)?.toDouble(),
      lastAngleCalibration: json['lastAngleCalibration'] == null
          ? null
          : AngleMeasurementCalibration.fromJson(
              Map<String, dynamic>.from(json['lastAngleCalibration'] as Map),
            ),
      gearTrainType: GearTrainTypeX.fromCode(json['gearTrainType'] as String?),
      gearTeeth: rawTeeth.map(
        (key, value) => MapEntry(key, (value as num).toInt()),
      ),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

const _sentinel = Object();
