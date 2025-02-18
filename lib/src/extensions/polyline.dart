import 'package:flutter_map/flutter_map.dart';
import 'package:power_geojson/power_geojson.dart';

extension PolylineXX on List<List<double>> {
  /// Converts a list coords of a Polyline into a [Polyline]
  Polyline<T> toPolyline<T extends Object>({PolylineProperties<T>? polylineProperties}) {
    PolylineProperties<T> poly = polylineProperties ?? PolylineProperties<T>();
    Polyline<T> polyline = Polyline<T>(
      points: toLatLng(),
      colorsStop: poly.colorsStop,
      gradientColors: poly.gradientColors,
      strokeWidth: poly.strokeWidth,
      useStrokeWidthInMeter: poly.useStrokeWidthInMeter,
      color: poly.color,
      borderColor: poly.borderColor,
      borderStrokeWidth: poly.borderStrokeWidth,
      pattern: poly.isDotted,
      strokeCap: poly.strokeCap,
      strokeJoin: poly.strokeJoin,
      hitValue: poly.hintValue,
    );
    // consoleLog(polyline.area(), color: 35);
    return polyline;
  }
}
