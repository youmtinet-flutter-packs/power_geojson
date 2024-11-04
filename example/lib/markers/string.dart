import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:power_geojson/power_geojson.dart';

class StringGeoJSONPoints extends StatelessWidget {
  const StringGeoJSONPoints({
    Key? key,
    MapController? mapController,
  })  : _mapController = mapController,
        super(key: key);

  final MapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return PowerGeoJSONMarkers.string(
      stringMarkers,
      /* builder: (context, markerProperties, properties) {
        return SvgPicture.asset(
          "assets/icons/position.svg",
          color: const Color(0xFFEF2874),
        );
      }, */
      markerProperties: const MarkerProperties(),
      mapController: _mapController,
    );
  }
}

const stringMarkers = '''{
  "type" : "FeatureCollection",
  "features" : [{"type":"Feature","id":1,"geometry":{"type":"Point","coordinates":[-4.2507627274252,31.30802351331479]},"properties":{"OBJECTID":1,"Name":"Ksar Elfida"}},{"type":"Feature","id":2,"geometry":{"type":"Point","coordinates":[-4.2356839520190421,31.289290653875621]},"properties":{"OBJECTID":2,"Name":"Ksar El Farkh"}},{"type":"Feature","id":3,"geometry":{"type":"Point","coordinates":[-4.2231290374210682,31.294186173508699]},"properties":{"OBJECTID":3,"Name":"Casa-Âne"}},{"type":"Feature","id":4,"geometry":{"type":"Point","coordinates":[-4.2552969495672723,31.298471789619452]},"properties":{"OBJECTID":4,"Name":"Ksar echbili"}},{"type":"Feature","id":5,"geometry":{"type":"Point","coordinates":[-4.2769592189759651,31.309170805014659]},"properties":{"OBJECTID":5,"Name":"Mnsouria"}},{"type":"Feature","id":6,"geometry":{"type":"Point","coordinates":[-4.3052973166219175,31.33175584709241]},"properties":{"OBJECTID":6,"Name":"Oulad Hessein"}},{"type":"Feature","id":7,"geometry":{"type":"Point","coordinates":[-4.3085373125779647,31.322562332561546]},"properties":{"OBJECTID":7,"Name":"Ezzaoui el boubekria"}}]
}''';
