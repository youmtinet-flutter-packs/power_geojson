import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:power_geojson/power_geojson.dart';

class FileGeoJSONMarkers extends StatelessWidget {
  const FileGeoJSONMarkers({
    Key? key,
    MapController? mapController,
  })  : _mapController = mapController,
        super(key: key);

  final MapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return PowerGeoJSONMarkers.file(
      File(
          "/storage/emulated/0/Android/data/com.ymrabtipacks.power_geojson_example/files/files_points"),
      /* builder: (context, markerProps, props) {
        return Transform.scale(
          scale: 1.1,
          child: SvgPicture.asset(
            "assets/icons/position.svg",
            color: HexColor.fromHex(props['color'], const Color(0xFFFFF238)),
          ),
        );
      },*/
      //   powerClusterOptions: clusterOptions(),
      markerProperties: const MarkerProperties(),
      mapController: _mapController,
    );
  }

  PowerMarkerClusterOptions clusterOptions() {
    return PowerMarkerClusterOptions(
      builder: (context, markers) {
        return Badge.count(
          count: markers.length,
          backgroundColor: Colors.green,
          child: PowerGeoJSONMarkers.defaultMarkerBuilder(
            context,
            MarkerProperties(),
            markers.first.properties,
            color: Colors.green,
          ),
        );
      },
    );
  }
}
