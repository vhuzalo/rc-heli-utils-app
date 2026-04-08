enum GearTrainType {
  singleStage,
  twoStageType1,
  twoStageType2,
  twoStageType3,
}

extension GearTrainTypeX on GearTrainType {
  String get code => switch (this) {
        GearTrainType.singleStage => 'singleStage',
        GearTrainType.twoStageType1 => 'twoStageType1',
        GearTrainType.twoStageType2 => 'twoStageType2',
        GearTrainType.twoStageType3 => 'twoStageType3',
      };

  static GearTrainType? fromCode(String? code) {
    for (final value in GearTrainType.values) {
      if (value.code == code) {
        return value;
      }
    }
    return null;
  }
}

class GearRatioInput {
  const GearRatioInput({
    required this.type,
    required this.teeth,
  });

  final GearTrainType type;
  final Map<String, int> teeth;
}

class GearRatioResult {
  const GearRatioResult({
    required this.motorPinion,
    required this.mainGear,
    required this.tailPulley,
    required this.frontPulley,
    required this.mainRatio,
    required this.tailRatio,
  });

  final int motorPinion;
  final int mainGear;
  final int tailPulley;
  final int frontPulley;
  final double mainRatio;
  final double tailRatio;
}

enum GearRatioErrorCode { missingTeeth, invalidTeeth }

class GearRatioException implements Exception {
  GearRatioException(this.code, [this.field]);

  final GearRatioErrorCode code;
  final String? field;
}
