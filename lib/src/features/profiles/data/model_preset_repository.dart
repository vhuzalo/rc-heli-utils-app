import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/heli_model_preset.dart';

class ModelPresetRepository {
  const ModelPresetRepository();

  Future<List<HeliModelPreset>> loadPresets() async {
    try {
      final raw = await rootBundle.loadString('assets/model_presets.json');
      final decoded = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      final items = decoded['models'] as List<dynamic>? ?? const [];
      return items
          .map(
            (item) => HeliModelPreset.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
