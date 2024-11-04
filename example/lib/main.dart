import 'dart:io';
import 'package:console_tools/console_tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart'
    show PopupController, PopupScope;
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:power_geojson/power_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:power_geojson_example/lib.dart';

// // Network ==> Rabat
// // File    ==> Casablanca
// // String  ==> Rissani
// // Asset   ==> Marrakech + Tanger + Maroc

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
    // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppHome(),
    ),
  );
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});

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
  const PowerGeojsonSampleApp({
    super.key,
  });

  @override
  State<PowerGeojsonSampleApp> createState() => _PowerGeojsonSampleAppState();
}

class _PowerGeojsonSampleAppState extends State<PowerGeojsonSampleApp> {
  LatLng latLng = const LatLng(34.92849168609999, -2.3225879568537056);

  final MapController _mapController = MapController();
  final PopupController _popupController = PopupController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double distanceMETERS = 10;
    // var distanceDMS = dmFromMeters(distanceMETERS);
    return Scaffold(
      body: _map(),
    );
  }

  Widget _map() {
    int interactiveFlags = InteractiveFlag.doubleTapZoom | //
        InteractiveFlag.drag |
        InteractiveFlag.pinchZoom |
        InteractiveFlag.pinchMove;
    LatLng center = const LatLng(34.926447747065936, -2.3228343908943998);
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(title: const Text("Power GeoJSON Examples")),
        body: PopupScope(
          popupController: _popupController,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 11,
              interactionOptions: InteractionOptions(flags: interactiveFlags),
              onLongPress: (tapPosition, point) {
                Console.log('onLongPress $point', color: ConsoleColors.citron);
              },
              onTap: (tapPosition, point) {
                setState(() {});
              },
              onMapEvent: (mapEvent) async {},
              onMapReady: () async => await _createFiles(),
            ),
            children: [
              TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  maxZoom: 19),
              const AssetGeoJSONZones(),
              //////////////// Polygons
              const AssetGeoJSONPolygon(),
              const FileGeoJSONPolygon(),
              const StringGeoJSONPolygon(),
              const NetworkGeoJSONPolygon(),
              //////////////// Lines
              const AssetGeoJSONLines(),
              const FileGeoJSONLines(),
              const StringGeoJSONLines(),
              const NetworkGeoJSONLines(),
              //////////////// Points
              AssetGeoJSONMarkerPoints(popupController: _popupController),
              const FileGeoJSONMarkers(),
              const StringGeoJSONPoints(),
              const NetworkGeoJSONMarker(),

              CircleOfMap(latLng: latLng),
              /* const ClustersMarkers(), */
            ],
          ),
        ),
      ),
    );
  }

  Center mapSVG() {
    return Center(
      child: EnhancedFutureBuilder(
        future: _assetPolygons('assets/morocco.geojson'),
        whenDone: (polygon) {
          return ClipPath(
            clipper: PowerGeoJSONClipper(
              polygon: polygon.geometry.coordinates.toPolygon(),
            ),
            child: Container(
              color: Colors.red,
              width: Get.width / 1.23,
              height: Get.height / 1.5,
              child: const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
        rememberFutureResult: false,
        whenNotDone: const Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}

Future<void> _createFiles() async {
  final String assetsPoints /**********/ = await rootBundle
      .loadString('assets/file/points.geojson' /**************/);
  final String assetsLines /***********/ = await rootBundle
      .loadString('assets/file/lines.geojson' /***************/);
  final String assetsPolygons /********/ = await rootBundle
      .loadString('assets/file/polygons.geojson' /************/);
  await _createFile('files_points', /**********/ assetsPoints);
  await _createFile('files_lines', /***********/ assetsLines);
  await _createFile('files_polygons', /********/ assetsPolygons);
}

Future<File> _createFile(String filename, String data) async {
  List<Directory>? list = await getExternalDir();
  String directory =
      ((list == null || list.isEmpty) ? Directory('/') : list[0]).path;
  String path = "$directory/$filename";
  Console.log(path);
  File file = File(path);
  bool exists = await file.exists();
  if (!exists) {
    return file..writeAsStringSync(data);
  }
  return file;
}

Future<PowerGeoPolygon> _assetPolygons(String path) async {
  final string = await rootBundle.loadString(path);
  return PowerGeoJSONFeatureCollection.fromJson(string).geoJSONPolygons.first;
}

class CircleOfMap extends StatelessWidget {
  const CircleOfMap({
    Key? key,
    required this.latLng,
  }) : super(key: key);

  final LatLng latLng;

  @override
  Widget build(BuildContext context) {
    return CircleLayer(
      circles: [
        CircleMarker(
          point: latLng,
          radius: 500,
          color: Colors.indigo.withOpacity(0.6),
          borderColor: Colors.black,
          borderStrokeWidth: 3,
          useRadiusInMeter: true,
        ),
      ],
    );
  }
}

class PinCentered extends StatelessWidget {
  const PinCentered({super.key, required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    double parent = 30;
    // double gapH = 1;
    // double gapW = 1;
    double iconSize = parent / 2;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(width: parent, height: parent),
        // Positioned(left: 0, top: (parentH - gapH) / 2, child: Container(height: gapH, width: parentW, color: Colors.white)),
        // Positioned(left: (parentW - gapW) / 2, top: 0, child: Container(height: parentH, width: gapW, color: Colors.white)),
        Positioned(
          left: (parent - iconSize) / 2,
          top: parent / 2 - iconSize,
          child: Icon(
            CupertinoIcons.pin_fill,
            size: iconSize,
            color: color,
          ),
        ),
      ],
    );
  }
}

/* 
TileLayer(
	urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
	backgroundColor: const Color(0xFF202020),
	maxZoom: 19,
), 
FeatureLayer(
	options: FeatureLayerOptions(
		"https://services.arcgis.com/V6ZHFr6zdgNZuVG0/arcgis/rest/services/Landscape_Trees/FeatureServer/0",
		"point",
	),
	stream: esri(),
), 
*/
