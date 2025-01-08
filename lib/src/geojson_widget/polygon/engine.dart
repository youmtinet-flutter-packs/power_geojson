import 'dart:convert';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:power_geojson/power_geojson.dart';
export 'properties.dart';

const List<String> _esriFields = [
  "displayFieldName",
  "fieldAliases",
  "geometryType",
  "spatialReference",
  "fields",
];

/// Loads polygons from a file and returns a widget for map display.
///
/// The [file] parameter specifies the file path to the polygon data file.
///
/// Example:
///
/// ```dart
/// FutureBuilder(
///   future: PolygonLoadingFunctions._filePolygons('path/to/file.geojson'),
///   builder: (context, snapshot) {
///     // Handle the result as needed
///   },
/// )
/// ```
Future<Widget> _filePolygons(
  String file, {
  Polygon Function(
    List<List<List<double>>> coordinates,
    Map<String, dynamic>? map,
  )? builder,
  PolygonProperties? polygonProperties,
  MapController? mapController,
  Key? key,
  required Future<String> Function(
    String filePath,
  ) fileLoadBuilder,
  bool polygonCulling = false,
  required Widget Function(int? statusCode)? fallback,
}) async {
  try {
    final string = await fileLoadBuilder(file);
    return _string(
      checkEsri(string),
      builder: builder,
      polygonProperties: polygonProperties,
      polygonCulling: polygonCulling,
      mapController: mapController,
      key: key,
    );
  } catch (_) {
    return fallback?.call(null) ?? const Text('Not Found');
  }
}

String checkEsri(String readasstring) {
  var map = jsonDecode(readasstring) as Map<String, Object?>;
  var isEsri = map.keys.every((field) => _esriFields.contains(field));
  var checkEsri = isEsri ? PowerJSON(PowerEsriJSON().toGeoJSON(map)).toText() : readasstring;
  return checkEsri;
}

/// Loads polygons from memory data and returns a widget for map display.
///
/// The [list] parameter specifies the polygon data as a `Uint8List`.
///
/// Example:
///
/// ```dart
/// FutureBuilder(
///   future: PolygonLoadingFunctions._memoryPolygons(myGeojsonData),
///   builder: (context, snapshot) {
///     // Handle the result as needed
///   },
/// )
/// ```
Future<Widget> _memoryPolygons(
  Uint8List list, {
  Polygon Function(List<List<List<double>>> coordinates, Map<String, dynamic>? map)? builder,
  PolygonProperties? polygonProperties,
  bool polygonCulling = false,
  Key? key,
  MapController? mapController,
}) async {
  String string = await strUint8List(list);
  return _string(
    checkEsri(string),
    builder: builder,
    polygonProperties: polygonProperties,
    key: key,
    polygonCulling: polygonCulling,
    mapController: mapController,
  );
}

/// Loads polygons from an asset file and returns a widget for map display.
///
/// The [path] parameter specifies the asset file path to the polygon data.
///
/// Example:
///
/// ```dart
/// FutureBuilder(
///   future: PolygonLoadingFunctions._assetPolygons('assets/geojson_data.json'),
///   builder: (context, snapshot) {
///     // Handle the result as needed
///   },
/// )
/// ```
Future<Widget> _assetPolygons(
  String path, {
  Polygon Function(List<List<List<double>>> coordinates, Map<String, dynamic>? map)? builder,
  PolygonProperties? polygonProperties,
  bool polygonCulling = false,
  Key? key,
  MapController? mapController,
}) async {
  final String string = await rootBundle.loadString(path);
  return _string(
    checkEsri(string),
    builder: builder,
    polygonProperties: polygonProperties,
    key: key,
    polygonCulling: polygonCulling,
    mapController: mapController,
  );
}

/// Loads polygons from a network source and returns a widget for map display.
///
/// The [urlString] parameter specifies the URL to the polygon data source.
///
/// Example:
///
/// ```dart
/// FutureBuilder(
///   future: PolygonLoadingFunctions._networkPolygons(Uri.parse('https://example.com/geojson_data.json')),
///   builder: (context, snapshot) {
///     // Handle the result as needed
///   },
/// )
/// ```
Future<Widget> _networkPolygons(
  Uri urlString, {
  Polygon Function(List<List<List<double>>> coordinates, Map<String, dynamic>? map)? builder,
  Client? client,
  Map<String, String>? headers,
  required List<int> statusCodes,
  PolygonProperties? polygonProperties,
  bool polygonCulling = false,
  Key? key,
  MapController? mapController,
  required Widget Function(int? statusCode)? fallback,
}) async {
  var method = client == null ? get : client.get;
  var response = await method(urlString, headers: headers);
  var string = response.body;
  if (statusCodes.contains(response.statusCode)) {
    return _string(
      checkEsri(string),
      builder: builder,
      polygonProperties: polygonProperties,
      key: key,
      polygonCulling: polygonCulling,
      mapController: mapController,
    );
  } else {
    return fallback?.call(response.statusCode) ?? Text('${response.statusCode}');
  }
}

