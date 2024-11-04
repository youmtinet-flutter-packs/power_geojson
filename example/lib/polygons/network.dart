import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:power_geojson/power_geojson.dart';
import 'package:power_geojson_example/lib.dart';

class NetworkGeoJSONPolygon extends StatelessWidget {
  const NetworkGeoJSONPolygon({
    Key? key,
    MapController? mapController,
  })  : _mapController = mapController,
        super(key: key);

  final MapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return PowerGeoJSONPolygons.network(
      "$url/network/polygons.geojson",
      polygonProperties: const PolygonProperties(
        layerProperties: {
          LayerPolygonIndexes.fillColor: 'COLOR',
          LayerPolygonIndexes.label: 'placename',
        },
        rotateLabel: true,
        borderStokeWidth: 0.02,
        fillColor: Color(0xFF541b82),
        labelStyle: TextStyle(
          fontStyle: FontStyle.italic,
          color: Color(0xFF830202),
          shadows: [
            Shadow(blurRadius: 10, color: Colors.white),
          ],
        ),
        labeled: true,
      ),
      fallback: (statusCode) {
        return const MarkerLayer(
          markers: [
            Marker(
              point: LatLng(33.926447747065936, -2.3228343908943998),
              width: 160,
              height: 60,
              child: Text(
                'Network Polygons Not Found',
                style: TextStyle(fontSize: 8, color: Colors.blue),
              ),
            ),
          ],
        );
      },
      mapController: _mapController,
    );
  }
}
