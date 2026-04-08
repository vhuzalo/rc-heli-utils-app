import '../../gear_ratio/domain/gear_ratio_models.dart';

class HeliModelPreset {
  const HeliModelPreset({
    required this.id,
    required this.brand,
    required this.model,
    required this.variant,
    required this.classSize,
    required this.gearTrainType,
    required this.gearOptions,
    required this.sources,
    this.mainBladeRangeMm = const [],
    this.tailBladeRangeMm = const [],
    this.notes,
  });

  final String id;
  final String brand;
  final String model;
  final String variant;
  final int classSize;
  final GearTrainType gearTrainType;
  final List<GearOptionPreset> gearOptions;
  final List<PresetSource> sources;
  final List<int> mainBladeRangeMm;
  final List<int> tailBladeRangeMm;
  final String? notes;

  String get displayName => '$brand $model $variant';

  GearOptionPreset get defaultGearOption {
    return gearOptions.firstWhere(
      (option) => option.isDefault,
      orElse: () => gearOptions.first,
    );
  }

  factory HeliModelPreset.fromJson(Map<String, dynamic> json) {
    return HeliModelPreset(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      variant: json['variant'] as String? ?? '',
      classSize: (json['classSize'] as num).toInt(),
      gearTrainType: GearTrainTypeX.fromCode(json['gearTrainType'] as String)!,
      gearOptions: (json['gearOptions'] as List<dynamic>)
          .map((item) => GearOptionPreset.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      sources: (json['sources'] as List<dynamic>)
          .map((item) => PresetSource.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      mainBladeRangeMm: (json['mainBladeRangeMm'] as List<dynamic>? ?? const [])
          .map((item) => (item as num).toInt())
          .toList(),
      tailBladeRangeMm: (json['tailBladeRangeMm'] as List<dynamic>? ?? const [])
          .map((item) => (item as num).toInt())
          .toList(),
      notes: json['notes'] as String?,
    );
  }
}

class GearOptionPreset {
  const GearOptionPreset({
    required this.label,
    required this.teeth,
    required this.mainRatio,
    required this.tailRatio,
    this.isDefault = false,
  });

  final String label;
  final Map<String, int> teeth;
  final double mainRatio;
  final double tailRatio;
  final bool isDefault;

  factory GearOptionPreset.fromJson(Map<String, dynamic> json) {
    final rawTeeth = Map<String, dynamic>.from(json['teeth'] as Map);
    return GearOptionPreset(
      label: json['label'] as String,
      teeth: rawTeeth.map(
        (key, value) => MapEntry(key, (value as num).toInt()),
      ),
      mainRatio: (json['mainRatio'] as num).toDouble(),
      tailRatio: (json['tailRatio'] as num).toDouble(),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }
}

class PresetSource {
  const PresetSource({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  factory PresetSource.fromJson(Map<String, dynamic> json) {
    return PresetSource(
      title: json['title'] as String,
      url: json['url'] as String,
    );
  }
}
