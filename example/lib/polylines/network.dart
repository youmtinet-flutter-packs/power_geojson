import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:power_geojson/power_geojson.dart';
import 'package:power_geojson_example/lib.dart';

class NetworkGeoJSONLines extends StatelessWidget {
  const NetworkGeoJSONLines({
    Key? key,
    MapController? mapController,
  })  : _mapController = mapController,
        super(key: key);

  final MapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return PowerGeoJSONPolylines.network(
      "$url/network/lines.geojson",
      polylineProperties: const PolylineProperties(
        /* layerProperties: {
          LayerPolylineIndexes.borderColor: 'COLOR',
        }, */

        color: Color(0xFF541b82),
        useStrokeWidthInMeter: true,
      ),
      fallback: (statusCode) {
        return const MarkerLayer(
          markers: [
            Marker(
              point: LatLng(33.926447747065936, -3.9228343908943998),
              width: 160,
              height: 60,
              child: Text(
                'Network Lines Not Found',
                style: TextStyle(fontSize: 8, color: Colors.red),
              ),
            ),
          ],
        );
      },
      mapController: _mapController,
    );
  }
}
