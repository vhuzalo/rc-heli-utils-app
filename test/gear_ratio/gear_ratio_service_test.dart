import 'package:flutter_test/flutter_test.dart';
import 'package:rc_heli_utils/src/features/gear_ratio/domain/gear_ratio_models.dart';
import 'package:rc_heli_utils/src/features/gear_ratio/domain/gear_ratio_service.dart';

void main() {
  group('GearRatioService', () {
    final service = GearRatioService();

    test('calculates single-stage ratios', () {
      final result = service.calculate(
        const GearRatioInput(
          type: GearTrainType.singleStage,
          teeth: {'Z1': 12, 'Z2': 121, 'Z3': 36, 'Z4': 18},
        ),
      );

      expect(result.motorPinion, 12);
      expect(result.mainGear, 121);
      expect(result.mainRatio, closeTo(10.0833, 0.0001));
      expect(result.tailRatio, closeTo(2, 0.0001));
    });

    test('calculates Rotorflight type 1 example', () {
      final result = service.calculate(
        const GearRatioInput(
          type: GearTrainType.twoStageType1,
          teeth: {
            'Z1': 21,
            'Z2': 56,
            'Z3': 18,
            'Z4': 68,
            'Z5': 34,
            'Z6': 26,
          },
        ),
      );

      expect(result.motorPinion, 378);
      expect(result.mainGear, 3808);
      expect(result.tailPulley, 468);
      expect(result.frontPulley, 2312);
      expect(result.mainRatio, closeTo(10.074, 0.001));
      expect(result.tailRatio, closeTo(4.940, 0.001));
    });

    test('calculates Rotorflight type 2 example', () {
      final result = service.calculate(
        const GearRatioInput(
          type: GearTrainType.twoStageType2,
          teeth: {
            'Z1': 21,
            'Z2': 54,
            'Z3': 17,
            'Z4': 66,
            'Z5': 57,
            'Z6': 14,
          },
        ),
      );

      expect(result.motorPinion, 357);
      expect(result.mainGear, 3564);
      expect(result.tailPulley, 14);
      expect(result.frontPulley, 57);
      expect(result.mainRatio, closeTo(9.983, 0.001));
      expect(result.tailRatio, closeTo(4.071, 0.001));
    });

    test('calculates Rotorflight type 3 example', () {
      final result = service.calculate(
        const GearRatioInput(
          type: GearTrainType.twoStageType3,
          teeth: {
            'Z1': 13,
            'Z2': 42,
            'Z3': 19,
            'Z4': 61,
            'Z5': 14,
            'Z6': 9,
            'Z7': 9,
          },
        ),
      );

      expect(result.motorPinion, 247);
      expect(result.mainGear, 2562);
      expect(result.tailPulley, 126);
      expect(result.frontPulley, 549);
      expect(result.mainRatio, closeTo(10.372, 0.001));
      expect(result.tailRatio, closeTo(4.357, 0.001));
    });
  });
}
