import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../core/localization/app_localizations.dart';
import '../../profiles/domain/heli_profile.dart';
import '../domain/gear_ratio_models.dart';
import '../domain/gear_ratio_service.dart';

class GearRatioScreen extends StatefulWidget {
  const GearRatioScreen({super.key});

  @override
  State<GearRatioScreen> createState() => _GearRatioScreenState();
}

class _GearRatioScreenState extends State<GearRatioScreen> {
  final _service = GearRatioService();
  final _controllers = <String, TextEditingController>{
    for (final key in ['Z1', 'Z2', 'Z3', 'Z4', 'Z5', 'Z6', 'Z7'])
      key: TextEditingController(),
  };

  GearTrainType _type = GearTrainType.singleStage;
  GearRatioResult? _result;
  bool _hasInputError = false;
  String? _lastLoadedProfileId;

  @override
  void initState() {
    super.initState();
    for (final controller in _controllers.values) {
      controller.addListener(_calculateFromFields);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.removeListener(_calculateFromFields);
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final l10n = context.l10n;
    final requiredKeys = _service.requiredKeysFor(_type);
    final fieldRows = _buildFieldRows(requiredKeys);
    _syncFromSelectedProfile();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _SelectedProfileCard(
          profileName: app.selectedProfile?.name,
          profileModel: app.selectedProfile?.model,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<GearTrainType>(
                        value: _type,
                        decoration:
                            InputDecoration(labelText: l10n.text('gearType')),
                        items: [
                          DropdownMenuItem(
                            value: GearTrainType.singleStage,
                            child: Text(
                              _labelForType(l10n, GearTrainType.singleStage),
                            ),
                          ),
                          DropdownMenuItem(
                            value: GearTrainType.twoStageType1,
                            child: Text(
                              _labelForType(l10n, GearTrainType.twoStageType1),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _type = value;
                            _result = null;
                            _hasInputError = false;
                            _clearUnusedControllers();
                          });
                          _calculateFromFields();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...fieldRows.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildToothField(row.first)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: row.length > 1
                              ? _buildToothField(row[1])
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_hasInputError) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.text('invalidTeeth'),
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    tooltip: l10n.text('save'),
                    onPressed: () => _saveSelectedProfile(context),
                    icon: const Icon(Icons.save_outlined),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_result != null) ...[
          const SizedBox(height: 16),
          _ResultCard(result: _result!),
        ],
      ],
    );
  }

  void _calculateFromFields() {
    final teeth = <String, int>{};
    final requiredKeys = _service.requiredKeysFor(_type);

    var hasAnyValue = false;
    for (final key in requiredKeys) {
      final text = _controllers[key]!.text.trim();
      if (text.isNotEmpty) {
        hasAnyValue = true;
      }
      final value = int.tryParse(text);
      if (text.isEmpty) {
        setState(() {
          _hasInputError = false;
          _result = hasAnyValue ? null : null;
        });
        return;
      }
      if (value == null || value <= 0) {
        setState(() {
          _hasInputError = true;
          _result = null;
        });
        return;
      }
      teeth[key] = value;
    }

    final result = _service.calculate(GearRatioInput(type: _type, teeth: teeth));
    setState(() {
      _hasInputError = false;
      _result = result;
    });
  }

