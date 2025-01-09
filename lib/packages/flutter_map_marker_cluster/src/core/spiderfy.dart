import 'dart:math';

class Spiderfy {
  static const double pi2 = pi * 2;
  static const int spiralFootSeparation = 28;
  static const int spiralLengthStart = 11;
  static const int spiralLengthFactor = 5;

  static const int circleStartAngle = 0;

  static List<Point<double>?> spiral(
      int distanceMultiplier, int count, Point<double> center) {
    num legLength = distanceMultiplier * spiralLengthStart;
    final int separation = distanceMultiplier * spiralFootSeparation;
    final double lengthFactor = distanceMultiplier * spiralLengthFactor * pi2;
    num angle = 0;

    final List<Point<double>?> result =
        List<Point<double>?>.filled(count, null, growable: false);

    // Higher index, closer position to cluster center.
    for (int i = count; i >= 0; i--) {
      // Skip the first position, so that we are already farther from center and we avoid
      // being under the default cluster icon (especially important for Circle Markers).
      if (i < count) {
        result[i] = Point<double>(center.x + legLength * cos(angle),
            center.y + legLength * sin(angle));
      }
      angle += separation / legLength + i * 0.0005;
      legLength += lengthFactor / angle;
    }
    return result;
  }

  static List<Point<double>?> circle(
      int radius, int count, Point<double> center) {
    final double angleStep = pi2 / count;

    return List<Point<double>>.generate(count, (int index) {
      final double angle = circleStartAngle + index * angleStep;

      return Point<double>(
          center.x + radius * cos(angle), center.y + radius * sin(angle));
    });
  }
}
