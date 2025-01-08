import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:http/http.dart';
import 'package:power_geojson/power_geojson.dart';
export 'properties.dart';

/// Loads an image asset named 'drop-pin.png' from the 'packages/power_geojson/icons/'
/// directory using the Flutter framework's `rootBundle`.
///
/// This function is asynchronous and returns a `Future` that resolves to a `List<int>`
/// representing the binary image data.
///
///
/// Returns a `Future` containing a `List<int>` representing the image data.
Future<List<int>> _loadAssetImage() async {
  // Load the image asset data asynchronously.
  final ByteData data = await rootBundle.load('packages/power_geojson/icons/drop-pin.png');

  // Convert the ByteData buffer to a List<int>.
  final List<int> bytes = data.buffer.asUint8List();

  return bytes;
}

/// Asynchronously creates a collection of markers based on data read from a file.
///
/// This function reads data from a file specified by the [path] parameter, which should
/// contain GeoJSON data. It then processes the GeoJSON data and generates markers using
/// the provided [builder] function or a default marker builder.
///
/// The [markerLayerProperties] parameter defines the appearance of the marker layer.
///
/// The [mapController] parameter can be used to control the map view associated with the markers.
///
/// The [key] parameter is optional and can be used to uniquely identify this widget.
///
/// Example Usage:
///
/// ```dart
/// Future<Widget> fileMarkerWidget = _fileMarkers(
///   'path_to_geojson_file.json',
///   markerLayerProperties: MarkerProperties(height: 48, width: 48),
///   builder: (context, markerProperties, properties) {
///     // Custom marker builder logic
///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
///   },
///   mapController: myMapController,
///   key: UniqueKey(),
/// );
/// ```
///
/// Returns a widget representing the markers generated from the GeoJSON data.
Future<Widget> _fileMarkers(
  String file, {
  required MarkerProperties markerLayerProperties,
  required Widget Function(
    BuildContext context,
    MarkerProperties markerProperties,
    Map<String, dynamic>? map,
  )? builder,
  required Future<String> Function(
    String filePath,
  ) fileLoadBuilder,
  MapController? mapController,
  Key? key,
  required PowerMarkerClusterOptions? powerClusterOptions,
  required Widget Function(int? statusCode)? fallback,
}) async {
  final string = await fileLoadBuilder(file);
  return _string(
    checkEsri(string),
    powerClusterOptions: powerClusterOptions,
    markerProperties: markerLayerProperties,
    mapController: mapController,
    key: key,
    builder: builder,
  );
}

/// Asynchronously creates a collection of markers based on GeoJSON data provided as a Uint8List.
///
/// This function processes GeoJSON data provided as a Uint8List, and generates markers using
/// the provided [builder] function or a default marker builder.
///
/// The [list] parameter should contain GeoJSON data in the form of a Uint8List.
///
/// The [markerLayerProperties] parameter defines the appearance of the marker layer.
///
/// The [mapController] parameter can be used to control the map view associated with the markers.
///
/// The [key] parameter is optional and can be used to uniquely identify this widget.
///
/// Example Usage:
///
/// ```dart
/// Future<Widget> memoryMarkerWidget = _memoryMarkers(
///   myUint8ListGeoJSONData,
///   markerLayerProperties: MarkerProperties(height: 48, width: 48),
///   builder: (context, markerProperties, properties) {
///     // Custom marker builder logic
///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
///   },
///   mapController: myMapController,
///   key: UniqueKey(),
/// );
/// ```
///
/// Returns a widget representing the markers generated from the provided GeoJSON data.
Future<Widget> _memoryMarkers(
  Uint8List list, {
  required MarkerProperties markerLayerProperties,
  required Widget Function(
    BuildContext context,
    MarkerProperties markerProperties,
    Map<String, dynamic>? map,
  )? builder,
  MapController? mapController,
  Key? key,
  required PowerMarkerClusterOptions? powerClusterOptions,
}) async {
  String string = await strUint8List(list);
  return _string(
    checkEsri(string),
    powerClusterOptions: powerClusterOptions,
    markerProperties: markerLayerProperties,
    mapController: mapController,
    key: key,
    builder: builder,
  );
}

