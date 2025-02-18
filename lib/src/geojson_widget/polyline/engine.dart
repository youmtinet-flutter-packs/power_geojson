import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:power_geojson/power_geojson.dart';

/// Loads and displays polylines from a file on a map.
///
/// The [_filePolylines] function loads polyline data from a file specified by
/// the [path] parameter and displays it on a map. You can customize the rendering
/// of the polylines using [polylineProperties] and [builder].
///
/// Example usage:
///
/// ```dart
/// FutureBuilder(
///   future: _filePolylines(
///     'path/to/polyline_data.json',
///     polylineProperties: PolylineProperties(
///       color: Colors.blue,
///       width: 3.0,
///     ),
///     mapController: myMapController,
///   ),
///   builder: (context, snapshot) {
///     if (snapshot.connectionState == ConnectionState.done) {
///       if (snapshot.hasData) {
///         return snapshot.data ?? const SizedBox();
///       }
///     } else if (snapshot.connectionState == ConnectionState.waiting) {
///       return const Center(child: CircularProgressIndicator());
///     }
///     return const text('Error loading polylines');
///   },
/// )
/// ```
///
/// The [polylineCulling] parameter allows you to enable or disable culling of
/// polylines that are outside the map's viewport, improving performance.
///
/// If the file specified by [path] does not exist, the function returns a `text`
/// widget displaying "Not Found".
///
/// Returns a widget displaying the loaded polylines on the map.
Future<Widget> _filePolylines<T extends Object>(
  String file, {
  required PolylineProperties<T> polylineProperties,
  required Future<String> Function(
    String filePath,
  ) fileLoadBuilder,
  Polyline<T> Function(
    List<LatLng> points,
    Map<String, Object?>? map,
  )? builder,
  MapController? mapController,
  Key? key,
  required Widget Function(int? statusCode)? fallback,
}) async {
  try {
    final String string = await fileLoadBuilder(file);
    return _string(
      checkEsri(string),
      polylineProperties: polylineProperties,
      builder: builder,
      mapController: mapController,
      key: key,
    );
  } catch (_) {
    return fallback?.call(null) ?? const Text('Not Found');
  }
}

/// Loads and displays polylines from a Uint8List in memory on a map.
///
/// The [_memoryPolylines] function loads polyline data from a Uint8List specified by
/// the [list] parameter and displays it on a map. You can customize the rendering
/// of the polylines using [polylineProperties] and [builder].
///
/// Example usage:
///
/// ```dart
/// FutureBuilder(
///   future: _memoryPolylines(
///     myUint8ListData,
///     polylineProperties: PolylineProperties(
///       color: Colors.blue,
///       width: 3.0,
///     ),
///     mapController: myMapController,
///   ),
///   builder: (context, snapshot) {
///     if (snapshot.connectionState == ConnectionState.done) {
///       if (snapshot.hasData) {
///         return snapshot.data ?? const SizedBox();
///       }
///     } else if (snapshot.connectionState == ConnectionState.waiting) {
///       return const Center(child: CircularProgressIndicator());
///     }
///     return const text('Error loading polylines');
///   },
/// )
/// ```
///
/// The [polylineCulling] parameter allows you to enable or disable culling of
/// polylines that are outside the map's viewport, improving performance.
///
/// Returns a widget displaying the loaded polylines on the map.
Future<Widget> _memoryPolylines<T extends Object>(
  Uint8List list, {
  required PolylineProperties<T> polylineProperties,
  Polyline<T> Function(
    List<LatLng> points,
    Map<String, Object?>? map,
  )? builder,
  MapController? mapController,
  Key? key,
}) async {
  String string = await strUint8List(list);
  return _string(
    checkEsri(string),
    polylineProperties: polylineProperties,
    builder: builder,
    mapController: mapController,
    key: key,
  );
}

