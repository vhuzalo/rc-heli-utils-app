import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/unit_system.dart';
import '../application/angle_meter_controller.dart';
import '../domain/blade_angle_models.dart';
import '../domain/blade_angle_service.dart';

class BladeAngleScreen extends StatefulWidget {
  const BladeAngleScreen({super.key});

  @override
  State<BladeAngleScreen> createState() => _BladeAngleScreenState();
}

class _BladeAngleScreenState extends State<BladeAngleScreen> {
  final _service = BladeAngleService();
  final _meterController = AngleMeterController();
  final _radiusController = TextEditingController();
  final _angleController = TextEditingController();
  final _distanceController = TextEditingController();

  int _sectionIndex = 0;
  BladeAngleErrorCode? _errorCode;
  _CalcInputSource _lastEditedField = _CalcInputSource.angle;
  bool _isSyncingFields = false;
  String? _lastLoadedProfileId;

  @override
  void initState() {
    super.initState();
    _meterController.start();
    _radiusController.addListener(_handleRadiusChanged);
    _angleController.addListener(_handleAngleChanged);
    _distanceController.addListener(_handleDistanceChanged);
  }

  @override
  void dispose() {
    _radiusController.removeListener(_handleRadiusChanged);
    _angleController.removeListener(_handleAngleChanged);
    _distanceController.removeListener(_handleDistanceChanged);
    _radiusController.dispose();
    _angleController.dispose();
    _distanceController.dispose();
    _meterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          Expanded(
            child: _sectionIndex == 0
                ? SingleChildScrollView(
                    child: _buildCalculationSection(context),
                  )
                : _buildMeterSection(context),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: SegmentedButton<int>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity(horizontal: -1, vertical: -1),
                  ),
                  segments: [
                    ButtonSegment(
                      value: 0,
                      label: SizedBox(
                        width: double.infinity,
                        child: Text(
                          l10n.text('calcMode'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: SizedBox(
                        width: double.infinity,
                        child: Text(
                          l10n.text('meterMode'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  selected: {_sectionIndex},
                  onSelectionChanged: (selection) {
                    setState(() => _sectionIndex = selection.first);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationSection(BuildContext context) {
    final app = AppScope.of(context);
    final l10n = context.l10n;
    final unit = app.unitSystem;
    _syncRadiusFromSelectedProfile();

    return Column(
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
                _NumberField(
                  controller: _radiusController,
                  label: '${l10n.text('bladeLength')} (${unit.shortLabel})',
                ),
                const SizedBox(height: 12),
                _NumberField(
                  controller: _angleController,
                  label: '${l10n.text('targetAngle')} (°)',
                ),
                const SizedBox(height: 12),
                _NumberField(
                  controller: _distanceController,
                  label: '${l10n.text('tipDistance')} (${unit.shortLabel})',
                ),
                if (_errorCode != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _messageForError(context, _errorCode!),
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
      ],
    );
  }

  Widget _buildMeterSection(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return AnimatedBuilder(
      animation: _meterController,
      builder: (context, _) {
        final snapshot = _meterController.snapshot;
        final angleText = snapshot.relativeAngleDegrees == null
            ? '--'
            : '${snapshot.relativeAngleDegrees!.toStringAsFixed(1)}°';

        return SizedBox.expand(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(isLandscape ? 14 : 20),
              child: SizedBox(
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: isLandscape ? 420 : 260,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          angleText,
                          textAlign: TextAlign.center,
                          style: (isLandscape
                                  ? Theme.of(context).textTheme.displayLarge
                                  : Theme.of(context).textTheme.displayMedium)
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                        ),
                        SizedBox(height: isLandscape ? 20 : 32),
                        FilledButton.icon(
                          onPressed: _meterController.calibrateZero,
                          icon: const Icon(Icons.center_focus_strong),
                          label: Text(context.l10n.text('calibrateZero')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _syncRadiusFromSelectedProfile() {
    final app = AppScope.of(context);
    final profile = app.selectedProfile;

    if (profile == null || profile.bladeRadiusMm == null) {
      if (_lastLoadedProfileId == null) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _lastLoadedProfileId = null;
          _errorCode = null;
          _radiusController.clear();
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
        _errorCode = null;
        _radiusController.text =
            app.unitSystem.fromMillimeters(profile.bladeRadiusMm!).toStringAsFixed(1);
      });
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

    final radius = _parseValue(_radiusController.text);
    if (radius == null || radius <= 0) {
      setState(() => _errorCode = BladeAngleErrorCode.invalidRadius);
      return;
    }

    final updated = profile.copyWith(
      bladeRadiusMm: app.unitSystem.toMillimeters(radius),
      updatedAt: DateTime.now(),
    );
    await app.upsertProfile(updated);
    if (!mounted) {
      return;
    }
    _showMessage(context, l10n.text('savedToProfile'));
  }

  void _recalculate() {
    if (_isSyncingFields) {
      return;
    }
    final app = AppScope.of(context);
    final radius = _parseValue(_radiusController.text);
    final distance = _parseValue(_distanceController.text);
    final angle = _parseValue(_angleController.text);
    final activeValue = _lastEditedField == _CalcInputSource.distance
        ? distance
        : angle;

    if (radius == null || radius <= 0) {
      setState(
        () => _errorCode =
            radius == null ? null : BladeAngleErrorCode.invalidRadius,
      );
      return;
    }

    if (activeValue == null) {
      _isSyncingFields = true;
      setState(() {
        _errorCode = null;
        if (_lastEditedField == _CalcInputSource.distance) {
          _angleController.clear();
        } else {
          _distanceController.clear();
        }
      });
      _isSyncingFields = false;
      return;
    }

    try {
      _isSyncingFields = true;
      final result = _lastEditedField == _CalcInputSource.distance
          ? _service.calculate(
              BladeCalculationTarget.angle,
              BladeAngleCalcInput(
                bladeRadiusMm: app.unitSystem.toMillimeters(radius),
                tipDistanceMm: distance == null
                    ? null
                    : app.unitSystem.toMillimeters(distance),
              ),
            )
          : _service.calculate(
              BladeCalculationTarget.tipDistance,
              BladeAngleCalcInput(
                bladeRadiusMm: app.unitSystem.toMillimeters(radius),
                targetAngleDegrees: angle,
              ),
            );

      setState(() {
        _errorCode = null;
        if (_lastEditedField == _CalcInputSource.distance) {
          _angleController.text = result.angleDegrees.toStringAsFixed(1);
        } else {
          _distanceController.text = app.unitSystem
              .fromMillimeters(result.tipDistanceMm)
              .toStringAsFixed(1);
        }
      });
    } on BladeAngleException catch (error) {
      setState(() {
        _errorCode = error.code;
      });
    } finally {
      _isSyncingFields = false;
    }
  }

  void _handleRadiusChanged() {
    _recalculate();
  }

  void _handleAngleChanged() {
    if (_isSyncingFields) {
      return;
    }
    _lastEditedField = _CalcInputSource.angle;
    _recalculate();
  }

  void _handleDistanceChanged() {
    if (_isSyncingFields) {
      return;
    }
    _lastEditedField = _CalcInputSource.distance;
    _recalculate();
  }

  double? _parseValue(String text) {
    if (text.trim().isEmpty) {
      return null;
    }
    return double.tryParse(text.replaceAll(',', '.'));
  }

  String _messageForError(BuildContext context, BladeAngleErrorCode code) {
    final l10n = context.l10n;
    return switch (code) {
      BladeAngleErrorCode.invalidRadius => l10n.text('invalidRadius'),
      BladeAngleErrorCode.invalidAngle => l10n.text('invalidAngle'),
      BladeAngleErrorCode.invalidDistance => l10n.text('invalidDistance'),
      BladeAngleErrorCode.missingValue => l10n.text('missingValue'),
    };
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

enum _CalcInputSource { angle, distance }

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

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
    );
  }
}
