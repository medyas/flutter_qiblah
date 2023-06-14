import 'dart:math' show sin, cos, tan, atan;
import 'package:vector_math/vector_math.dart' show radians, degrees;

class Utils {
  Utils._();

  static final _deLa = radians(21.422487);
  static final _deLo = radians(39.826206);

  static double getOffsetFromNorth(
    double currentLatitude,
    double currentLongitude,
  ) {
    var laRad = radians(currentLatitude);
    var loRad = radians(currentLongitude);

    var toDegrees = degrees(atan(sin(_deLo - loRad) /
        ((cos(laRad) * tan(_deLa)) - (sin(laRad) * cos(_deLo - loRad)))));
    if (laRad > _deLa) {
      if ((loRad > _deLo || loRad < radians(-180.0) + _deLo) &&
          toDegrees > 0.0 &&
          toDegrees <= 90.0) {
        toDegrees += 180.0;
      } else if (loRad <= _deLo &&
          loRad >= radians(-180.0) + _deLo &&
          toDegrees > -90.0 &&
          toDegrees < 0.0) {
        toDegrees += 180.0;
      }
    }
    if (laRad < _deLa) {
      if ((loRad > _deLo || loRad < radians(-180.0) + _deLo) &&
          toDegrees > 0.0 &&
          toDegrees < 90.0) {
        toDegrees += 180.0;
      }
      if (loRad <= _deLo &&
          loRad >= radians(-180.0) + _deLo &&
          toDegrees > -90.0 &&
          toDegrees <= 0.0) {
        toDegrees += 180.0;
      }
    }
    return toDegrees;
  }
}
