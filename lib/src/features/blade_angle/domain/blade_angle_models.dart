enum BladeCalculationTarget { tipDistance, angle }

enum BladeAngleErrorCode {
  invalidRadius,
  invalidAngle,
  invalidDistance,
  missingValue,
}

class BladeAngleException implements Exception {
  BladeAngleException(this.code);

  final BladeAngleErrorCode code;
}

class BladeAngleCalcInput {
  const BladeAngleCalcInput({
    required this.bladeRadiusMm,
    this.targetAngleDegrees,
    this.tipDistanceMm,
  });

  final double bladeRadiusMm;
  final double? targetAngleDegrees;
  final double? tipDistanceMm;
}

class BladeAngleCalcResult {
  const BladeAngleCalcResult({
    required this.angleDegrees,
    required this.tipDistanceMm,
    required this.formula,
    required this.withinSafeRange,
  });

  final double angleDegrees;
  final double tipDistanceMm;
  final String formula;
  final bool withinSafeRange;
}

enum MeasurementAxis { longitudinal, lateral }

class AngleMeasurementCalibration {
  const AngleMeasurementCalibration({
    required this.zeroDegrees,
    required this.axis,
  });

  final double zeroDegrees;
  final MeasurementAxis axis;

  Map<String, dynamic> toJson() {
    return {
      'zeroDegrees': zeroDegrees,
      'axis': axis.name,
    };
  }

  factory AngleMeasurementCalibration.fromJson(Map<String, dynamic> json) {
    return AngleMeasurementCalibration(
      zeroDegrees: (json['zeroDegrees'] as num?)?.toDouble() ?? 0,
      axis: MeasurementAxis.values.firstWhere(
        (item) => item.name == json['axis'],
        orElse: () => MeasurementAxis.longitudinal,
      ),
    );
  }
}
