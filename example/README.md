# Flutter Qiblah example

Demonstrates how to use the flutter_qiblah plugin.

To run the full example, you have to add Google Maps keys. Checkout the setup in the [Google Maps Plugin](https://pub.dev/packages/google_maps_flutter)

## Usage


<img src="https://drive.google.com/uc?export=view&id=19nhSR_VUFczOIriDC2hHJ_nSzhQY8Mic" width="300px"> <img src="https://drive.google.com/uc?export=view&id=1vRB_GtFtK9sVCQIJqm3Tslsfy5hxQ6at" width="300px"> <img src="https://drive.google.com/uc?export=view&id=1CeLQXEVYOO08EPDyl7ycOUvdRGoxrVjG" width="300px">

The checkout the full example :memo: [Example Code](https://github.com/medyas/flutter_qiblah/tree/master/example/) 

```dart

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff0c7b93),
        primaryColorLight: Color(0xff00a8cc),
        primaryColorDark: Color(0xff27496d),
        accentColor: Color(0xffecce6d),
      ),
      darkTheme: ThemeData.dark().copyWith(accentColor: Color(0xffecce6d)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureBuilder(
          future: _deviceSupport,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return LoadingIndicator();
            if (snapshot.hasError)
              return Center(
                child: Text("Error: ${snapshot.error.toString()}"),
              );

            if (snapshot.data)
              // Device supports the Sensor, Display Compass widget
              return QiblahCompass();
            else
              // Device does not support the sensor, Display Maps widget
              return QiblahMaps();
          },
        ),
      ),
    );
  }
}
```

### Qiblah Compass example

```dart
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
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LoadingIndicator();

        final qiblahDirection = snapshot.data;

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Transform.rotate(
              angle: ((qiblahDirection.direction ?? 0) * (pi / 180) * -1),
              child: _compassSvg,
            ),
            Transform.rotate(
              angle: ((qiblahDirection.qiblah ?? 0) * (pi / 180) * -1),
              alignment: Alignment.center,
              child: _needleSvg,
            ),
            Positioned(
              bottom: 8,
              child: Text("${qiblahDirection.offset.toStringAsFixed(3)}°"),
            )
          ],
        );
      },
    );
  }
}
```

### Qiblah Maps example

```dart
  StreamBuilder(
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
```
