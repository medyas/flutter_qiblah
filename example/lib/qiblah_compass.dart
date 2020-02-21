import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah_example/loading_indicator.dart';
import 'package:flutter_qiblah_example/location_error_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' show pi;

class QiblahCompass extends StatefulWidget {
  @override
  _QiblahCompassState createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {
  final _locationStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  get stream => _locationStreamController.stream;

  @override
  void initState() {
    _checkLocationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return LoadingIndicator();
          if (snapshot.data["enabled"] == true) {
            switch (snapshot.data["status"] as GeolocationStatus) {
              case GeolocationStatus.granted:
                return QiblahCompassWidget();

              case GeolocationStatus.denied:
                return LocationErrorWidget(
                  error: "Location service permission denied",
                  callback: _checkLocationStatus,
                );
              case GeolocationStatus.disabled:
                return LocationErrorWidget(
                  error: "Location service disabled",
                  callback: _checkLocationStatus,
                );
              case GeolocationStatus.unknown:
                return LocationErrorWidget(
                  error: "Unknown Location service error",
                  callback: _checkLocationStatus,
                );
              default:
                return Container();
            }
          } else {
            return LocationErrorWidget(
              error: "Please enable Location service",
              callback: _checkLocationStatus,
            );
          }
        },
      ),
    );
  }

  Future<void> _checkLocationStatus() async {
    final status = await FlutterQiblah.checkLocationStatus();
    if (status["enabled"] && status["status"] == GeolocationStatus.denied) {
      await FlutterQiblah.requestPermission();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else
      _locationStreamController.sink.add(status);
  }

  @override
  void dispose() {
    _locationStreamController.close();
    super.dispose();
  }
}

class QiblahCompassWidget extends StatelessWidget {
  final _compassSvg = SvgPicture.asset('assets/compass.svg');
  final _needleSvg = SvgPicture.asset(
    'assets/needle.svg',
    fit: BoxFit.contain,
    height: 300,
    alignment: Alignment.center,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahstream,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LoadingIndicator();

        final direction = snapshot.data["direction"] as double;
        final qiblah = snapshot.data["qiblah"] as double;
        final offset = snapshot.data["offset"] as double;

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: ((direction ?? 0) * (pi / 180) * -1),
              child: _compassSvg,
            ),
            Transform.rotate(
              angle: ((qiblah ?? 0) * (pi / 180) * -1),
              alignment: Alignment.center,
              child: _needleSvg,
            ),
            Positioned(
              bottom: 8,
              child: Text("${offset.toStringAsFixed(3)}°"),
            )
          ],
        );
      },
    );
  }
}
