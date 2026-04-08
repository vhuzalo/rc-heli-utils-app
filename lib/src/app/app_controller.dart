import 'package:flutter/foundation.dart';

import '../core/localization/app_localizations.dart';
import '../core/models/unit_system.dart';
import '../features/profiles/data/profile_repository.dart';
import '../features/profiles/domain/heli_profile.dart';

class AppController extends ChangeNotifier {
  AppController({required this.repository});

  final ProfileRepository repository;

  AppLanguage language = AppLanguage.ptBr;
  UnitSystem unitSystem = UnitSystem.metric;
  String? selectedProfileId;
  List<HeliProfile> profiles = const [];
  bool isLoading = true;

  HeliProfile? get selectedProfile {
    if (selectedProfileId == null) {
      return null;
    }
    for (final profile in profiles) {
      if (profile.id == selectedProfileId) {
        return profile;
      }
    }
    return null;
  }

  Future<void> load() async {
    final preferences = await repository.loadPreferences();
    final loadedProfiles = await repository.loadProfiles();

    language = preferences.language;
    unitSystem = preferences.unitSystem;
    profiles = _sortProfiles(loadedProfiles);
    selectedProfileId = preferences.selectedProfileId;
    if (selectedProfileId != null &&
        profiles.every((profile) => profile.id != selectedProfileId)) {
      selectedProfileId = null;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage value) async {
    language = value;
    await _persistPreferences();
    notifyListeners();
  }

  Future<void> setUnitSystem(UnitSystem value) async {
    unitSystem = value;
    await _persistPreferences();
    notifyListeners();
  }

  Future<void> selectProfile(String? value) async {
    selectedProfileId = value;
    await _persistPreferences();
    notifyListeners();
  }

  Future<void> upsertProfile(HeliProfile profile) async {
    final items = [...profiles];
    final index = items.indexWhere((item) => item.id == profile.id);
    if (index == -1) {
      items.add(profile);
    } else {
      items[index] = profile;
    }
    profiles = _sortProfiles(items);
    selectedProfileId ??= profile.id;
    await repository.saveProfiles(profiles);
    await _persistPreferences();
    notifyListeners();
  }

  Future<void> deleteProfile(String id) async {
    profiles = _sortProfiles(
      profiles.where((profile) => profile.id != id).toList(),
    );
    if (selectedProfileId == id) {
      selectedProfileId = profiles.isEmpty ? null : profiles.first.id;
    }
    await repository.saveProfiles(profiles);
    await _persistPreferences();
    notifyListeners();
  }

  Future<void> _persistPreferences() {
    return repository.savePreferences(
      AppPreferences(
        language: language,
        unitSystem: unitSystem,
        selectedProfileId: selectedProfileId,
      ),
    );
  }

  List<HeliProfile> _sortProfiles(List<HeliProfile> items) {
    final sorted = [...items];
    sorted.sort((a, b) {
      final byName = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (byName != 0) {
        return byName;
      }
      return a.model.toLowerCase().compareTo(b.model.toLowerCase());
    });
    return sorted;
  }
}