/// Loads and displays polylines from an asset file on a map.
///
/// The [_assetPolylines] function loads polyline data from an asset file specified by
/// the [path] parameter and displays it on a map. You can customize the rendering
/// of the polylines using [polylineProperties] and [builder].
///
/// Example usage:
///
/// ```dart
/// FutureBuilder(
///   future: _assetPolylines(
///     'assets/polyline_data.json',
///     polylineProperties: PolylineProperties(
///       color: Colors.blue,
///       width: 3.0,
///     ),
///     mapController: myMapController,
///   ),
///   builder: (context, snapshot) {
///     if (snapshot.connectionState == ConnectionState.done) {
///       if (snapshot.hasData) {
///         return snapshot.data ?? const SizedBox();
///       }
///     } else if (snapshot.connectionState == ConnectionState.waiting) {
///       return const Center(child: CircularProgressIndicator());
///     }
///     return const text('Error loading polylines');
///   },
/// )
/// ```
///
/// The [polylineCulling] parameter allows you to enable or disable culling of
/// polylines that are outside the map's viewport, improving performance.
///
/// Returns a widget displaying the loaded polylines on the map.
Future<Widget> _assetPolylines<T extends Object>(
  String path, {
  required PolylineProperties<T> polylineProperties,
  Polyline<T> Function(
    List<LatLng> points,
    Map<String, Object?>? map,
  )? builder,
  MapController? mapController,
  Key? key,
}) async {
  final String string = await rootBundle.loadString(path);
  return _string(
    checkEsri(string),
    polylineProperties: polylineProperties,
    builder: builder,
    mapController: mapController,
    key: key,
  );
}

/// Loads and displays polylines from a network URL on a map.
///
/// The [_networkPolylines] function fetches polyline data from a network URL specified by
/// the [urlString] parameter and displays it on a map. You can customize the rendering
/// of the polylines using [polylineProperties] and [builder].
///
/// Example usage:
///
/// ```dart
/// FutureBuilder(
///   future: _networkPolylines(
///     Uri.parse('https://example.com/polyline_data.json'),
///     polylineProperties: PolylineProperties(
///       color: Colors.blue,
///       width: 3.0,
///     ),
///     mapController: myMapController,
///   ),
///   builder: (context, snapshot) {
///     if (snapshot.connectionState == ConnectionState.done) {
///       if (snapshot.hasData) {
///         return snapshot.data ?? const SizedBox();
///       }
///     } else if (snapshot.connectionState == ConnectionState.waiting) {
///       return const Center(child: CircularProgressIndicator());
///     }
///     return const text('Error loading polylines');
///   },
/// )
/// ```
///
/// The [polylineCulling] parameter allows you to enable or disable culling of
/// polylines that are outside the map's viewport, improving performance.
///
/// Returns a widget displaying the loaded polylines on the map.
Future<Widget> _networkPolylines<T extends Object>(
  Uri urlString, {
  Client? client,
  required List<int> statusCodes,
  Map<String, String>? headers,
  Key? key,
  required PolylineProperties<T> polylineProperties,
  Polyline<T> Function(
    List<LatLng> points,
    Map<String, Object?>? map,
  )? builder,
  MapController? mapController,
  required Widget Function(int? statusCode)? fallback,
}) async {
  Future<Response> Function(Uri url, {Map<String, String>? headers}) method = client == null ? get : client.get;
  Response response = await method(urlString, headers: headers);
  String string = response.body;
  if (statusCodes.contains(response.statusCode)) {
    return _string(
      checkEsri(string),
      polylineProperties: polylineProperties,
      builder: builder,
      mapController: mapController,
      key: key,
    );
  } else {
    return fallback?.call(response.statusCode) ?? Text('${response.statusCode}');
  }
}