/// Parses the polygon data provided as a string and returns a widget for map display.
///
/// The [string] parameter contains the polygon data in GeoJSON format.
///
/// Example:
///
/// ```dart
/// FutureBuilder(
///   future: PolygonLoadingFunctions._string(myGeojsonData),
///   builder: (context, snapshot) {
///     // Handle the result as needed
///   },
/// )
/// ```
PolygonLayer _string(
  String string, {
  Polygon Function(List<List<List<double>>> coordinates, Map<String, dynamic>? map)? builder,
  // layer
  Key? key,
  bool polygonCulling = false,
  PolygonProperties? polygonProperties,
  MapController? mapController,
}) {
  final geojson = PowerGeoJSONFeatureCollection.fromJson(checkEsri(string));

  var polygons = geojson.geoJSONPolygons.map(
    (e) {
      return builder != null
          ? builder(e.geometry.coordinates, e.properties)
          : e.geometry.coordinates.toPolygon(
              polygonProperties: PolygonProperties.fromMap(e.properties, polygonProperties ?? const PolygonProperties()),
            );
    },
  ).toList();

  List<List<double>?> bbox = geojson.geoJSONPoints.map((e) => e.bbox).toList();
  zoomTo(bbox, mapController);
  return PolygonLayer(
    polygons: polygons,
    key: key,
    polygonCulling: polygonCulling,
  );
}

