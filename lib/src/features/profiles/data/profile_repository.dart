import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/models/unit_system.dart';
import '../domain/heli_profile.dart';

class AppPreferences {
  const AppPreferences({
    required this.language,
    required this.unitSystem,
    this.selectedProfileId,
  });

  final AppLanguage language;
  final UnitSystem unitSystem;
  final String? selectedProfileId;

  Map<String, dynamic> toJson() {
    return {
      'language': language.code,
      'unitSystem': unitSystem.code,
      'selectedProfileId': selectedProfileId,
    };
  }

  factory AppPreferences.fromJson(Map<String, dynamic> json) {
    return AppPreferences(
      language: AppLanguage.fromCode(json['language'] as String?),
      unitSystem: UnitSystemX.fromCode(json['unitSystem'] as String?),
      selectedProfileId: json['selectedProfileId'] as String?,
    );
  }
}

abstract class KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> remove(String key);
}

class SharedPreferencesStore implements KeyValueStore {
  SharedPreferencesStore(this.preferences);

  final SharedPreferences preferences;

  @override
  Future<String?> read(String key) async => preferences.getString(key);

  @override
  Future<void> write(String key, String value) async {
    await preferences.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await preferences.remove(key);
  }
}

class ProfileRepository {
  ProfileRepository(this.store);

  static const _profilesKey = 'profiles';
  static const _preferencesKey = 'preferences';

  final KeyValueStore store;

  static Future<ProfileRepository> create() async {
    final preferences = await SharedPreferences.getInstance();
    return ProfileRepository(SharedPreferencesStore(preferences));
  }

  Future<List<HeliProfile>> loadProfiles() async {
    final raw = await store.read(_profilesKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => HeliProfile.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> saveProfiles(List<HeliProfile> profiles) async {
    final payload =
        jsonEncode(profiles.map((profile) => profile.toJson()).toList());
    await store.write(_profilesKey, payload);
  }

  Future<AppPreferences> loadPreferences() async {
    final raw = await store.read(_preferencesKey);
    if (raw == null || raw.isEmpty) {
      return const AppPreferences(
        language: AppLanguage.ptBr,
        unitSystem: UnitSystem.metric,
      );
    }

    return AppPreferences.fromJson(
      Map<String, dynamic>.from(jsonDecode(raw) as Map),
    );
  }

  Future<void> savePreferences(AppPreferences preferences) async {
    await store.write(_preferencesKey, jsonEncode(preferences.toJson()));
  }
}
