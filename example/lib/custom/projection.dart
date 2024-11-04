import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PerojectionFlutterMap extends StatefulWidget {
  const PerojectionFlutterMap({Key? key}) : super(key: key);

  @override
  State<PerojectionFlutterMap> createState() => _PerojectionFlutterMapState();
}

class _PerojectionFlutterMapState extends State<PerojectionFlutterMap> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CrsCustom extends Crs {
  const CrsCustom({required super.code, required super.infinite});

  @override
  Bounds<double>? getProjectedBounds(double zoom) {
    throw UnimplementedError();
  }

  @override
  (double, double) latLngToXY(LatLng latlng, double scale) {
    throw UnimplementedError();
  }

  @override
  LatLng pointToLatLng(Point<num> point, double zoom) {
    throw UnimplementedError();
  }

  @override
  (double, double) transform(double x, double y, double scale) {
    throw UnimplementedError();
  }

  @override
  (double, double) untransform(double x, double y, double scale) {
    throw UnimplementedError();
  }

  @override
  Projection get projection => throw UnimplementedError();
}
