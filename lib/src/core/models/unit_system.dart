enum UnitSystem { metric, imperial }

extension UnitSystemX on UnitSystem {
  String get code => switch (this) {
        UnitSystem.metric => 'metric',
        UnitSystem.imperial => 'imperial',
      };

  String get shortLabel => switch (this) {
        UnitSystem.metric => 'mm',
        UnitSystem.imperial => 'in',
      };

  double toMillimeters(double value) => switch (this) {
        UnitSystem.metric => value,
        UnitSystem.imperial => value * 25.4,
      };

  double fromMillimeters(double value) => switch (this) {
        UnitSystem.metric => value,
        UnitSystem.imperial => value / 25.4,
      };

  static UnitSystem fromCode(String? code) {
    return UnitSystem.values.firstWhere(
      (value) => value.code == code,
      orElse: () => UnitSystem.metric,
    );
  }
}
