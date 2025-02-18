import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:power_geojson/power_geojson.dart';

class FileGeoJSONPolygon extends StatelessWidget {
  const FileGeoJSONPolygon({
    Key? key,
    MapController? mapController,
  })  : _mapController = mapController,
        super(key: key);

  final MapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return AppPlatform.isWeb
        ? SizedBox()
        : PowerGeoJSONPolygons.file(
            "/storage/emulated/0/Android/data/com.ymrabtipacks.power_geojson_example/files/files_polygons",
            fallback: () => Card(child: Text('Untrouvé!')),
            polygonProperties: const PolygonProperties(
              layerProperties: {
                LayerPolygonIndexes.label: 'Name',
              },
              rotateLabel: true,
              fillColor: Color(0xFF7F0573),
              isFilled: true,
              borderColor: Colors.red,
              labelStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(blurRadius: 10, color: Colors.black),
                ],
              ),
              labeled: true,
            ),
            mapController: _mapController,
          );
  }
}
