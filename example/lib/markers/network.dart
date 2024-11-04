import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:power_geojson/power_geojson.dart';
import 'package:power_geojson_example/lib.dart';

class NetworkGeoJSONMarker extends StatelessWidget {
  const NetworkGeoJSONMarker({
    Key? key,
    MapController? mapController,
  })  : _mapController = mapController,
        super(key: key);

  final MapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return PowerGeoJSONMarkers.network(
      "$url/network/points.geojson",
      markerProperties: const MarkerProperties(),
      builder: (context, markerProperties, mapProperties) {
        return SvgPicture.asset(
          "assets/icons/position.svg",
          theme: SvgTheme(
            currentColor: HexColor.fromHex(
              mapProperties?['color'],
              const Color(0xFF541b82),
            ),
          ),
        );
      },
      fallback: (int? statusCode) {
        return const MarkerLayer(
          markers: [
            Marker(
              point: LatLng(33.926447747065936, -2.9228343908943998),
              width: 160,
              height: 60,
              child: Text(
                'Network Markers Not Found',
                style: TextStyle(fontSize: 8, color: Colors.yellow),
              ),
            ),
          ],
        );
      },
      mapController: _mapController,
    );
  }
}
