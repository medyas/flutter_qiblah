import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_qiblah/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stream_transform/stream_transform.dart' show CombineLatest;

/// [FlutterQiblah] is a singleton class that provides assess to compass events,
/// check for sensor support in Android
/// Get current  location
/// Get Qiblah direction
class FlutterQiblah {
  static const MethodChannel _channel =
      const MethodChannel('ml.medyas.flutter_qiblah');

  static final FlutterQiblah _instance = FlutterQiblah._();

  Stream<QiblahDirection>? _qiblahStream;

  FlutterQiblah._();

  factory FlutterQiblah() => _instance;

  /// Check Android device sensor support
  static Future<bool?> androidDeviceSensorSupport() async {
    if (Platform.isAndroid)
      return await _channel.invokeMethod("androidSupportSensor");
    else
      return true;
  }

  /// Request Location permission, return GeolocationStatus object
  static Future<LocationPermission> requestPermissions() =>
      Geolocator.requestPermission();

  /// get location status: GPS enabled and the permission status with GeolocationStatus
  static Future<LocationStatus> checkLocationStatus() async {
    final status = await Geolocator.checkPermission();
    final enabled = await Geolocator.isLocationServiceEnabled();
    return LocationStatus(enabled, status);
  }

  /// Provides a stream of Map with current compass and Qiblah direction
  /// {"qiblah": QIBLAH, "direction": DIRECTION}
  /// Direction varies from 0-360, 0 being north.
  /// Qiblah varies from 0-360, offset from direction(North)
  static Stream<QiblahDirection> get qiblahStream {
    if (_instance._qiblahStream == null) {
      _instance._qiblahStream = _merge<CompassEvent, Position>(
        FlutterCompass.events!,
        Geolocator.getPositionStream(),
      );
    }

    return _instance._qiblahStream!;
  }

  /// Merge the compass stream with location updates, and calculate the Qiblah direction
  /// return a Stream<Map<String, dynamic>> containing compass and Qiblah direction
  /// Direction varies from 0-360, 0 being north.
  /// Qiblah varies from 0-360, offset from direction(North)
  static Stream<QiblahDirection> _merge<A, B>(
    Stream<A> streamA,
    Stream<B> streamB,
  ) =>
      streamA.combineLatest<B, QiblahDirection>(
        streamB,
        (dir, pos) {
          final position = pos as Position;
          final event = dir as CompassEvent;

          // Calculate the Qiblah offset to North
          final offSet =
              Utils.getOffsetFromNorth(position.latitude, position.longitude);

          // Adjust Qiblah direction based on North direction
          final qiblah = (event.heading ?? 0.0) + (360 - offSet);

          return QiblahDirection(qiblah, event.heading ?? 0.0, offSet);
        },
      );

  /// Close compass stream, and set Qiblah stream to null
  Future<void> dispose() async {
    _qiblahStream = null;
  }
}

/// Location Status class, contains the GPS status(Enabled or not) and GeolocationStatus
class LocationStatus {
  final bool enabled;
  final LocationPermission status;

  const LocationStatus(
    this.enabled,
    this.status,
  );
}

/// Containing Qiblah, Direction and offset
class QiblahDirection {
  final double qiblah;
  final double direction;
  final double offset;

  const QiblahDirection(
    this.qiblah,
    this.direction,
    this.offset,
  );
}