/// Creates a widget to display polylines from GeoJSON string data on a map.
///
/// The [_string] function parses GeoJSON string data specified by the [string] parameter
/// and displays polylines on a map. You can customize the rendering of the polylines
/// using [polylineProperties] and [builder].
///
/// Example usage:
///
/// ```dart
/// _string(
///   myGeoJSONStringData,
///   polylineProperties: PolylineProperties(
///     color: Colors.blue,
///     width: 3.0,
///   ),
///   mapController: myMapController,
/// );
/// ```
///
/// The [polylineCulling] parameter allows you to enable or disable culling of
/// polylines that are outside the map's viewport, improving performance.
///
/// Returns a widget displaying the parsed polylines on the map.
Widget _string<T extends Object>(
  String string, {
  Key? key,
  required PolylineProperties<T> polylineProperties,
  Polyline<T> Function(
    List<LatLng> points,
    Map<String, Object?>? map,
  )? builder,
  MapController? mapController,
}) {
  final PowerGeoJSONFeatureCollection geojson = PowerGeoJSONFeatureCollection.fromJson(checkEsri(string));

  List<Polyline<T>> polylines = geojson.geoJSONLineStrings.map(
    (PowerGeoLineString e) {
      return builder != null
          ? builder(e.geometry.coordinates.toLatLng(), e.properties)
          : e.geometry.coordinates.toPolyline<T>(
              polylineProperties: PolylineProperties.fromMap(e.properties, polylineProperties),
            );
    },
  ).toList();

  List<List<double>?> bbox = geojson.geoJSONPoints.map((PowerGeoPoint e) => e.bbox).toList();
  zoomTo(bbox, mapController);
  return PolylineLayer<T>(
    polylines: polylines,
    key: key,
  );
}

