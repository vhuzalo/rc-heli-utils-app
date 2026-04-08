import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../domain/blade_angle_models.dart';

class AngleMeasurementSnapshot {
  const AngleMeasurementSnapshot({
    required this.axis,
    required this.stability,
    this.rawAngleDegrees,
    this.relativeAngleDegrees,
    this.calibration,
    this.hasSamples = false,
    this.sensorAvailable = true,
  });

  final MeasurementAxis axis;
  final double stability;
  final double? rawAngleDegrees;
  final double? relativeAngleDegrees;
  final AngleMeasurementCalibration? calibration;
  final bool hasSamples;
  final bool sensorAvailable;

  AngleMeasurementSnapshot copyWith({
    MeasurementAxis? axis,
    double? stability,
    Object? rawAngleDegrees = _meterSentinel,
    Object? relativeAngleDegrees = _meterSentinel,
    Object? calibration = _meterSentinel,
    bool? hasSamples,
    bool? sensorAvailable,
  }) {
    return AngleMeasurementSnapshot(
      axis: axis ?? this.axis,
      stability: stability ?? this.stability,
      rawAngleDegrees: identical(rawAngleDegrees, _meterSentinel)
          ? this.rawAngleDegrees
          : rawAngleDegrees as double?,
      relativeAngleDegrees: identical(relativeAngleDegrees, _meterSentinel)
          ? this.relativeAngleDegrees
          : relativeAngleDegrees as double?,
      calibration: identical(calibration, _meterSentinel)
          ? this.calibration
          : calibration as AngleMeasurementCalibration?,
      hasSamples: hasSamples ?? this.hasSamples,
      sensorAvailable: sensorAvailable ?? this.sensorAvailable,
    );
  }
}

class AngleMeterController extends ChangeNotifier {
  AngleMeasurementSnapshot snapshot = const AngleMeasurementSnapshot(
    axis: MeasurementAxis.longitudinal,
    stability: 0,
  );

  StreamSubscription<AccelerometerEvent>? _subscription;
  double? _smoothedAngle;
  double? _lastRawAngle;

  Future<void> start() async {
    if (_subscription != null) {
      return;
    }

    _subscription = accelerometerEvents.listen(
      _onEvent,
      onError: (_) {
        snapshot = snapshot.copyWith(sensorAvailable: false);
        notifyListeners();
      },
    );
  }

  void _onEvent(AccelerometerEvent event) {
    final rawAngle = _resolveAngle(event);
    _smoothedAngle = _smoothedAngle == null
        ? rawAngle
        : (_smoothedAngle! * 0.85) + (rawAngle * 0.15);
    final delta = (rawAngle - (_lastRawAngle ?? rawAngle)).abs();
    _lastRawAngle = rawAngle;
    final stability = (1 - (delta / 4)).clamp(0.0, 1.0).toDouble();
    final calibration = snapshot.calibration;

    snapshot = snapshot.copyWith(
      sensorAvailable: true,
      hasSamples: true,
      stability: stability,
      rawAngleDegrees: _smoothedAngle,
      relativeAngleDegrees: calibration == null
          ? _smoothedAngle
          : _smoothedAngle! - calibration.zeroDegrees,
    );
    notifyListeners();
  }

  double _resolveAngle(AccelerometerEvent event) {
    return math.atan2(
          event.y,
          math.sqrt((event.x * event.x) + (event.z * event.z)),
        ) *
        180 /
        math.pi;
  }

  void calibrateZero() {
    final rawAngle = snapshot.rawAngleDegrees;
    if (rawAngle == null) {
      return;
    }
    final calibration = AngleMeasurementCalibration(
      zeroDegrees: rawAngle,
      axis: snapshot.axis,
    );
    snapshot = snapshot.copyWith(
      calibration: calibration,
      relativeAngleDegrees: 0.0,
    );
    notifyListeners();
  }

  void clearCalibration() {
    snapshot = snapshot.copyWith(
      calibration: null,
      relativeAngleDegrees: snapshot.rawAngleDegrees,
    );
    notifyListeners();
  }
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

const _meterSentinel = Object();