  void _syncFromSelectedProfile() {
    final app = AppScope.of(context);
    final profile = app.selectedProfile;

    if (profile == null || profile.gearTrainType == null) {
      if (_lastLoadedProfileId == null) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _lastLoadedProfileId = null;
          _type = GearTrainType.singleStage;
          _hasInputError = false;
          _result = null;
          for (final controller in _controllers.values) {
            controller.clear();
          }
        });
      });
      return;
    }

    if (profile.id == _lastLoadedProfileId) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _lastLoadedProfileId = profile.id;
        _type = profile.gearTrainType == GearTrainType.singleStage
            ? GearTrainType.singleStage
            : GearTrainType.twoStageType1;
        for (final controller in _controllers.values) {
          controller.clear();
        }
        for (final entry in profile.gearTeeth.entries) {
          _controllers[entry.key]?.text = entry.value.toString();
        }
      });
      _calculateFromFields();
    });
  }

  Future<void> _saveSelectedProfile(BuildContext context) async {
    final app = AppScope.of(context);
    final l10n = context.l10n;
    final profile = app.selectedProfile;

    if (profile == null) {
      _showMessage(context, l10n.text('selectProfileFirst'));
      return;
    }

    final teeth = <String, int>{};
    final requiredKeys = _service.requiredKeysFor(_type);
    for (final key in requiredKeys) {
      final value = int.tryParse(_controllers[key]!.text.trim());
      if (value == null || value <= 0) {
        setState(() => _hasInputError = true);
        return;
      }
      teeth[key] = value;
    }

    final updated = _mergeProfile(
      profile,
      gearTrainType: _type,
      gearTeeth: teeth,
    );
    await app.upsertProfile(updated);
    if (!mounted) {
      return;
    }
    _showMessage(context, l10n.text('savedToProfile'));
  }

  HeliProfile _mergeProfile(
    HeliProfile profile, {
    required GearTrainType gearTrainType,
    required Map<String, int> gearTeeth,
  }) {
    return profile.copyWith(
      gearTrainType: gearTrainType,
      gearTeeth: gearTeeth,
      updatedAt: DateTime.now(),
    );
  }

  String _labelForType(AppLocalizations l10n, GearTrainType type) {
    return switch (type) {
      GearTrainType.singleStage => l10n.text('singleStage'),
      GearTrainType.twoStageType1 => l10n.text('type1'),
      GearTrainType.twoStageType2 => l10n.text('type1'),
      GearTrainType.twoStageType3 => l10n.text('type1'),
    };
  }

  String _hintForField(GearTrainType type, String key) {
    return switch (type) {
      GearTrainType.singleStage => switch (key) {
          'Z1' => 'Motor pinion',
          'Z2' => 'main',
          'Z3' => 'front',
          'Z4' => 'tail',
          _ => '',
        },
      GearTrainType.twoStageType1 ||
      GearTrainType.twoStageType2 ||
      GearTrainType.twoStageType3 => switch (key) {
          'Z1' => 'Motor pinion',
          'Z6' => 'Tail shaft',
          _ => 'teeth',
        }
    };
  }

  List<List<String>> _buildFieldRows(List<String> keys) {
    final rows = <List<String>>[];
    for (var index = 0; index < keys.length; index += 2) {
      final row = <String>[keys[index]];
      if (index + 1 < keys.length) {
        row.add(keys[index + 1]);
      }
      rows.add(row);
    }
    return rows;
  }

  Widget _buildToothField(String key) {
    return TextField(
      controller: _controllers[key],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: '$key - ${_hintForField(_type, key)}',
      ),
    );
  }

  void _clearUnusedControllers() {
    final usedKeys = _service.requiredKeysFor(_type).toSet();
    for (final entry in _controllers.entries) {
      if (!usedKeys.contains(entry.key)) {
        entry.value.clear();
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _SelectedProfileCard extends StatelessWidget {
  const _SelectedProfileCard({
    required this.profileName,
    required this.profileModel,
  });

  final String? profileName;
  final String? profileModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.dns_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileName ?? l10n.text('selectedProfileNone'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  if (profileModel != null && profileModel!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(profileModel!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final GearRatioResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.text('result'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricTile(
                  label: l10n.text('mainRatio'),
                  value: '${result.mainRatio.toStringAsFixed(2)} : 1',
                ),
                _MetricTile(
                  label: l10n.text('tailRatio'),
                  value: '${result.tailRatio.toStringAsFixed(2)} : 1',
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              l10n.text('rotorflightFields'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _FieldLine(label: l10n.text('motorPinion'), value: result.motorPinion),
            _FieldLine(label: l10n.text('mainGear'), value: result.mainGear),
            _FieldLine(label: l10n.text('tailPulley'), value: result.tailPulley),
            _FieldLine(label: l10n.text('frontPulley'), value: result.frontPulley),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _FieldLine extends StatelessWidget {
  const _FieldLine({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
