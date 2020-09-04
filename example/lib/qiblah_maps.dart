import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_qiblah_example/loading_indicator.dart';
import 'package:flutter_qiblah_example/location_error_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QiblahMaps extends StatefulWidget {
  static final meccaLatLong = const LatLng(21.422487, 39.826206);
  final meccaMarker = Marker(
    markerId: MarkerId("mecca"),
    position: meccaLatLong,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    draggable: false,
  );

  @override
  _QiblahMapsState createState() => _QiblahMapsState();
}

class _QiblahMapsState extends State<QiblahMaps> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng position = LatLng(36.800636, 10.180358);

  Future<Position> _future;
  final _positionStream = StreamController<LatLng>.broadcast();


  @override
  void initState() {
    _future = _checkLocationStatus();
    super.initState();
  }

  @override
  void dispose() {
    _positionStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _future,
        builder: (_, AsyncSnapshot<Position> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return LoadingIndicator();
          if (snapshot.hasError)
            return LocationErrorWidget(
              error: snapshot.error.toString(),
            );

          if(snapshot.data != null) {
            final loc = LatLng(
                snapshot.data.latitude, snapshot.data.longitude);
            position = loc;
          } else
            _positionStream.sink.add(position);

          return StreamBuilder(
            stream: _positionStream.stream,
            builder: (_, AsyncSnapshot<LatLng> snapshot) => GoogleMap(
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              compassEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: position,
                zoom: 11,
              ),
              markers: Set<Marker>.of(
                <Marker>[
                  widget.meccaMarker,
                  Marker(
                    draggable: true,
                    markerId: MarkerId('Marker'),
                    position: position,
                    icon: BitmapDescriptor.defaultMarker,
                    onTap: _updateCamera,
                    onDragEnd: (LatLng value) {
                      position = value;
                      _positionStream.sink.add(value);
                    },
                    zIndex: 5,
                  ),
                ],
              ),
              circles: Set<Circle>.of([
                Circle(
                  circleId: CircleId("Circle"),
                  radius: 10,
                  center: position,
                  fillColor: Theme.of(context).primaryColorLight.withAlpha(100),
                  strokeWidth: 1,
                  strokeColor:
                      Theme.of(context).primaryColorDark.withAlpha(100),
                  zIndex: 3,
                )
              ]),
              polylines: Set<Polyline>.of([
                Polyline(
                  polylineId: PolylineId("Line"),
                  points: [position, QiblahMaps.meccaLatLong],
                  color: Theme.of(context).primaryColor,
                  width: 5,
                  zIndex: 4,
                )
              ]),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          );
        },
      ),
    );
  }

  Future<Position> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled) {
      return await getCurrentPosition();
    }
    return null;
  }

  void _updateCamera() async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 20));
  }
}
