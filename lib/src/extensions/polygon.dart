import 'dart:math';

import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:point_in_polygon/point_in_polygon.dart';
import 'package:power_geojson/power_geojson.dart';

extension PointXList on List<double> {
  LatLng toLatLng() {
    return LatLng(last, first);
  }
}

extension XListPoint on LatLng {
  List<double> toList() {
    return [longitude, latitude];
  }
}

extension ListABC<T> on List<T> {
  /// Returns the first element that matches the test; if none is found, it returns null.
  T? firstWhereOrNull(bool Function(T) test) {
    var first = where(test);
    return first.isEmpty ? null : first.first;
  }
}

extension PolyX on Polygon {
  bool isPointInsidePolygon(LatLng position) {
    var list = [
      points.map((e) => e.toList()).toList(),
      ...(holePointsList ?? [])
          .map((e) => e.map((f) => f.toList()).toList())
          .toList(),
    ];
    return list.isGeoPointInPolygon(position);
  }
}

extension ListListLatLngX on List<List<List<double>>> {
  bool isGeoPointInPolygon(LatLng position) {
    var isInPolygon = false;
    var points = first.toLatLng();

    for (var i = 0, j = points.length - 1; i < points.length; j = i++) {
      if ((((points[i].latitude <= position.latitude) &&
                  (position.latitude < points[j].latitude)) ||
              ((points[j].latitude <= position.latitude) &&
                  (position.latitude < points[i].latitude))) &&
          (position.longitude <
              (points[j].longitude - points[i].longitude) *
                      (position.latitude - points[i].latitude) /
                      (points[j].latitude - points[i].latitude) +
                  points[i].longitude)) isInPolygon = !isInPolygon;
    }
    return isInPolygon;
  }

  bool isPointInsidePolygon(LatLng position) {
    var outHoles = length > 1
        ? sublist(1).map((e) {
            return ![e]._isPointInsidePolygon(position);
          }).every((e) => e)
        : true;
    return _isPointInsidePolygon(position) && outHoles;
  }

  bool _isPointInsidePolygon(LatLng position) {
    var points = first;
    // Check if the point sits exactly on a vertex
    // var vertexPosition = points.firstWhere((point) => point == position, orElse: () => null);
    LatLng? vertexPosition = points
        .firstWhereOrNull((point) => point.toLatLng() == position)
        ?.toLatLng();
    if (vertexPosition != null) {
      return true;
    }

    // Check if the point is inside the polygon or on the boundary
    int intersections = 0;
    var verticesCount = points.length;

    for (int i = 1; i < verticesCount; i++) {
      LatLng vertex1 = points[i - 1].toLatLng();
      LatLng vertex2 = points[i].toLatLng();

      // Check if point is on an horizontal polygon boundary
      if (vertex1.latitude == vertex2.latitude &&
          vertex1.latitude == position.latitude &&
          position.longitude > min(vertex1.longitude, vertex2.longitude) &&
          position.longitude < max(vertex1.longitude, vertex2.longitude)) {
        return true;
      }

      if (position.latitude > min(vertex1.latitude, vertex2.latitude) &&
          position.latitude <= max(vertex1.latitude, vertex2.latitude) &&
          position.longitude <= max(vertex1.longitude, vertex2.longitude) &&
          vertex1.latitude != vertex2.latitude) {
        var xinters = (position.latitude - vertex1.latitude) *
                (vertex2.longitude - vertex1.longitude) /
                (vertex2.latitude - vertex1.latitude) +
            vertex1.longitude;
        if (xinters == position.longitude) {
          // Check if point is on the polygon boundary (other than horizontal)
          return true;
        }
        if (vertex1.longitude == vertex2.longitude ||
            position.longitude <= xinters) {
          intersections++;
        }
      }
    }

    // If the number of edges we passed through is odd, then it's in the polygon.
    return intersections % 2 != 0;
  }
}

extension PolygonsXX on List<List<List<double>>> {
  /// Converts a list coords of a Polygon into a [Polygon]
  Polygon toPolygon(
      {PolygonProperties polygonProperties = const PolygonProperties()}) {
    var holes = sublist(1).map((f) => f.toLatLng()).toList();
    var polygon = Polygon(
      points: first.toLatLng(),
      holePointsList: holes,
      color: polygonProperties.fillColor,
      borderColor: polygonProperties.borderColor,
      borderStrokeWidth: polygonProperties.borderStokeWidth,
      disableHolesBorder: polygonProperties.disableHolesBorder,
      label: polygonProperties.label,
      pattern: polygonProperties.pattern,
      labelPlacement: polygonProperties.labelPlacement,
      labelStyle: polygonProperties.labelStyle,
      rotateLabel: polygonProperties.rotateLabel,
      strokeCap: polygonProperties.strokeCap,
      strokeJoin: polygonProperties.strokeJoin,
    );
    // consoleLog(polygon.area(), color: 35);
    return polygon;
  }
}
