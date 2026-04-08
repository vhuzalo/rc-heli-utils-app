import 'package:flutter_test/flutter_test.dart';
import 'package:rc_heli_utils/src/core/models/unit_system.dart';
import 'package:rc_heli_utils/src/features/blade_angle/domain/blade_angle_models.dart';
import 'package:rc_heli_utils/src/features/blade_angle/domain/blade_angle_service.dart';

void main() {
  group('BladeAngleService', () {
    final service = BladeAngleService();

    test('calculates tip distance from blade length and angle', () {
      final result = service.calculate(
        BladeCalculationTarget.tipDistance,
        const BladeAngleCalcInput(
          bladeRadiusMm: 360,
          targetAngleDegrees: 12,
        ),
      );

      expect(result.tipDistanceMm, closeTo(149.70, 0.01));
      expect(result.angleDegrees, 12);
      expect(result.withinSafeRange, isTrue);
    });

    test('calculates angle magnitude from blade length and tip distance', () {
      final result = service.calculate(
        BladeCalculationTarget.angle,
        const BladeAngleCalcInput(
          bladeRadiusMm: 360,
          tipDistanceMm: 149.70,
        ),
      );

      expect(result.angleDegrees, closeTo(12, 0.05));
      expect(result.tipDistanceMm, closeTo(149.70, 0.01));
    });

    test('rejects impossible distance', () {
      expect(
        () => service.calculate(
          BladeCalculationTarget.angle,
          const BladeAngleCalcInput(
            bladeRadiusMm: 100,
            tipDistanceMm: 250,
          ),
        ),
        throwsA(
          isA<BladeAngleException>().having(
            (error) => error.code,
            'code',
            BladeAngleErrorCode.invalidDistance,
          ),
        ),
      );
    });
  });

  group('UnitSystem', () {
    test('converts between millimeters and inches', () {
      expect(UnitSystem.imperial.toMillimeters(1), closeTo(25.4, 0.0001));
      expect(UnitSystem.imperial.fromMillimeters(25.4), closeTo(1, 0.0001));
    });
  });
}
