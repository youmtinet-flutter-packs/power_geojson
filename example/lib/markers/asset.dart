import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:power_geojson/power_geojson.dart';
import 'package:power_geojson_example/lib.dart';

class AssetGeoJSONMarkerPoints extends StatelessWidget {
  const AssetGeoJSONMarkerPoints({Key? key, required this.popupController, this.mapController}) : super(key: key);
  final MapController? mapController;
  final PopupController popupController;
  @override
  Widget build(BuildContext context) {
    return PowerGeoJSONMarkers.asset(
      'assets/points.geojson',
      markerProperties: const MarkerProperties(width: 45, height: 45),
      builder: (context, markerProperties, map) => FittedBox(child: _markerBuilder()),
      powerClusterOptions: PowerMarkerClusterOptions(
        popupOptions: PowerPopupOptions(
          popupController: popupController,
          popupBuilder: (context, PowerMarker powerMarker) {
            Map<String, Object?>? properties = powerMarker.properties;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(properties == null ? '' : AssetMarkerProperties.fromJson(properties).name),
              ),
            );
          },
        ),
        spiderfyCluster: true,
        builder: (context, markers) => Badge.count(
          count: markers.length,
          child: _markerBuilder(),
        ),
      ),
      /* builder: (context, MarkerProperties markerProps, props) {
        var prop = props?['Name'];
        return _stackMarkerBuilder(prop);
      }, */
    );
  }

  Stack stackMarkerBuilder(dynamic prop) {
    return Stack(
      children: [
        _markerBuilder(),
        if (prop.runtimeType == String)
          Text(
            prop,
            style: const TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(color: Colors.black, blurRadius: 5),
              ],
            ),
          ),
      ],
    );
  }
/* 
  Transform _markerBuilder() {
    return Transform.rotate(
      angle: pi,
      child: SvgPicture.asset(
        "assets/icons/position.svg",
        theme: const SvgTheme(
          currentColor: Color(0xFF72077C),
        ),
      ),
    );
  } */

  Widget _markerBuilder() {
    return Transform.rotate(
      angle: 0,
      child: PinCentered(color: Color(0xFF72077C)),
    );
  }
}
