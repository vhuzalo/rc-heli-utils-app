import 'gear_ratio_models.dart';

class GearRatioService {
  static const _requiredKeys = <GearTrainType, List<String>>{
    GearTrainType.singleStage: ['Z1', 'Z2', 'Z3', 'Z4'],
    GearTrainType.twoStageType1: ['Z1', 'Z2', 'Z3', 'Z4', 'Z5', 'Z6'],
    GearTrainType.twoStageType2: ['Z1', 'Z2', 'Z3', 'Z4', 'Z5', 'Z6'],
    GearTrainType.twoStageType3: ['Z1', 'Z2', 'Z3', 'Z4', 'Z5', 'Z6', 'Z7'],
  };

  GearRatioResult calculate(GearRatioInput input) {
    final keys = _requiredKeys[input.type]!;
    for (final key in keys) {
      final value = input.teeth[key];
      if (value == null) {
        throw GearRatioException(GearRatioErrorCode.missingTeeth, key);
      }
      if (value <= 0) {
        throw GearRatioException(GearRatioErrorCode.invalidTeeth, key);
      }
    }

    return switch (input.type) {
      GearTrainType.singleStage => _singleStage(input.teeth),
      GearTrainType.twoStageType1 => _type1(input.teeth),
      GearTrainType.twoStageType2 => _type2(input.teeth),
      GearTrainType.twoStageType3 => _type3(input.teeth),
    };
  }

  List<String> requiredKeysFor(GearTrainType type) => _requiredKeys[type]!;

  GearRatioResult _singleStage(Map<String, int> teeth) {
    final motorPinion = teeth['Z1']!;
    final mainGear = teeth['Z2']!;
    final frontPulley = teeth['Z3']!;
    final tailPulley = teeth['Z4']!;
    return _buildResult(
      motorPinion: motorPinion,
      mainGear: mainGear,
      tailPulley: tailPulley,
      frontPulley: frontPulley,
    );
  }

  GearRatioResult _type1(Map<String, int> teeth) {
    final motorPinion = teeth['Z1']! * teeth['Z3']!;
    final mainGear = teeth['Z2']! * teeth['Z4']!;
    final tailPulley = teeth['Z3']! * teeth['Z6']!;
    final frontPulley = teeth['Z4']! * teeth['Z5']!;
    return _buildResult(
      motorPinion: motorPinion,
      mainGear: mainGear,
      tailPulley: tailPulley,
      frontPulley: frontPulley,
    );
  }

  GearRatioResult _type2(Map<String, int> teeth) {
    final motorPinion = teeth['Z1']! * teeth['Z3']!;
    final mainGear = teeth['Z2']! * teeth['Z4']!;
    final tailPulley = teeth['Z6']!;
    final frontPulley = teeth['Z5']!;
    return _buildResult(
      motorPinion: motorPinion,
      mainGear: mainGear,
      tailPulley: tailPulley,
      frontPulley: frontPulley,
    );
  }

  GearRatioResult _type3(Map<String, int> teeth) {
    final motorPinion = teeth['Z1']! * teeth['Z3']!;
    final mainGear = teeth['Z2']! * teeth['Z4']!;
    final tailPulley = teeth['Z5']! * teeth['Z7']!;
    final frontPulley = teeth['Z4']! * teeth['Z6']!;
    return _buildResult(
      motorPinion: motorPinion,
      mainGear: mainGear,
      tailPulley: tailPulley,
      frontPulley: frontPulley,
    );
  }

  GearRatioResult _buildResult({
    required int motorPinion,
    required int mainGear,
    required int tailPulley,
    required int frontPulley,
  }) {
    return GearRatioResult(
      motorPinion: motorPinion,
      mainGear: mainGear,
      tailPulley: tailPulley,
      frontPulley: frontPulley,
      mainRatio: mainGear / motorPinion,
      tailRatio: frontPulley / tailPulley,
    );
  }
}