/// Asynchronously creates a collection of markers based on GeoJSON data loaded from an asset file.
///
/// This function loads GeoJSON data from an asset file specified by the [path] parameter
/// and generates markers using the provided [builder] function or a default marker builder.
///
/// The [path] parameter specifies the path to the GeoJSON asset file.
///
/// The [markerProperties] parameter defines the appearance of the marker layer.
///
/// The [mapController] parameter can be used to control the map view associated with the markers.
///
/// The [key] parameter is optional and can be used to uniquely identify this widget.
///
/// Example Usage:
///
/// ```dart
/// Future<Widget> assetMarkerWidget = _assetMarkers(
///   'assets/my_geojson_data.json',
///   markerProperties: MarkerProperties(height: 48, width: 48),
///   builder: (context, markerProperties, properties) {
///     // Custom marker builder logic
///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
///   },
///   mapController: myMapController,
///   key: UniqueKey(),
/// );
/// ```
///
/// Returns a widget representing the markers generated from the provided GeoJSON asset file.
Future<Widget> _assetMarkers(
  String path, {
  required MarkerProperties markerProperties,
  MapController? mapController,
  required Widget Function(BuildContext context, MarkerProperties markerProperties, Map<String, dynamic>? map)? builder,
  Key? key,
  required PowerMarkerClusterOptions? powerClusterOptions,
}) async {
  final string = await rootBundle.loadString(path);
  return _string(
    checkEsri(string),
    powerClusterOptions: powerClusterOptions,
    markerProperties: markerProperties,
    mapController: mapController,
    key: key,
    builder: builder,
  );
}

/// Asynchronously creates a collection of markers based on GeoJSON data retrieved from a network URL.
///
/// This function performs an HTTP GET request to the specified [urlString] to fetch GeoJSON data.
/// It then generates markers using the provided [builder] function or a default marker builder.
///
/// The [urlString] parameter specifies the URL of the GeoJSON data.
///
/// The [markerLayerProperties] parameter defines the appearance of the marker layer.
///
/// The [key] parameter is optional and can be used to uniquely identify this widget.
///
/// The [client] parameter allows you to specify an optional HTTP client for making the network request.
///
/// The [headers] parameter allows you to specify optional HTTP headers for the network request.
///
/// The [mapController] parameter can be used to control the map view associated with the markers.
///
/// Example Usage:
///
/// ```dart
/// Future<Widget> networkMarkerWidget = _networkMarkers(
///   Uri.parse('https://example.com/my_geojson_data.json'),
///   markerLayerProperties: MarkerProperties(height: 48, width: 48),
///   builder: (context, markerProperties, properties) {
///     // Custom marker builder logic
///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
///   },
///   mapController: myMapController,
///   key: UniqueKey(),
/// );
/// ```
///
/// Returns a widget representing the markers generated from the GeoJSON data fetched from the network URL.
Future<Widget> _networkMarkers(
  Uri urlString, {
  required MarkerProperties markerLayerProperties,
  Key? key,
  Client? client,
  required List<int> statusCodes,
  Map<String, String>? headers,
  required Widget Function(
    BuildContext context,
    MarkerProperties markerProperties,
    Map<String, dynamic>? map,
  )? builder,
  MapController? mapController,
  required Widget Function(int? statusCode)? fallback,
  required PowerMarkerClusterOptions? powerClusterOptions,
}) async {
  var method = client == null ? get : client.get;
  var response = await method(urlString, headers: headers);
  var string = response.body;
  if (statusCodes.contains(response.statusCode)) {
    return _string(
      checkEsri(string),
      powerClusterOptions: powerClusterOptions,
      markerProperties: markerLayerProperties,
      mapController: mapController,
      key: key,
      builder: builder,
    );
  } else {
    return fallback?.call(response.statusCode) ?? Text('${response.statusCode}');
  }
}