class PowerGeoJSONPolylines {
  /// Loads and displays polylines from a network URL on a map.
  ///
  /// The [PowerGeoJSONPolylines.network] method fetches polyline data from a network URL specified by
  /// the [url] parameter and displays it on a map. You can customize the rendering
  /// of the polylines using [polylineProperties] and [builder].
  ///
  /// Example usage:
  ///
  /// ```dart
  /// PowerGeoJSONPolylines.network(
  ///   'https://example.com/polyline_data.json',
  ///   polylineProperties: PolylineProperties(
  ///     color: Colors.blue,
  ///     width: 3.0,
  ///   ),
  ///   mapController: myMapController,
  /// );
  /// ```
  ///
  /// The [polylineCulling] parameter allows you to enable or disable culling of
  /// polylines that are outside the map's viewport, improving performance.
  ///
  /// Returns a widget displaying the loaded polylines on the map.
  static Widget network<T extends Object>(
    String url, {
    Client? client,
    List<int> statusCodes = const <int>[200],
    Map<String, String>? headers,
    // layer
    Key? key,
    PolylineProperties<T>? polylineProperties,
    Widget Function(int? statusCode)? fallback,
    Polyline<T> Function(
      List<LatLng> points,
      Map<String, Object?>? map,
    )? builder,
    MapController? mapController,
  }) {
    Uri uriString = url.toUri();
    return EnhancedFutureBuilder<Widget>(
      future: _networkPolylines(
        uriString,
        headers: headers,
        client: client,
        statusCodes: statusCodes,
        polylineProperties: polylineProperties ?? PolylineProperties<T>(),
        builder: builder,
        fallback: fallback,
        mapController: mapController,
        key: key,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Loads and displays polylines from an asset file on a map.
  ///
  /// The [PowerGeoJSONPolylines.asset] method loads polyline data from an asset file specified by
  /// the [url] parameter and displays it on a map. You can customize the rendering
  /// of the polylines using [polylineProperties] and [builder].
  ///
  /// Example usage:
  ///
  /// ```dart
  /// PowerGeoJSONPolylines.asset(
  ///   'assets/polyline_data.json',
  ///   polylineProperties: PolylineProperties(
  ///     color: Colors.blue,
  ///     width: 3.0,
  ///   ),
  ///   mapController: myMapController,
  /// );
  /// ```
  ///
  /// The [polylineCulling] parameter allows you to enable or disable culling of
  /// polylines that are outside the map's viewport, improving performance.
  ///
  /// Returns a widget displaying the loaded polylines on the map.
  static Widget asset<T extends Object>(
    String url, {
    PolylineProperties<T>? polylineProperties,
    Polyline<T> Function(
      List<LatLng> points,
      Map<String, Object?>? map,
    )? builder,
    MapController? mapController,
    Key? key,
  }) {
    return EnhancedFutureBuilder<Widget>(
      future: _assetPolylines(
        url,
        polylineProperties: polylineProperties ?? PolylineProperties<T>(),
        builder: builder,
        mapController: mapController,
        key: key,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  static Widget file<T extends Object>(
    String file, {
    PolylineProperties<T>? polylineProperties,
    Polyline<T> Function(
      List<LatLng> points,
      Map<String, Object?>? map,
    )? builder,
    MapController? mapController,
    Future<String> Function(String)? fileLoadBuilder,
    Widget Function(int? statusCode)? fallback,
    Key? key,
  }) {
    if (AppPlatform.isWeb) {
      throw UnsupportedError('Unsupported platform: Web');
    }
    return EnhancedFutureBuilder<Widget>(
      future: _filePolylines(
        file,
        fileLoadBuilder: fileLoadBuilder ?? defaultFileLoadBuilder,
        polylineProperties: polylineProperties ?? PolylineProperties<T>(),
        builder: builder,
        fallback: fallback,
        mapController: mapController,
        key: key,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Loads and displays polylines from a local file on a map.
  ///
  /// The [PowerGeoJSONPolylines.file] method reads polyline data from a local file specified by
  /// the [path] parameter and displays it on a map. You can customize the rendering
  /// of the polylines using [polylineProperties] and [builder].
  ///
  /// Example usage:
  ///
  /// ```dart
  /// PowerGeoJSONPolylines.file(
  ///   '/path/to/local/polyline_data.json',
  ///   polylineProperties: PolylineProperties(
  ///     color: Colors.blue,
  ///     width: 3.0,
  ///   ),
  ///   mapController: myMapController,
  /// );
  /// ```
  ///
  /// The [polylineCulling] parameter allows you to enable or disable culling of
  /// polylines that are outside the map's viewport, improving performance.
  ///
  /// Returns a widget displaying the loaded polylines on the map.
  static Widget memory<T extends Object>(
    Uint8List bytes, {
    PolylineProperties<T>? polylineProperties,
    Polyline<T> Function(
      List<LatLng> points,
      Map<String, Object?>? map,
    )? builder,
    MapController? mapController,
    Key? key,
  }) {
    return EnhancedFutureBuilder<Widget>(
      future: _memoryPolylines(
        bytes,
        polylineProperties: polylineProperties ?? PolylineProperties<T>(),
        builder: builder,
        mapController: mapController,
        key: key,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Displays polylines from GeoJSON data provided as a string on a map.
  ///
  /// The [PowerGeoJSONPolylines.string] method takes GeoJSON data as a string
  /// provided in the [data] parameter and displays the polylines on a map.
  /// You can customize the rendering of the polylines using [polylineProperties] and [builder].
  ///
  /// Example usage:
  ///
  /// ```dart
  /// PowerGeoJSONPolylines.string(
  ///   '{ "type": "FeatureCollection", ... }',
  ///   polylineProperties: PolylineProperties(
  ///     color: Colors.blue,
  ///     width: 3.0,
  ///   ),
  ///   mapController: myMapController,
  /// );
  /// ```
  ///
  /// The [polylineCulling] parameter allows you to enable or disable culling of
  /// polylines that are outside the map's viewport, improving performance.
  ///
  /// Returns a widget displaying the loaded polylines on the map.
  static Widget string<T extends Object>(
    String data, {
    PolylineProperties<T>? polylineProperties,
    Polyline<T> Function(
      List<LatLng> points,
      Map<String, Object?>? map,
    )? builder,
    MapController? mapController,
    Key? key,
  }) {
    return _string(
      data,
      polylineProperties: polylineProperties ?? PolylineProperties<T>(),
      builder: builder,
      key: key,
      mapController: mapController,
    );
  }
}
