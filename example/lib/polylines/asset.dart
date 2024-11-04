import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:power_geojson/power_geojson.dart';

class AssetGeoJSONLines extends StatelessWidget {
  const AssetGeoJSONLines({Key? key, this.mapController}) : super(key: key);
  final MapController? mapController;
  @override
  Widget build(BuildContext context) {
    return PowerGeoJSONPolylines.asset(
      'assets/lines.geojson',
      mapController: mapController,
      //   polylineCulling: true,
      polylineProperties: const PolylineProperties(
        isDotted: StrokePattern.dotted(),
        borderStrokeWidth: 0,
        borderColor: Colors.red,
        useStrokeWidthInMeter: true,
        strokeWidth: 20,
        color: Colors.transparent,
        gradientColors: Colors.primaries,
      ),
    );
  }
}
