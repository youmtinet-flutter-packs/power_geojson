import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:power_geojson/power_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:power_geojson_example/lib.dart';

class AppHome extends StatefulWidget {
  AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => PowerGeojsonSampleApp());
          },
          child: Text('Start'),
        ),
      ),
    );
  }
}

class PowerGeojsonSampleApp extends StatefulWidget {
  PowerGeojsonSampleApp({
    super.key,
  });

  @override
  State<PowerGeojsonSampleApp> createState() => _PowerGeojsonSampleAppState();
}

class _PowerGeojsonSampleAppState extends State<PowerGeojsonSampleApp> {
  //
  LatLng latLng = LatLng(34.92849168609999, -2.3225879568537056);
  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();

  final List<Marker> _arcgisMarkers = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _map(),
    );
  }

  Widget _map() {
    int interactiveFlags = InteractiveFlag.doubleTapZoom | //
        InteractiveFlag.drag |
        InteractiveFlag.scrollWheelZoom |
        InteractiveFlag.pinchZoom |
        InteractiveFlag.pinchMove;
    LatLng center = LatLng(34.926447747065936, -2.3228343908943998);
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(title: Text("Power GeoJSON Examples")),
        body: PopupScope(
          popupController: _popupController,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 11,
              interactionOptions: InteractionOptions(flags: interactiveFlags),
              onTap: (tapPosition, point) {
                _popupController.hideAllPopups();
              },
              onMapEvent: (mapEvent) async {},
              onMapReady: () async => await createFiles(),
            ),
            children: [
              TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  maxZoom: 19),
              AssetGeoJSONZones(),
              //////////////// Polygons
              AssetGeoJSONPolygon(),
              FileGeoJSONPolygon(),
              StringGeoJSONPolygon(),
              NetworkGeoJSONPolygon(),
              //////////////// Lines
              AssetGeoJSONLines(),
              FileGeoJSONLines(),
              StringGeoJSONLines(),
              NetworkGeoJSONLines(),
              //////////////// Points
              AssetGeoJSONMarkerPoints(popupController: _popupController),
              FileGeoJSONMarkers(),
              StringGeoJSONPoints(),
              NetworkGeoJSONMarker(),
              // /////// /// ///// ///
              CircleOfMap(latLng: latLng),
              MarkerLayer(markers: _arcgisMarkers),
              /* ClustersMarkers(), */
            ],
          ),
        ),
      ),
    );
  }

  Center mapSVG() {
    return Center(
      child: EnhancedFutureBuilder(
        future: assetPolygons('assets/morocco.geojson'),
        whenDone: (polygon) {
          return ClipPath(
            clipper: PowerGeoJSONClipper(
              polygon: polygon.geometry.coordinates.toPolygon(),
            ),
            child: Container(
              color: Colors.red,
              width: Get.width / 1.23,
              height: Get.height / 1.5,
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
        rememberFutureResult: false,
        whenNotDone: Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
