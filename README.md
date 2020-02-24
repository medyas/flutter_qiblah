# Flutter Qiblah

[![pub package](https://img.shields.io/pub/v/flutter_qiblah.svg)](https://pub.dev/packages/flutter_qiblah) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  

Flutter Qiblah is a plugin that allows you to display Qiblah direction in you app with support for both Android and iOS.

## Getting Started

This plugin depends on both [geolocator](https://pub.dev/packages/geolocator) and [flutter_compass](https://pub.dev/packages/flutter_compass). 
To use this plugin, add `flutter_compass` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:
```yaml
dependencies:
  flutter_qiblah: '^1.0.1'
```

## Features

* Check Device Sensor support (Android)
* Request Location permission
* Check GPS Status (Enabled and permission status)
* Receive Qiblah direction, North direction and Qiblah offset from North


## Setup

#### iOS
Make sure to add keys with appropriate descriptions to the `Info.plist` file.

* `<key>NSLocationAlwaysUsageDescription</key>`

  `<string>This app needs access to location when in the background.</string>`
  
*  `<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>`

   `<string>This app needs access to location when open and in the background.</string>`



#### Android
Make sure to add permissions to the `app/src/main/AndroidManifest.xml` file.

* `android.permission.INTERNET`
* `android.permission.ACCESS_COARSE_LOCATIO`
* `android.permission.ACCESS_FINE_LOCATION`

## API

Check the device sensor support. 
For Android, a check will be made to determine whether the device contains `Sensor.TYPE_ROTATION_VECTOR` and return `true` else `false`. 
In iOS, will directly return `true`. 

```dart
import 'package:flutter_qiblah/flutter_qiblah.dart';
final bool _deviceSupport = await FlutterQiblah.androidDeviceSensorSupport();
```

Request GPS Location permission

```dart
import 'package:flutter_qiblah/flutter_qiblah.dart';
final GeolocationStatus status = await FlutterQiblah.requestPermission();
```

Check GPS Location Status. Contains 

* `bool enabled`  
* `GeolocationStatus status {GeolocationStatus.granted, GeolocationStatus.denied, GeolocationStatus.disabled, GeolocationStatus.unknown}`

```dart
import 'package:flutter_qiblah/flutter_qiblah.dart';
final LocationStatus locationStatus = await FlutterQiblah.checkLocationStatus();
```

Qiblah Stream, returns a stream of QiblahDirection, containing: 

* `double qiblah`: The direction of Qiblah from North
* `double direction`: The direction of North
* `double offset`: The offset of Qiblah from North

```dart
import 'package:flutter_qiblah/flutter_qiblah.dart';
final Stream<QiblahDirection> _stream = FlutterQiblah.qiblahStream;
```

## Screens

Here is the Example app demo:

![Example app Demo](https://drive.google.com/uc?export=view&id=19nhSR_VUFczOIriDC2hHJ_nSzhQY8Mic)

Based on the LocationStatus class, you can add a check to see the current status of the GPS and display an error widget if it's disabled or permission is denied. 
check the :memo: [Example Code](https://github.com/medyas/flutter_qiblah/tree/master/example/)

![GPS Disabled](https://drive.google.com/uc?export=view&id=1vRB_GtFtK9sVCQIJqm3Tslsfy5hxQ6at)

For devices with no sensors, a Map can be displayed with the direction from the current/selected location to Mecca. 
check the :memo: [Example Code](https://github.com/medyas/flutter_qiblah/tree/master/example/)

![Qiblah with maps](https://drive.google.com/uc?export=view&id=1CeLQXEVYOO08EPDyl7ycOUvdRGoxrVjG)

## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/medyas/flutter_qiblah/issues) page.

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](CONTRIBUTING.md) and send us your [pull request](https://github.com/medyas/flutter_qiblah/pulls).