# Flutter Qiblah

[![pub package](https://img.shields.io/pub/v/flutter_qiblah.svg)](https://pub.dev/packages/flutter_qiblah) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  



## Getting Started

To start using this package, add `flutter_qiblah` dependency to your `pubspec.yaml`

```yaml
dependencies:
  flutter_qiblah: '<latest_release>'
```

## Features

* Check Device Sensor support (Android)
* Request Location permission
* Check GPS Status (Enabled and permission status)
* Receive Qiblah direction, North direction and Qiblah offset from North


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