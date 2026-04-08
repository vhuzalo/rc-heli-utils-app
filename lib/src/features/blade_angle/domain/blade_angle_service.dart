import 'dart:math' as math;

import 'blade_angle_models.dart';

class BladeAngleService {
  static const safeAngleLimitDegrees = 25.0;

  BladeAngleCalcResult calculate(
    BladeCalculationTarget target,
    BladeAngleCalcInput input,
  ) {
    if (input.bladeRadiusMm <= 0) {
      throw BladeAngleException(BladeAngleErrorCode.invalidRadius);
    }

    return switch (target) {
      BladeCalculationTarget.tipDistance => _calculateDistance(input),
      BladeCalculationTarget.angle => _calculateAngle(input),
    };
  }

  BladeAngleCalcResult _calculateDistance(BladeAngleCalcInput input) {
    final angle = input.targetAngleDegrees;
    if (angle == null) {
      throw BladeAngleException(BladeAngleErrorCode.missingValue);
    }
    if (angle.abs() > safeAngleLimitDegrees) {
      throw BladeAngleException(BladeAngleErrorCode.invalidAngle);
    }

    final tipDistanceMm =
        2 * input.bladeRadiusMm * math.sin(angle.abs() * math.pi / 180);

    return BladeAngleCalcResult(
      angleDegrees: angle,
      tipDistanceMm: tipDistanceMm,
      formula: 'd = 2 * L * sin(|theta|)',
      withinSafeRange: angle.abs() <= safeAngleLimitDegrees,
    );
  }

  BladeAngleCalcResult _calculateAngle(BladeAngleCalcInput input) {
    final tipDistance = input.tipDistanceMm;
    if (tipDistance == null) {
      throw BladeAngleException(BladeAngleErrorCode.missingValue);
    }
    if (tipDistance <= 0 || tipDistance > input.bladeRadiusMm * 2) {
      throw BladeAngleException(BladeAngleErrorCode.invalidDistance);
    }

    final angleDegrees =
        math.asin(tipDistance / (2 * input.bladeRadiusMm)) * 180 / math.pi;

    return BladeAngleCalcResult(
      angleDegrees: angleDegrees,
      tipDistanceMm: tipDistance,
      formula: 'theta = asin(d / (2 * L))',
      withinSafeRange: angleDegrees <= safeAngleLimitDegrees,
    );
  }
}
