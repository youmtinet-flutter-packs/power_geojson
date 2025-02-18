import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:power_geojson/power_geojson.dart';
export 'properties.dart';

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
Future<Widget> _filePolygons<T extends Object>(
  String file, {
  Polygon<T> Function(
    List<List<LatLng>> coordinates,
    Map<String, dynamic>? map,
  )? builder,
  PolygonProperties<T>? polygonProperties,
  MapController? mapController,
  Key? key,
  required Future<String> Function(
    String filePath,
  ) fileLoadBuilder,
  bool polygonCulling = false,
  required Widget Function()? fallback,
}) async {
  try {
    final String string = await fileLoadBuilder(file);
    return _string(
      checkEsri(string),
      builder: builder,
      polygonProperties: polygonProperties,
      polygonCulling: polygonCulling,
      mapController: mapController,
      key: key,
    );
  } catch (_) {
    return fallback?.call() ?? const Text('Not Found');
  }
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
Future<Widget> _memoryPolygons<T extends Object>(
  Uint8List list, {
  Polygon<T> Function(List<List<LatLng>> coordinates, Map<String, dynamic>? map)? builder,
  PolygonProperties<T>? polygonProperties,
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
Future<Widget> _assetPolygons<T extends Object>(
  String path, {
  Polygon<T> Function(List<List<LatLng>> coordinates, Map<String, dynamic>? map)? builder,
  PolygonProperties<T>? polygonProperties,
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
Future<Widget> _networkPolygons<T extends Object>(
  Uri urlString, {
  Polygon<T> Function(List<List<LatLng>> coordinates, Map<String, dynamic>? map)? builder,
  Client? client,
  Map<String, String>? headers,
  required List<int> statusCodes,
  PolygonProperties<T>? polygonProperties,
  bool polygonCulling = false,
  Key? key,
  MapController? mapController,
  required Widget Function(int? statusCode)? fallback,
}) async {
  Future<Response> Function(Uri url, {Map<String, String>? headers}) method = client == null ? get : client.get;
  Response response = await method(urlString, headers: headers);
  String string = response.body;
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
PolygonLayer<T> _string<T extends Object>(
  String string, {
  Polygon<T> Function(List<List<LatLng>> coordinates, Map<String, dynamic>? map)? builder,
  // layer
  Key? key,
  bool polygonCulling = false,
  PolygonProperties<T>? polygonProperties,
  MapController? mapController,
}) {
  final PowerGeoJSONFeatureCollection geojson = PowerGeoJSONFeatureCollection.fromJson(checkEsri(string));

  List<Polygon<T>> polygons = geojson.geoJSONPolygons.map(
    (PowerGeoPolygon e) {
      if (builder != null) {
        return builder(
          e.geometry.coordinates.map((List<List<double>> e) => e.toLatLng()).toList(),
          e.properties,
        );
      } else {
        return e.geometry.coordinates.toPolygon<T>(
          polygonProps: PolygonProperties.fromMap<T>(e.properties, polygonProperties ?? PolygonProperties<T>()),
        );
      }
    },
  ).toList();

  List<List<double>?> bbox = geojson.geoJSONPoints.map((PowerGeoPoint e) => e.bbox).toList();
  zoomTo(bbox, mapController);
  return PolygonLayer<T>(
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
  static Widget network<T extends Object>(
    String url, {
    Client? client,
    List<int> statusCodes = const <int>[200],
    Map<String, String>? headers,
    // layer
    Key? key,
    bool polygonCulling = false,
    Polygon<T> Function(List<List<LatLng>> coordinates, Map<String, dynamic>? map)? builder,
    PolygonProperties<T>? polygonProperties,
    MapController? mapController,
    Widget Function(int? statusCode)? fallback,
  }) {
    assert((builder == null && polygonProperties != null) || (polygonProperties == null && builder != null));
    Uri uriString = url.toUri();
    return EnhancedFutureBuilder<Widget>(
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
  static Widget asset<T extends Object>(
    String url, {
    // layer
    Key? key,
    bool polygonCulling = false,
    Polygon<T> Function(List<List<LatLng>> coordinates, Map<String, dynamic>? map)? builder,
    PolygonProperties<T>? polygonProperties,
    MapController? mapController,
  }) {
    assert((builder == null && polygonProperties != null) || (polygonProperties == null && builder != null));
    return EnhancedFutureBuilder<Widget>(
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
  static Widget file<T extends Object>(
    String path, {
    // layer
    Key? key,
    bool polygonCulling = false,
    PolygonProperties<T>? polygonProperties,
    Future<String> Function(String)? fileLoadBuilder,
    Polygon<T> Function(List<List<LatLng>> coordinates, Map<String, dynamic>? map)? builder,
    MapController? mapController,
    Widget Function()? fallback,
  }) {
    assert((builder == null && polygonProperties != null) || (polygonProperties == null && builder != null));

    if (AppPlatform.isWeb) {
      throw UnsupportedError('Unsupported platform: Web');
    }
    return EnhancedFutureBuilder<Widget>(
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
  static Widget memory<T extends Object>(
    Uint8List bytes, {
    // layer
    Key? key,
    bool polygonCulling = false,
    PolygonProperties<T>? polygonProperties,
    Polygon<T> Function(
      List<List<LatLng>> coordinates,
      Map<String, dynamic>? map,
    )? builder,
    MapController? mapController,
  }) {
    assert(
      (builder == null && polygonProperties != null) || (polygonProperties == null && builder != null),
    );
    return EnhancedFutureBuilder<Widget>(
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
  static PolygonLayer<T> string<T extends Object>(
    String data, {
    // layer
    Key? key,
    bool polygonCulling = false,
    Polygon<T> Function(List<List<LatLng>> coordinates, Map<String, dynamic>? map)? builder,
    PolygonProperties<T>? polygonProperties,
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
