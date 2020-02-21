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

  Stream<Map<String, dynamic>> _qiblahStream;

  FlutterQiblah._();

  factory FlutterQiblah() {
    return _instance;
  }

  /// Check Android device sensor support
  static Future<bool> androidDeviceSensorSupport() async {
    if (Platform.isAndroid)
      return await _channel.invokeMethod("androidSupportSensor");
    else
      return true;
  }

  static Future<void> requestPermission() async {
    await Geolocator().getCurrentPosition();
    await Geolocator().checkGeolocationPermissionStatus();
  }

  /// get location status: GPS enabled and the permission status with GeolocationStatus
  static Future<Map<String, dynamic>> checkLocationStatus() async {
    final status = await Geolocator().checkGeolocationPermissionStatus();
    final enabled = await Geolocator().isLocationServiceEnabled();
    return {"status": status, "enabled": enabled};
  }

  /// Provides a stream of Map with current compass and Qiblah direction
  /// {"qiblah": QIBLAH, "direction": DIRECTION}
  /// Direction varies from 0-360, 0 being north.
  /// Qiblah varies from 0-360, offset from direction(North)
  static Stream<Map<String, dynamic>> get qiblahstream {
    if (_instance._qiblahStream == null) {
      final locationOptions = LocationOptions(accuracy: LocationAccuracy.best);
      _instance._qiblahStream = _merge<double, Position>(FlutterCompass.events,
          Geolocator().getPositionStream(locationOptions));
    }

    return _instance._qiblahStream;
  }

  /// Merge the compass stream with location updates, and calculate the Qiblah direction
  /// return a Stream<Map<String, dynamic>> containing compass and Qiblah direction
  /// Direction varies from 0-360, 0 being north.
  /// Qiblah varies from 0-360, offset from direction(North)
  static Stream<Map<String, dynamic>> _merge<A, B>(
      Stream<A> streamA, Stream<B> streamB) {
    return streamA.combineLatest<B, Map<String, dynamic>>(streamB, (dir, pos) {
      final position = pos as Position;
      final direction = dir as double;

      // Calculate the Qiblah offset to North
      final offSet =
          Utils.getOffsetFromNorth(position.latitude, position.longitude);

      // Adjust Qiblah direction based on North direction
      final qiblah = direction + (360 - offSet);

      return {"qiblah": qiblah, "direction": direction, "offset": offSet};
    });
  }
}
