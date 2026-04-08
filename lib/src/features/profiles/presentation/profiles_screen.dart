import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/unit_system.dart';
import '../../gear_ratio/domain/gear_ratio_models.dart';
import '../data/model_preset_repository.dart';
import '../domain/heli_model_preset.dart';
import '../domain/heli_profile.dart';

class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showProfileEditor(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.text('addProfile')),
      ),
      body: app.profiles.isEmpty
          ? ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.text('noProfilesYet')),
                  ),
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              itemBuilder: (context, index) {
                final profile = app.profiles[index];
                return _ProfileCard(profile: profile);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: app.profiles.length,
            ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile});

  final HeliProfile profile;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final l10n = context.l10n;
    final isSelected = profile.id == app.selectedProfileId;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      if (profile.model.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(profile.model),
                      ],
                    ],
                  ),
                ),
                Radio<String>(
                  value: profile.id,
                  groupValue: app.selectedProfileId,
                  onChanged: (value) {
                    app.selectProfile(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoPill(
                  label: l10n.text('profileBladeLength'),
                  value: profile.bladeRadiusMm == null
                      ? '-'
                      : '${profile.preferredUnitSystem.fromMillimeters(profile.bladeRadiusMm!).toStringAsFixed(1)} ${profile.preferredUnitSystem.shortLabel}',
                ),
                _InfoPill(
                  label: l10n.text('gearType'),
                  value: _gearTypeLabel(l10n, profile.gearTrainType),
                ),
                _InfoPill(
                  label: l10n.text('lastCalibration'),
                  value: profile.lastAngleCalibration == null
                      ? '-'
                      : '${profile.lastAngleCalibration!.zeroDegrees.toStringAsFixed(1)}°',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (!isSelected)
                  OutlinedButton(
                    onPressed: () => app.selectProfile(profile.id),
                    child: Text(l10n.text('chooseProfile')),
                  )
                else
                  OutlinedButton(
                    onPressed: () {},
                    child: Text(l10n.text('selectedProfile')),
                  ),
                const Spacer(),
                IconButton(
                  onPressed: () => showProfileEditor(context, profile: profile),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, profile.id),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, String profileId) async {
    final app = AppScope.of(context);
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Text(l10n.text('deleteConfirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.text('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.text('deleteProfile')),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await app.deleteProfile(profileId);
    }
  }

  String _gearTypeLabel(AppLocalizations l10n, GearTrainType? type) {
    return switch (type) {
      GearTrainType.singleStage => l10n.text('singleStage'),
      GearTrainType.twoStageType1 => l10n.text('type1'),
      GearTrainType.twoStageType2 => l10n.text('type2'),
      GearTrainType.twoStageType3 => l10n.text('type3'),
      null => '-',
    };
  }
}

Future<void> showProfileEditor(
  BuildContext context, {
  HeliProfile? profile,
}) async {
  final app = AppScope.of(context);
  final result = await showDialog<_ProfileEditorResult>(
    context: context,
    builder: (_) => _ProfileEditorDialog(profile: profile),
  );

  if (result == null) {
    return;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    switch (result.action) {
      case _ProfileEditorAction.save:
        if (result.profile != null) {
          app.upsertProfile(result.profile!);
        }
      case _ProfileEditorAction.delete:
        if (profile != null) {
          app.deleteProfile(profile.id);
        }
    }
  });
}

enum _ProfileEditorAction { save, delete }

class _ProfileEditorResult {
  const _ProfileEditorResult.save(this.profile)
      : action = _ProfileEditorAction.save;

  const _ProfileEditorResult.delete()
      : action = _ProfileEditorAction.delete,
        profile = null;

  final _ProfileEditorAction action;
  final HeliProfile? profile;
}

class _ProfileEditorDialog extends StatefulWidget {
  const _ProfileEditorDialog({this.profile});

  final HeliProfile? profile;

  @override
  State<_ProfileEditorDialog> createState() => _ProfileEditorDialogState();
}

class _ProfileEditorDialogState extends State<_ProfileEditorDialog> {
  final _presetRepository = const ModelPresetRepository();
  final _nameController = TextEditingController();
  final _bladeController = TextEditingController();

  List<HeliModelPreset> _presets = const [];
  String? _presetBrand;
  HeliModelPreset? _selectedPreset;
  GearOptionPreset? _selectedGearOption;
  bool _didInitialize = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitialize) {
      return;
    }
    _didInitialize = true;

    final profile = widget.profile;
    _nameController.text = profile?.name ?? '';
    _bladeController.text = profile?.bladeRadiusMm == null
        ? ''
        : UnitSystem.metric
            .fromMillimeters(profile!.bladeRadiusMm!)
            .toStringAsFixed(1);

    _loadPresets();
  }

  Future<void> _loadPresets() async {
    final presets = await _presetRepository.loadPresets();
    if (!mounted) {
      return;
    }

    final profile = widget.profile;
    final selectedPreset = _findPresetFromProfile(presets, profile);
    setState(() {
      _presets = presets;
      _presetBrand = _extractPresetBrand(presets, profile?.model, profile?.name);
      _selectedPreset = selectedPreset;
      _selectedGearOption =
          _findGearOptionFromProfile(selectedPreset, profile) ??
              selectedPreset?.defaultGearOption;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bladeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: _presetBrand,
              decoration: InputDecoration(labelText: l10n.text('brand')),
              items: [
                for (final brand in _brandsFromPresets(_presets))
                  DropdownMenuItem(
                    value: brand,
                    child: Text(brand),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _presetBrand = value;
                  _selectedPreset = null;
                  _selectedGearOption = null;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedPreset?.id,
              decoration: InputDecoration(labelText: l10n.text('presetModel')),
              items: [
                for (final item in _presetsForBrand(_presets, _presetBrand))
                  DropdownMenuItem(
                    value: item.id,
                    child: Text(
                      '${item.model} ${item.variant} (${item.classSize})',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPreset = _presets.firstWhere((item) => item.id == value);
                  _selectedGearOption = _selectedPreset!.defaultGearOption;
                  _nameController.text = _buildPresetLabel(_selectedPreset!);
                  if (_selectedPreset!.mainBladeRangeMm.length == 2) {
                    final averageBlade =
                        (_selectedPreset!.mainBladeRangeMm.first +
                                _selectedPreset!.mainBladeRangeMm.last) /
                            2;
                    _bladeController.text = averageBlade.toStringAsFixed(0);
                  }
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: _selectedGearOption?.label,
              decoration: InputDecoration(labelText: l10n.text('gearPreset')),
              items: [
                for (final option in _selectedPreset?.gearOptions ?? const [])
                  DropdownMenuItem(
                    value: option.label,
                    child: Text(
                      '${option.label} | ${option.teeth['Z1']}T/${option.teeth['Z2']}T',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
              ],
              onChanged: _selectedPreset == null
                  ? null
                  : (value) {
                      setState(() {
                        _selectedGearOption =
                            _selectedPreset!.gearOptions.firstWhere(
                          (item) => item.label == value,
                        );
                      });
                    },
            ),
            if (_selectedPreset != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _presetSummary(context, _selectedPreset!, _selectedGearOption),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.text('name')),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bladeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText:
                    '${l10n.text('profileBladeLength')} (${UnitSystem.metric.shortLabel})',
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.profile != null)
          TextButton(
            onPressed: _delete,
            child: Text(l10n.text('deleteProfile')),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.text('cancel')),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(l10n.text('save')),
        ),
      ],
    );
  }

  void _delete() {
    Navigator.of(context).pop(const _ProfileEditorResult.delete());
  }

  void _save() {
    final bladeValue = double.tryParse(_bladeController.text.replaceAll(',', '.'));
    final profile = widget.profile;
    final inferredModel =
        _selectedPreset == null ? profile?.model ?? '' : _buildPresetLabel(_selectedPreset!);
    final next = (profile ??
            HeliProfile(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              name: '',
              model: '',
              preferredUnitSystem: UnitSystem.metric,
              updatedAt: DateTime.now(),
            ))
        .copyWith(
      name: _nameController.text.trim().isEmpty ? 'Heli' : _nameController.text.trim(),
      model: inferredModel,
      preferredUnitSystem: UnitSystem.metric,
      gearTrainType: _selectedPreset?.gearTrainType ?? profile?.gearTrainType,
      gearTeeth: _selectedGearOption?.teeth ?? profile?.gearTeeth ?? const {},
      bladeRadiusMm: bladeValue == null || bladeValue <= 0
          ? profile?.bladeRadiusMm
          : UnitSystem.metric.toMillimeters(bladeValue),
      updatedAt: DateTime.now(),
    );
    Navigator.of(context).pop(_ProfileEditorResult.save(next));
  }
}

String? _extractPresetBrand(
  List<HeliModelPreset> presets,
  String? model,
  String? name,
) {
  final source = '${model ?? ''} ${name ?? ''}'.toLowerCase();
  for (final preset in presets) {
    if (source.contains(preset.brand.toLowerCase())) {
      return preset.brand;
    }
  }
  return null;
}

List<String> _brandsFromPresets(List<HeliModelPreset> presets) {
  final items = presets.map((item) => item.brand).toSet().toList()..sort();
  return items;
}

List<HeliModelPreset> _presetsForBrand(
  List<HeliModelPreset> presets,
  String? brand,
) {
  if (brand == null) {
    return const [];
  }
  final items = presets.where((item) => item.brand == brand).toList()
    ..sort((a, b) => b.classSize.compareTo(a.classSize));
  return items;
}

HeliModelPreset? _findPresetFromProfile(
  List<HeliModelPreset> presets,
  HeliProfile? profile,
) {
  if (profile == null) {
    return null;
  }
  final source = '${profile.name} ${profile.model}'.toLowerCase();
  for (final preset in presets) {
    final matchesBrand = source.contains(preset.brand.toLowerCase());
    final matchesModel = source.contains(preset.model.toLowerCase());
    if (matchesBrand && matchesModel) {
      return preset;
    }
  }
  return null;
}

String _buildPresetLabel(HeliModelPreset preset) {
  return '${preset.brand} ${preset.model} ${preset.variant}'.trim();
}

GearOptionPreset? _findGearOptionFromProfile(
  HeliModelPreset? preset,
  HeliProfile? profile,
) {
  if (preset == null || profile == null || profile.gearTeeth.isEmpty) {
    return null;
  }
  for (final option in preset.gearOptions) {
    if (_sameTeeth(option.teeth, profile.gearTeeth)) {
      return option;
    }
  }
  return null;
}

bool _sameTeeth(Map<String, int> left, Map<String, int> right) {
  if (left.length != right.length) {
    return false;
  }
  for (final entry in left.entries) {
    if (right[entry.key] != entry.value) {
      return false;
    }
  }
  return true;
}

String _presetSummary(
  BuildContext context,
  HeliModelPreset preset,
  GearOptionPreset? gearOption,
) {
  final l10n = context.l10n;
  final bladeRange = preset.mainBladeRangeMm.length == 2
      ? '${preset.mainBladeRangeMm.first}-${preset.mainBladeRangeMm.last} mm'
      : '-';
  final ratio = gearOption == null
      ? '-'
      : '${l10n.text('mainRatio')}: ${gearOption.mainRatio.toStringAsFixed(3)} | ${l10n.text('tailRatio')}: ${gearOption.tailRatio.toStringAsFixed(3)}';
  return '${l10n.text('heliClass')}: ${preset.classSize} | ${l10n.text('bladeLength')}: $bladeRange | $ratio';
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