/// Parses a GeoJSON string and generates a marker layer with markers based on the GeoJSON data.
///
/// This function takes a [string] representing GeoJSON data and creates a collection of markers
/// from the GeoJSON Point features contained within it.
///
/// The [key] parameter is optional and can be used to uniquely identify this widget.
///
/// The [builder] parameter is an optional function that can be used to customize the appearance of markers.
/// If not provided, a default marker builder is used.
///
/// The [markerProperties] parameter defines the appearance properties for the markers.
///
/// The [mapController] parameter can be used to control the map view associated with the markers.
///
/// Example Usage:
///
/// ```dart
/// Widget geoJsonMarkers = _string(
///   '{"type": "FeatureCollection", "features": [{"type": "Feature", "geometry": {"type": "Point", "coordinates": [0, 0]}}]}',
///   markerPropertie: MarkerProperties(height: 48, width: 48),
///   builder: (context, markerProperties, properties) {
///     // Custom marker builder logic
///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
///   },
///   mapController: myMapController,
///   key: UniqueKey(),
/// );
/// ```
///
/// Returns a widget representing the marker layer generated from the parsed GeoJSON data.
Widget _string(
  String string, {
  Key? key,
  // Marker properties
  Widget Function(BuildContext context, MarkerProperties markerProperties, Map<String, dynamic>? map)? builder,
  required MarkerProperties markerProperties,
  // Other properties
  MapController? mapController,
  required PowerMarkerClusterOptions? powerClusterOptions,
}) {
  PowerGeoJSONFeatureCollection geojson = PowerGeoJSONFeatureCollection.fromJson(checkEsri(string));

  List<PowerMarker> markers = geojson.geoJSONPoints.map(
    (e) {
      return e.geometry.coordinates.toPowerMarker(
        markerProperties: MarkerProperties.fromMap(e.properties, markerProperties),
        properties: e.properties,
        child: Builder(
          builder: (context) {
            return (builder ?? PowerGeoJSONMarkers.defaultMarkerBuilder)(
              context,
              markerProperties,
              e.properties,
            );
          },
        ),
      );
    },
  ).toList();

  List<List<double>?> bbox = geojson.geoJSONPoints.map((e) => e.bbox).toList();
  zoomTo(bbox, mapController);

  if (powerClusterOptions != null) {
    return MarkerClusterLayerWidget(
      options: powerClusterOptions.toClusterOptions(powerClusterOptions, markers),
    );
  } else {
    return MarkerLayer(
      markers: markers,
      rotate: markerProperties.rotate ?? false,
      alignment: markerProperties.rotateAlignment ?? Alignment.center,
      key: key,
    );
  }
}