/// A utility class for loading and displaying polygons on a map from various sources.
///
/// The `PowerGeoJSONPolygons` class provides static methods for loading polygon data
/// from network sources, assets, files, memory, or directly from a string in GeoJSON format.
/// It also allows customizing polygon rendering through a builder function or polygon properties.
///
/// Example usage:
///
/// ```dart
/// // Load polygons from a network source
/// PowerGeoJSONPolygons.network(
///   'https://example.com/polygon_data.geojson',
///   builder: (coordinates, properties) {
///     // Customize polygon rendering
///     return Polygon(
///       points: coordinates[0].map((point) => LatLng(point[1], point[0])).toList(),
///       // Add more polygon properties as needed
///     );
///   },
///   mapController: myMapController,
/// )
///
/// // Load polygons from an asset file
/// PowerGeoJSONPolygons.asset(
///   'assets/polygon_data.geojson',
///   polygonProperties: PolygonProperties(
///     fillColor: Colors.blue,
///     strokeColor: Colors.red,
///   ),
/// )
///
/// // Load polygons from memory data
/// PowerGeoJSONPolygons.memory(
///   myGeojsonData,
///   polygonCulling: true,
/// )
///
/// // Load polygons from a string in GeoJSON format
/// PowerGeoJSONPolygons.string(
///   '{"type":"Feature","geometry":{"type":"Polygon","coordinates":[[...]]}}',
///   mapController: myMapController,
/// )
/// ```
class PowerGeoJSONPolygons {
  /// Loads and displays polygons from a network source on a map.
  ///
  /// The [url] parameter specifies the URL of the polygon data source.
  ///
  /// Example:
  ///
  /// ```dart
  /// PowerGeoJSONPolygons.network(
  ///   'https://example.com/polygon_data.geojson',
  ///   builder: (coordinates, properties) {
  ///     // Customize polygon rendering
  ///     return Polygon(
  ///       points: coordinates[0].map((point) => LatLng(point[1], point[0])).toList(),
  ///       // Add more polygon properties as needed
  ///     );
  ///   },
  ///   mapController: myMapController,
  /// )
  /// ```
  static Widget network(
    String url, {
    Client? client,
    List<int> statusCodes = const [200],
    Map<String, String>? headers,
    // layer
    Key? key,
    bool polygonCulling = false,
    Polygon Function(List<List<List<double>>> coordinates, Map<String, dynamic>? map)? builder,
    PolygonProperties? polygonProperties,
    MapController? mapController,
    Widget Function(int? statusCode)? fallback,
  }) {
    assert((builder == null && polygonProperties != null) || (polygonProperties == null && builder != null));
    var uriString = url.toUri();
    return EnhancedFutureBuilder(
      future: _networkPolygons(
        uriString,
        builder: builder,
        headers: headers,
        client: client,
        statusCodes: statusCodes,
        polygonProperties: polygonProperties,
        key: key,
        polygonCulling: polygonCulling,
        mapController: mapController,
        fallback: fallback,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Loads and displays polygons from an asset file on a map.
  ///
  /// The [url] parameter specifies the asset file path to the polygon data.
  ///
  /// Example:
  ///
  /// ```dart
  /// PowerGeoJSONPolygons.asset(
  ///   'assets/polygon_data.geojson',
  ///   polygonProperties: PolygonProperties(
  ///     fillColor: Colors.blue,
  ///     strokeColor: Colors.red,
  ///   ),
  /// )
  /// ```
  static Widget asset(
    String url, {
    // layer
    Key? key,
    bool polygonCulling = false,
    Polygon Function(List<List<List<double>>> coordinates, Map<String, dynamic>? map)? builder,
    PolygonProperties? polygonProperties,
    MapController? mapController,
  }) {
    assert((builder == null && polygonProperties != null) || (polygonProperties == null && builder != null));
    return EnhancedFutureBuilder(
      future: _assetPolygons(
        url,
        builder: builder,
        polygonProperties: polygonProperties,
        key: key,
        polygonCulling: polygonCulling,
        mapController: mapController,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Loads and displays polygons from a file on a map.
  ///
  /// The [path] parameter specifies the file path to the polygon data file.
  ///
  /// Example:
  ///
  /// ```dart
  /// PowerGeoJSONPolygons.file(
  ///   'path/to/polygon_data.geojson',
  ///   polygonProperties: PolygonProperties(
  ///     strokeColor: Colors.green,
  ///   ),
  /// )
  /// ```
  static Widget file(
    String path, {
    // layer
    Key? key,
    bool polygonCulling = false,
    PolygonProperties? polygonProperties,
    Future<String> Function(String)? fileLoadBuilder,
    Polygon Function(List<List<List<double>>> coordinates, Map<String, dynamic>? map)? builder,
    MapController? mapController,
    Widget Function(int? statusCode)? fallback,
  }) {
    assert((builder == null && polygonProperties != null) || (polygonProperties == null && builder != null));

    if (AppPlatform.isWeb) {
      throw UnsupportedError('Unsupported platform: Web');
    }
    return EnhancedFutureBuilder(
      future: _filePolygons(
        fileLoadBuilder: fileLoadBuilder ?? defaultFileLoadBuilder,
        path,
        builder: builder,
        polygonProperties: polygonProperties,
        key: key,
        fallback: fallback,
        polygonCulling: polygonCulling,
        mapController: mapController,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Loads and displays polygons from memory data on a map.
  ///
  /// The [bytes] parameter contains the polygon data as a `Uint8List`.
  ///
  /// Example:
  ///
  /// ```dart
  /// PowerGeoJSONPolygons.memory(
  ///   myGeojsonData,
  ///   polygonCulling: true,
  /// )
  /// ```
  static Widget memory(
    Uint8List bytes, {
    // layer
    Key? key,
    bool polygonCulling = false,
    PolygonProperties? polygonProperties,
    Polygon Function(
      List<List<List<double>>> coordinates,
      Map<String, dynamic>? map,
    )? builder,
    MapController? mapController,
  }) {
    assert(
      (builder == null && polygonProperties != null) || (polygonProperties == null && builder != null),
    );
    return EnhancedFutureBuilder(
      future: _memoryPolygons(
        bytes,
        builder: builder,
        polygonProperties: polygonProperties,
        key: key,
        polygonCulling: polygonCulling,
        mapController: mapController,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Loads and displays polygons from a string in GeoJSON format on a map.
  ///
  /// The [data] parameter contains the polygon data in GeoJSON format.
  ///
  /// Example:
  ///
  /// ```dart
  /// PowerGeoJSONPolygons.string(
  ///   '{"type":"Feature","geometry":{"type":"Polygon","coordinates":[[...]]}}',
  ///   mapController: myMapController,
  /// )
  /// ```
  static PolygonLayer string(
    String data, {
    // layer
    Key? key,
    bool polygonCulling = false,
    Polygon Function(List<List<List<double>>> coordinates, Map<String, dynamic>? map)? builder,
    PolygonProperties? polygonProperties,
    MapController? mapController,
  }) {
    assert((builder == null && polygonProperties != null) || (polygonProperties == null && builder != null));
    return _string(
      data,
      builder: builder,
      polygonProperties: polygonProperties,
      key: key,
      polygonCulling: polygonCulling,
      mapController: mapController,
    );
  }
}
