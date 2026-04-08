import 'package:flutter_test/flutter_test.dart';
import 'package:rc_heli_utils/src/core/localization/app_localizations.dart';
import 'package:rc_heli_utils/src/core/models/unit_system.dart';
import 'package:rc_heli_utils/src/features/blade_angle/domain/blade_angle_models.dart';
import 'package:rc_heli_utils/src/features/gear_ratio/domain/gear_ratio_models.dart';
import 'package:rc_heli_utils/src/features/profiles/data/profile_repository.dart';
import 'package:rc_heli_utils/src/features/profiles/domain/heli_profile.dart';

void main() {
  group('ProfileRepository', () {
    test('persists and restores profiles and preferences', () async {
      final store = _MemoryStore();
      final repository = ProfileRepository(store);

      final profile = HeliProfile(
        id: 'heli-1',
        name: 'Kraken 580',
        model: 'SAB',
        preferredUnitSystem: UnitSystem.metric,
        bladeRadiusMm: 360,
        lastAngleCalibration: const AngleMeasurementCalibration(
          zeroDegrees: 1.5,
          axis: MeasurementAxis.longitudinal,
        ),
        gearTrainType: GearTrainType.twoStageType1,
        gearTeeth: const {
          'Z1': 21,
          'Z2': 56,
          'Z3': 18,
          'Z4': 68,
          'Z5': 34,
          'Z6': 26,
        },
        updatedAt: DateTime.parse('2026-03-20T12:00:00Z'),
      );

      await repository.saveProfiles([profile]);
      await repository.savePreferences(
        const AppPreferences(
          language: AppLanguage.en,
          unitSystem: UnitSystem.imperial,
          selectedProfileId: 'heli-1',
        ),
      );

      final restoredProfiles = await repository.loadProfiles();
      final restoredPreferences = await repository.loadPreferences();

      expect(restoredProfiles, hasLength(1));
      expect(restoredProfiles.first.id, 'heli-1');
      expect(restoredProfiles.first.gearTrainType, GearTrainType.twoStageType1);
      expect(restoredProfiles.first.lastAngleCalibration?.zeroDegrees, 1.5);
      expect(restoredProfiles.first.gearTeeth['Z4'], 68);
      expect(restoredPreferences.language, AppLanguage.en);
      expect(restoredPreferences.unitSystem, UnitSystem.imperial);
      expect(restoredPreferences.selectedProfileId, 'heli-1');
    });
  });
}

class _MemoryStore implements KeyValueStore {
  final _map = <String, String>{};

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> remove(String key) async {
    _map.remove(key);
  }

  @override
  Future<void> write(String key, String value) async {
    _map[key] = value;
  }
}