/// A utility class for fetching and rendering markers from various sources.
///
/// The [PowerGeoJSONMarkers] class provides static methods for fetching and rendering markers
/// from network sources, assets, files, memory, and GeoJSON strings.
///
/// Example Usage:
///
/// ```dart
/// // Fetch and render markers from a network source
/// Widget networkMarkers = PowerGeoJSONMarkers.network(
///   'https://example.com/markers.geojson',
///   markerProperties: MarkerProperties(height: 48, width: 48),
///   builder: (context, markerProperties, properties) {
///     // Custom marker builder logic
///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
///   },
///   mapController: myMapController,
///   key: UniqueKey(),
/// );
///
/// // Fetch and render markers from an asset
/// Widget assetMarkers = PowerGeoJSONMarkers.asset(
///   'assets/markers.geojson',
///   markerProperties: MarkerProperties(height: 48, width: 48),
///   builder: (context, markerProperties, properties) {
///     // Custom marker builder logic
///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
///   },
///   mapController: myMapController,
///   key: UniqueKey(),
/// );
///
/// // Fetch and render markers from a file
/// Widget fileMarkers = PowerGeoJSONMarkers.file(
///   '/path/to/markers.geojson',
///   markerProperties: MarkerProperties(height: 48, width: 48),
///   builder: (context, markerProperties, properties) {
///     // Custom marker builder logic
///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
///   },
///   mapController: myMapController,
///   key: UniqueKey(),
/// );
///
/// // Render markers from GeoJSON string
/// Widget geoJsonMarkers = PowerGeoJSONMarkers.string(
///   '{"type": "FeatureCollection", "features": [{"type": "Feature", "geometry": {"type": "Point", "coordinates": [0, 0]}}]}',
///   markerProperties: MarkerProperties(height: 48, width: 48),
///   builder: (context, markerProperties, properties) {
///     // Custom marker builder logic
///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
///   },
///   mapController: myMapController,
///   key: UniqueKey(),
/// );
/// ```
class PowerGeoJSONMarkers {
  /// Default marker builder function used to create markers for a map.
  ///
  /// This function asynchronously loads an image asset, 'drop-pin.png', and creates a marker
  /// with the loaded image using the provided [markerProperties] for customization.
  ///
  /// The [context] is required for building the widget tree, [markerProperties] defines the
  /// appearance of the marker, and [properties] is an optional map of additional properties
  /// associated with the marker.
  ///
  /// If the image asset is successfully loaded, an [Image] widget displaying the image is returned.
  /// If the asset loading is still in progress, a [CupertinoActivityIndicator] is displayed
  /// as a loading indicator.
  ///
  /// Example Usage:
  ///
  /// ```dart
  /// Widget marker = _defaultMarkerBuilder(
  ///   context,
  ///   MarkerProperties(height: 48, width: 48),
  ///   {'property1': 'value1', 'property2': 'value2'},
  /// );
  /// ```
  ///
  /// Returns a widget representing the marker.
  static Widget defaultMarkerBuilder(
    BuildContext context,
    MarkerProperties markerProperties,
    Map<String, Object?>? properties, {
    Color? color,
  }) {
    return EnhancedFutureBuilder<List<int>>(
      future: _loadAssetImage(),
      rememberFutureResult: true,
      whenDone: (snapshotData) {
        Uint8List uint8list = Uint8List.fromList(snapshotData);
        return Image(
          image: MemoryImage(uint8list),
          color: color,
          height: markerProperties.height,
          width: markerProperties.width,
        );
      },
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Fetches and renders markers from a network source using GeoJSON data.
  ///
  /// The [network] method fetches GeoJSON data from the specified [url] and renders markers
  /// on the map based on the GeoJSON feature collection. You can customize the appearance
  /// of the markers using [markerProperties] and provide a custom marker builder function [builder].
  ///
  /// Example Usage:
  ///
  /// ```dart
  /// // Fetch and render markers from a network source
  /// Widget networkMarkers = PowerGeoJSONMarkers.network(
  ///   'https://example.com/markers.geojson',
  ///   markerProperties: MarkerProperties(height: 48, width: 48),
  ///   builder: (context, markerProperties, properties) {
  ///     // Custom marker builder logic
  ///     return MyCustomMarkerWidget(markerProperties: markerProperties, data: properties);
  ///   },
  ///   mapController: myMapController,
  ///   key: UniqueKey(),
  /// );
  /// ```
  ///
  /// Parameters:
  /// - [url]: The URL of the GeoJSON data source.
  /// - [client]: (Optional) A custom HTTP client for making the network request.
  /// - [headers]: (Optional) Additional HTTP headers for the network request.
  /// - [builder]: (Optional) A custom marker builder function that takes context, marker properties,
  ///   and properties map as arguments.
  /// - [markerProperties]: The properties to customize the appearance of the markers.
  /// - [mapController]: (Optional) The map controller used to adjust the map view based on marker bounds.
  /// - [key]: (Optional) A unique key for the widget.
  ///
  /// Returns a [Widget] representing the fetched and rendered markers.
  static Widget network(
    String url, {
    Client? client,
    Map<String, String>? headers,
    List<int> statusCodes = const [200],
    Widget Function(BuildContext context, MarkerProperties markerProperties, Map<String, dynamic>? map)? builder,
    required MarkerProperties markerProperties,
    MapController? mapController,
    Key? key,
    Widget Function(int? statusCode)? fallback,
    PowerMarkerClusterOptions? powerClusterOptions,
  }) {
    var uriString = url.toUri();
    return EnhancedFutureBuilder(
      future: _networkMarkers(
        uriString,
        powerClusterOptions: powerClusterOptions,
        headers: headers,
        client: client,
        statusCodes: statusCodes,
        markerLayerProperties: markerProperties,
        builder: builder,
        mapController: mapController,
        fallback: fallback,
        key: key,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Creates a widget that displays a marker on a map using an asset image.
  ///
  /// The `url` parameter specifies the asset image URL to be used as the marker icon.
  ///
  /// The `markerProperties` parameter is required and contains properties for the marker,
  /// such as position and rotation.
  ///
  /// The `mapController` parameter allows you to specify a custom [MapController] to control
  /// the map view. If not provided, the default [MapController] will be used.
  ///
  /// The `builder` parameter is an optional callback function that allows you to customize
  /// the marker widget's appearance. It takes a [BuildContext], [MarkerProperties], and a
  /// map of extra data as arguments and should return a widget. If not provided, a default
  /// marker widget will be used.
  ///
  /// The `key` parameter is an optional key that can be used to uniquely identify this widget.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// asset(
  ///   'assets/marker.png',
  ///   markerProperties: MarkerProperties(
  ///     position: LatLng(37.7749, -122.4194),
  ///     rotation: 45.0,
  ///   ),
  ///   mapController: myMapController,
  ///   builder: (context, markerProperties, extraData) {
  ///     return Icon(Icons.location_on, color: Colors.red);
  ///   },
  /// )
  /// ```
  ///
  /// In this example, the `asset` widget will display a marker on the map using the
  /// 'assets/marker.png' image, with custom properties, a custom builder function,
  /// and a specified map controller.
  ///
  /// Returns a [FutureBuilder] widget that will build the marker widget once the asset is loaded.
  static Widget asset(
    String url, {
    required MarkerProperties markerProperties,
    MapController? mapController,
    Widget Function(BuildContext context, MarkerProperties markerProperties, Map<String, dynamic>? map)? builder,
    Key? key,
    PowerMarkerClusterOptions? powerClusterOptions,
  }) {
    return EnhancedFutureBuilder(
      future: _assetMarkers(
        url,
        powerClusterOptions: powerClusterOptions,
        markerProperties: markerProperties,
        mapController: mapController,
        builder: builder,
        key: key,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Creates a widget that displays a marker on a map using an image file located
  /// at the specified `path`.
  ///
  /// The `path` parameter specifies the file path to the image that will be used
  /// as the marker icon.
  ///
  /// The `markerProperties` parameter is required and contains properties for the marker,
  /// such as position and rotation.
  ///
  /// The `mapController` parameter allows you to specify a custom [MapController] to control
  /// the map view. If not provided, the default [MapController] will be used.
  ///
  /// The `builder` parameter is an optional callback function that allows you to customize
  /// the marker widget's appearance. It takes a [BuildContext], [MarkerProperties], and a
  /// map of extra data as arguments and should return a widget. If not provided, a default
  /// marker widget will be used.
  ///
  /// The `key` parameter is an optional key that can be used to uniquely identify this widget.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// file(
  ///   '/path/to/marker.png',
  ///   markerProperties: MarkerProperties(
  ///     position: LatLng(37.7749, -122.4194),
  ///     rotation: 45.0,
  ///   ),
  ///   mapController: myMapController,
  ///   builder: (context, markerProperties, extraData) {
  ///     return Icon(Icons.location_on, color: Colors.blue);
  ///   },
  /// )
  /// ```
  ///
  /// In this example, the `file` widget will display a marker on the map using the
  /// image file located at '/path/to/marker.png', with custom properties, a custom
  /// builder function, and a specified map controller.
  ///
  /// Returns a [FutureBuilder] widget that will build the marker widget once the file
  /// is loaded.
  static Widget file(
    String file, {
    required MarkerProperties markerProperties,
    MapController? mapController,
    Key? key,
    Future<String> Function(String)? fileLoadBuilder,
    Widget Function(BuildContext context, MarkerProperties markerProperties, Map<String, dynamic>? map)? builder,
    Widget Function(int? statusCode)? fallback,
    PowerMarkerClusterOptions? powerClusterOptions,
  }) {
    if (AppPlatform.isWeb) {
      throw UnsupportedError('Unsupported platform: Web');
    }
    return EnhancedFutureBuilder(
      future: _fileMarkers(
        file,
        fileLoadBuilder: fileLoadBuilder ?? defaultFileLoadBuilder,
        powerClusterOptions: powerClusterOptions,
        markerLayerProperties: markerProperties,
        mapController: mapController,
        builder: builder,
        fallback: fallback,
        key: key,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Creates a widget that displays a marker on a map using image data provided as
  /// a `Uint8List`.
  ///
  /// The `bytes` parameter specifies the image data as a `Uint8List` that will be used
  /// as the marker icon.
  ///
  /// The `markerLayerProperties` parameter is required and contains properties for the marker,
  /// such as position and rotation.
  ///
  /// The `mapController` parameter allows you to specify a custom [MapController] to control
  /// the map view. If not provided, the default [MapController] will be used.
  ///
  /// The `builder` parameter is an optional callback function that allows you to customize
  /// the marker widget's appearance. It takes a [BuildContext], [MarkerProperties], and a
  /// map of extra data as arguments and should return a widget. If not provided, a default
  /// marker widget will be used.
  ///
  /// The `key` parameter is an optional key that can be used to uniquely identify this widget.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// memory(
  ///   myImageBytes,
  ///   markerLayerProperties: MarkerProperties(
  ///     position: LatLng(37.7749, -122.4194),
  ///     rotation: 45.0,
  ///   ),
  ///   mapController: myMapController,
  ///   builder: (context, markerProperties, extraData) {
  ///     return Icon(Icons.location_on, color: Colors.green);
  ///   },
  /// )
  /// ```
  ///
  /// In this example, the `memory` widget will display a marker on the map using the
  /// image data provided in `myImageBytes`, with custom properties, a custom builder
  /// function, and a specified map controller.
  ///
  /// Returns a [FutureBuilder] widget that will build the marker widget once the image data
  /// is loaded.
  static Widget memory(
    Uint8List bytes, {
    required MarkerProperties markerLayerProperties,
    MapController? mapController,
    Key? key,
    Widget Function(BuildContext context, MarkerProperties markerProperties, Map<String, dynamic>? map)? builder,
    PowerMarkerClusterOptions? powerClusterOptions,
  }) {
    return EnhancedFutureBuilder(
      future: _memoryMarkers(
        bytes,
        powerClusterOptions: powerClusterOptions,
        markerLayerProperties: markerLayerProperties,
        mapController: mapController,
        builder: builder,
        key: key,
      ),
      rememberFutureResult: true,
      whenDone: (Widget snapshotData) => snapshotData,
      whenNotDone: const Center(child: CupertinoActivityIndicator()),
    );
  }

  /// Creates a widget that displays a marker on a map using data provided as a `String`.
  ///
  /// The `data` parameter specifies the data as a `String` that will be used as the
  /// marker icon.
  ///
  /// The `markerProperties` parameter is required and contains properties for the marker,
  /// such as position and rotation.
  ///
  /// The `mapController` parameter allows you to specify a custom [MapController] to control
  /// the map view. If not provided, the default [MapController] will be used.
  ///
  /// The `builder` parameter is an optional callback function that allows you to customize
  /// the marker widget's appearance. It takes a [BuildContext], [MarkerProperties], and a
  /// map of extra data as arguments and should return a widget. If not provided, a default
  /// marker widget will be used.
  ///
  /// The `key` parameter is an optional key that can be used to uniquely identify this widget.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// string(
  ///   'https://example.com/marker.png',
  ///   markerProperties: MarkerProperties(
  ///     position: LatLng(37.7749, -122.4194),
  ///     rotation: 45.0,
  ///   ),
  ///   mapController: myMapController,
  ///   builder: (context, markerProperties, extraData) {
  ///     return Icon(Icons.location_on, color: Colors.orange);
  ///   },
  /// )
  /// ```
  ///
  /// In this example, the `string` widget will display a marker on the map using the
  /// provided data as the marker icon, with custom properties, a custom builder
  /// function, and a specified map controller.
  ///
  /// Returns a widget that displays the marker on the map.
  static Widget string(
    String data, {
    required MarkerProperties markerProperties,
    MapController? mapController,
    Key? key,
    PowerMarkerClusterOptions? powerClusterOptions,
    Widget Function(BuildContext context, MarkerProperties markerProperties, Map<String, dynamic>? properties)? builder,
  }) {
    return _string(
      data,
      powerClusterOptions: powerClusterOptions,
      markerProperties: markerProperties,
      key: key,
      builder: builder,
      mapController: mapController,
    );
  }
}
