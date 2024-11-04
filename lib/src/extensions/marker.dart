import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:power_geojson/power_geojson.dart';
import 'package:flutter/material.dart';

extension MarkerXX on List<double> {
  /// Converts a list coords of point into a [Marker]
  PowerMarker toPowerMarker({
    required MarkerProperties markerProperties,
    required Map<String, Object?>? properties,
    required Widget child,
  }) {
    return PowerMarker(
      height: markerProperties.height,
      width: markerProperties.width,
      rotate: markerProperties.rotate,
      child: child,
      alignment: markerProperties.rotateAlignment ?? Alignment.center,
      key: markerProperties.key,
      properties: properties,
      point: LatLng(this[1], this[0]),
    );
  }
}
