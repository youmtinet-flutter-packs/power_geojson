import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:geojson_vi/geojson_vi.dart';
import 'package:power_geojson/power_geojson.dart';

/// Represents a set of properties for customizing the appearance of GeoJSON feature collections.
///
class FeatureCollectionProperties {
  /// The properties for customizing markers.
  final MarkerProperties markerProperties;

  /// The properties for customizing polylines.
  final PolylineProperties polylineProperties;

  /// The properties for customizing polygons.
  final PolygonProperties polygonProperties;

  /// Creates a new instance of FeatureCollectionProperties with optional properties.
  ///
  /// The [markerProperties], [polylineProperties], and [polygonProperties] parameters
  /// allow you to specify custom properties for markers, polylines, and polygons within
  /// the GeoJSON feature collection.
  const FeatureCollectionProperties({
    this.markerProperties = const MarkerProperties(),
    this.polylineProperties = const PolylineProperties(),
    this.polygonProperties = const PolygonProperties(),
  });

  /// Creates a new FeatureCollectionProperties instance with updated properties.
  ///
  /// This method returns a new FeatureCollectionProperties instance with the provided
  /// properties while keeping the existing properties unchanged.
  ///
  /// - [markerProperties]: The properties for customizing markers.
  /// - [polylineProperties]: The properties for customizing polylines.
  /// - [polygonProperties]: The properties for customizing polygons.
  ///
  /// Returns a new FeatureCollectionProperties instance with updated properties.
  FeatureCollectionProperties copyWith({
    MarkerProperties? markerProperties,
    PolylineProperties? polylineProperties,
    PolygonProperties? polygonProperties,
  }) {
    return FeatureCollectionProperties(
      markerProperties: markerProperties ?? this.markerProperties,
      polylineProperties: polylineProperties ?? this.polylineProperties,
      polygonProperties: polygonProperties ?? this.polygonProperties,
    );
  }

  @override
  String toString() => 'FeatureCollectionProperties(markerProperties: $markerProperties, polylineProperties: $polylineProperties, polygonProperties: $polygonProperties)';

  @override
  bool operator ==(covariant FeatureCollectionProperties other) {
    if (identical(this, other)) return true;

    return other.markerProperties == markerProperties && other.polylineProperties == polylineProperties && other.polygonProperties == polygonProperties;
  }

  @override
  int get hashCode => markerProperties.hashCode ^ polylineProperties.hashCode ^ polygonProperties.hashCode;
}

/// Represents a feature in GeoJSON data, which can include geometry and associated properties.
abstract class PowerGeoFeature {
  /// The properties associated with the feature.
  Map<String, dynamic>? properties;

  /// The bounding box of the feature.
  List<double>? bbox;

  /// The title of the feature.
  String? title;

  /// The unique identifier of the feature.
  dynamic id;

  /// Parses a GeoJSON feature and returns a list of PowerGeoFeature instances.
  ///
  /// - [feature]: The GeoJSON feature to parse.
  ///
  /// Returns a list of PowerGeoFeature instances based on the provided GeoJSON feature.
  static List<PowerGeoFeature> parseFeature(GeoJSONFeature feature) {
    GeoJSONGeometry? geometry = feature.geometry;
    Map<String, dynamic>? properties = feature.properties;
    List<double>? bbox = feature.bbox;
    String? title = feature.title;
    dynamic id = feature.id;
    if (geometry == null) return [];
    return parseGeometry(geometry, properties: properties, bbox: bbox, title: title, id: id);
  }

  /// Parses a GeoJSON geometry and returns a list of PowerGeoFeature instances.
  ///
  /// - [geometry]: The GeoJSON geometry to parse.
  /// - [properties]: Optional properties to associate with the parsed features.
  /// - [bbox]: Optional bounding box to associate with the parsed features.
  /// - [title]: Optional title to associate with the parsed features.
  /// - [id]: Optional unique identifier to associate with the parsed features.
  ///
  /// Returns a list of PowerGeoFeature instances based on the provided GeoJSON geometry.
  static List<PowerGeoFeature> parseGeometry(
    GeoJSONGeometry geometry, {
    Map<String, dynamic>? properties,
    List<double>? bbox,
    String? title,
    dynamic id,
  }) {
    switch (geometry.type) {
      case GeoJSONType.point:
        var geom = geometry as GeoJSONPoint;
        var coordinates = geom.coordinates;
        return [
          PowerGeoPoint(
            geometry: GeoJSONPoint(coordinates),
            properties: properties,
            bbox: bbox,
            title: title,
            id: id,
          ),
        ];
      case GeoJSONType.multiPoint:
        var geom = geometry as GeoJSONMultiPoint;
        var coordinates = geom.coordinates;
        return coordinates
            .map((e) => PowerGeoPoint(
                  geometry: GeoJSONPoint(e),
                  properties: properties,
                  bbox: bbox,
                  title: title,
                  id: id,
                ))
            .toList();
      case GeoJSONType.lineString:
        var geom = geometry as GeoJSONLineString;
        var coordinates = geom.coordinates;
        return [
          PowerGeoLineString(
            geometry: GeoJSONLineString(coordinates),
            properties: properties,
            bbox: bbox,
            title: title,
            id: id,
          ),
        ];
      case GeoJSONType.multiLineString:
        var geom = geometry as GeoJSONMultiLineString;
        var coordinates = geom.coordinates;
        return coordinates
            .map((e) => PowerGeoLineString(
                  geometry: GeoJSONLineString(e),
                  properties: properties,
                  bbox: bbox,
                  title: title,
                  id: id,
                ))
            .toList();
      case GeoJSONType.polygon:
        var geom = geometry as GeoJSONPolygon;
        var coordinates = geom.coordinates;
        return [
          PowerGeoPolygon(
            geometry: GeoJSONPolygon(coordinates),
            properties: properties,
            bbox: bbox,
            title: title,
            id: id,
          ),
        ];
      case GeoJSONType.multiPolygon:
        var geom = geometry as GeoJSONMultiPolygon;
        var coordinates = geom.coordinates;
        return coordinates
            .map((e) => PowerGeoPolygon(
                  geometry: GeoJSONPolygon(e),
                  properties: properties,
                  bbox: bbox,
                  title: title,
                  id: id,
                ))
            .toList();
      case GeoJSONType.feature:
        var geom = geometry as GeoJSONFeature;
        var geometry2 = geom.geometry;
        if (geometry2 == null) return [];
        return parseGeometry(
          geometry2,
          properties: properties,
          bbox: bbox,
          title: title,
          id: id,
        );
      case GeoJSONType.featureCollection:
        GeoJSONFeatureCollection geom = geometry as GeoJSONFeatureCollection;
        List<GeoJSONFeature?> features = geom.features;
        Iterable<List<PowerGeoFeature>?> featuresParse = features.whereNotNull().map(
          (e) {
            GeoJSONGeometry? geometry3 = e.geometry;
            if (geometry3 == null) return null;
            return parseGeometry(
              geometry3,
              properties: properties,
              bbox: bbox,
              title: title,
              id: id,
            );
          },
        );
        return featuresParse.whereNotNull().expand((e) => e).toList();
      case GeoJSONType.geometryCollection:
        var geom = geometry as GeoJSONGeometryCollection;
        var coordinates = geom.geometries.map(
          (e) => parseGeometry(
            e,
            properties: properties,
            bbox: bbox,
            title: title,
            id: id,
          ),
        );
        return coordinates.expand((e) => e).toList();
    }
  }

  /// Creates a PowerGeoFeature instance with the provided properties.
  ///
  /// - [properties]: The properties associated with the feature.
  /// - [bbox]: The bounding box of the feature.
  /// - [title]: The title of the feature.
  /// - [id]: The unique identifier of the feature.
  PowerGeoFeature({
    this.properties,
    this.bbox,
    this.title,
    required this.id,
  });

  @override
  String toString() {
    return 'GeoFeature(properties: $properties, bbox: $bbox, title: $title, id: $id)';
  }

  @override
  bool operator ==(covariant PowerGeoFeature other) {
    if (identical(this, other)) return true;

    return mapEquals(other.properties, properties) && foundation.listEquals(other.bbox, bbox) && other.title == title && other.id == id;
  }

  @override
  int get hashCode {
    return properties.hashCode ^ bbox.hashCode ^ title.hashCode ^ id.hashCode;
  }
}

/// Represents a collection of PowerGeoFeatures that can include points, linestrings, and polygons.
class PowerGeoJSONFeatureCollection {
  /// List of PowerGeoPoint instances.
  List<PowerGeoPoint> geoJSONPoints;

  /// List of PowerGeoLineString instances.
  List<PowerGeoLineString> geoJSONLineStrings;

  /// List of PowerGeoPolygon instances.
  List<PowerGeoPolygon> geoJSONPolygons;

  /// Creates a PowerGeoJSONFeatureCollection with the specified lists of features.
  ///
  /// - [geoJSONPoints]: List of PowerGeoPoint instances.
  /// - [geoJSONLineStrings]: List of PowerGeoLineString instances.
  /// - [geoJSONPolygons]: List of PowerGeoPolygon instances.
  PowerGeoJSONFeatureCollection({
    required this.geoJSONPoints,
    required this.geoJSONLineStrings,
    required this.geoJSONPolygons,
  });

  /// Adds a list of PowerGeoPoint instances to the collection.
  ///
  /// - [geoJSONPoint]: List of PowerGeoPoint instances to add.
  ///
  /// Returns the updated list of PowerGeoPoint instances in the collection.
  List<PowerGeoPoint> addPoints(List<PowerGeoPoint> geoJSONPoint) {
    geoJSONPoints.addAll(geoJSONPoint);
    return geoJSONPoints;
  }

  /// Adds a list of PowerGeoLineString instances to the collection.
  ///
  /// - [geoJSONPoint]: List of PowerGeoLineString instances to add.
  ///
  /// Returns the updated list of PowerGeoLineString instances in the collection.
  List<PowerGeoLineString> addLines(List<PowerGeoLineString> geoJSONPoint) {
    geoJSONLineStrings.addAll(geoJSONPoint);
    return geoJSONLineStrings;
  }

  /// Adds a list of PowerGeoPolygon instances to the collection.
  ///
  /// - [geoJSONPoint]: List of PowerGeoPolygon instances to add.
  ///
  /// Returns the updated list of PowerGeoPolygon instances in the collection.
  List<PowerGeoPolygon> addPolygons(List<PowerGeoPolygon> geoJSONPoint) {
    geoJSONPolygons.addAll(geoJSONPoint);
    return geoJSONPolygons;
  }

  @override
  String toString() {
    return 'FeatureCollection(geoJSONPoints: $geoJSONPoints, geoJSONLineStrings: $geoJSONLineStrings, geoJSONPolygons: $geoJSONPolygons)';
  }

  /// Creates a copy of the PowerGeoJSONFeatureCollection with optional updates to its properties.
  ///
  /// - [geoJSONPoints]: Optional updated list of PowerGeoPoint instances.
  /// - [geoJSONLineStrings]: Optional updated list of PowerGeoLineString instances.
  /// - [geoJSONPolygons]: Optional updated list of PowerGeoPolygon instances.
  ///
  /// Returns a new PowerGeoJSONFeatureCollection instance.
  PowerGeoJSONFeatureCollection copyWith({
    List<PowerGeoPoint>? geoJSONPoints,
    List<PowerGeoLineString>? geoJSONLineStrings,
    List<PowerGeoPolygon>? geoJSONPolygons,
  }) {
    return PowerGeoJSONFeatureCollection(
      geoJSONPoints: geoJSONPoints ?? this.geoJSONPoints,
      geoJSONLineStrings: geoJSONLineStrings ?? this.geoJSONLineStrings,
      geoJSONPolygons: geoJSONPolygons ?? this.geoJSONPolygons,
    );
  }

  /// Converts the PowerGeoJSONFeatureCollection instance to a map.
  ///
  /// Returns a map representation of the PowerGeoJSONFeatureCollection.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'geoJSONPoints': geoJSONPoints.map((x) => x.toMap()).toList(),
      'geoJSONLineStrings': geoJSONLineStrings.map((x) => x.toMap()).toList(),
      'geoJSONPolygons': geoJSONPolygons.map((x) => x.toMap()).toList(),
    };
  }

  /// Creates a PowerGeoJSONFeatureCollection instance from a map.
  ///
  /// - [json]: A map representation of the PowerGeoJSONFeatureCollection.
  ///
  /// Returns a PowerGeoJSONFeatureCollection instance.
  factory PowerGeoJSONFeatureCollection.fromMap(Map<String, dynamic> json) {
    var type = json['type'];
    var featureCollectionDefault = PowerGeoJSONFeatureCollection(
      geoJSONPoints: [],
      geoJSONLineStrings: [],
      geoJSONPolygons: [],
    );
    switch (type) {
      case 'Point':
        GeoJSONPoint point = GeoJSONPoint.fromMap(json);
        var featureCollectionPoint = PowerGeoJSONFeatureCollection(
          geoJSONPoints: [PowerGeoPoint(geometry: point)],
          geoJSONLineStrings: [],
          geoJSONPolygons: [],
        );
        return featureCollectionPoint;

      // ... (other cases for different GeoJSON types)

      case 'FeatureCollection':
        GeoJSONFeatureCollection geoJSONFeatureCollection = GeoJSONFeatureCollection.fromMap(json);
        var features = geoJSONFeatureCollection.features;
        List<GeoJSONFeature> listFeatures = features.where((element) => element != null).map((e) => e as GeoJSONFeature).toList();
        List<PowerGeoFeature> listGeoFeatures = listFeatures.map(PowerGeoFeature.parseFeature).expand((e) => e).toList();
        return PowerGeoJSONFeatureCollection(
          geoJSONPoints: listGeoFeatures.whereType<PowerGeoPoint>().toList(),
          geoJSONLineStrings: listGeoFeatures.whereType<PowerGeoLineString>().toList(),
          geoJSONPolygons: listGeoFeatures.whereType<PowerGeoPolygon>().toList(),
        );
      default:
        return featureCollectionDefault;
    }
  }

  /// Converts the PowerGeoJSONFeatureCollection instance to a JSON string.
  ///
  /// Returns a JSON string representation of the PowerGeoJSONFeatureCollection.
  String toJson() => json.encode(toMap());

  /// Creates a PowerGeoJSONFeatureCollection instance from a JSON string.
  ///
  /// - [source]: A JSON string representing the PowerGeoJSONFeatureCollection.
  ///
  /// Returns a PowerGeoJSONFeatureCollection instance.
  factory PowerGeoJSONFeatureCollection.fromJson(String source) => PowerGeoJSONFeatureCollection.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant PowerGeoJSONFeatureCollection other) {
    if (identical(this, other)) return true;

    return foundation.listEquals(other.geoJSONPoints, geoJSONPoints) && foundation.listEquals(other.geoJSONLineStrings, geoJSONLineStrings) && foundation.listEquals(other.geoJSONPolygons, geoJSONPolygons);
  }

  @override
  int get hashCode {
    return geoJSONPoints.hashCode ^ geoJSONLineStrings.hashCode ^ geoJSONPolygons.hashCode;
  }
}

/// Represents a point geometry within a geographic feature.
class PowerGeoPoint extends PowerGeoFeature {
  /// The geographic point geometry.
  GeoJSONPoint geometry;

  /// Creates a PowerGeoPoint instance with the specified properties.
  ///
  /// - [properties]: Optional map of properties associated with the point.
  /// - [bbox]: Optional bounding box information.
  /// - [title]: Optional title for the point.
  /// - [id]: Unique identifier for the point.
  /// - [geometry]: The geographic point geometry.
  PowerGeoPoint({
    Map<String, dynamic>? properties,
    List<double>? bbox,
    String? title,
    dynamic id,
    required this.geometry,
  }) : super(properties: properties, bbox: bbox, title: title, id: id);

  /// Converts the PowerGeoPoint instance to a map.
  ///
  /// Returns a map representation of the PowerGeoPoint.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'geometry': geometry.toMap(),
    };
  }

  /// Converts the PowerGeoPoint instance to a JSON string.
  ///
  /// Returns a JSON string representation of the PowerGeoPoint.
  String toJson() => json.encode(toMap());

  @override
  String toString() => 'GeoPoint(geometry: $geometry)';

  @override
  bool operator ==(covariant PowerGeoPoint other) {
    if (identical(this, other)) return true;

    return other.geometry == geometry;
  }

  @override
  int get hashCode => geometry.hashCode;
}

/// Represents a line string geometry within a geographic feature.
class PowerGeoLineString extends PowerGeoFeature {
  /// The geographic line string geometry.
  GeoJSONLineString geometry;

  /// Creates a PowerGeoLineString instance with the specified properties.
  ///
  /// - [properties]: Optional map of properties associated with the line string.
  /// - [bbox]: Optional bounding box information.
  /// - [title]: Optional title for the line string.
  /// - [id]: Unique identifier for the line string.
  /// - [geometry]: The geographic line string geometry.
  PowerGeoLineString({
    Map<String, dynamic>? properties,
    List<double>? bbox,
    String? title,
    dynamic id,
    required this.geometry,
  }) : super(properties: properties, bbox: bbox, title: title, id: id);

  /// Converts the PowerGeoLineString instance to a map.
  ///
  /// Returns a map representation of the PowerGeoLineString.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'geometry': geometry.toMap(),
    };
  }

  /// Converts the PowerGeoLineString instance to a JSON string.
  ///
  /// Returns a JSON string representation of the PowerGeoLineString.
  String toJson() => json.encode(toMap());

  @override
  String toString() => 'GeoLineString(geometry: $geometry)';

  @override
  bool operator ==(covariant PowerGeoLineString other) {
    if (identical(this, other)) return true;

    return other.geometry == geometry;
  }

  @override
  int get hashCode => geometry.hashCode;
}

/// Represents a polygon geometry within a geographic feature.
class PowerGeoPolygon extends PowerGeoFeature {
  /// The geographic polygon geometry.
  GeoJSONPolygon geometry;

  /// Creates a PowerGeoPolygon instance with the specified properties.
  ///
  /// - [properties]: Optional map of properties associated with the polygon.
  /// - [bbox]: Optional bounding box information.
  /// - [title]: Optional title for the polygon.
  /// - [id]: Unique identifier for the polygon.
  /// - [geometry]: The geographic polygon geometry.
  PowerGeoPolygon({
    Map<String, dynamic>? properties,
    List<double>? bbox,
    String? title,
    dynamic id,
    required this.geometry,
  }) : super(properties: properties, bbox: bbox, title: title, id: id);

  /// Converts the PowerGeoPolygon instance to a map.
  ///
  /// Returns a map representation of the PowerGeoPolygon.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'geometry': geometry.toMap(),
    };
  }

  /// Converts the PowerGeoPolygon instance to a JSON string.
  ///
  /// Returns a JSON string representation of the PowerGeoPolygon.
  String toJson() => json.encode(toMap());

  @override
  String toString() => 'GeoPolygon(geometry: $geometry)';

  @override
  bool operator ==(covariant PowerGeoPolygon other) {
    if (identical(this, other)) return true;

    return other.geometry == geometry;
  }

  @override
  int get hashCode => geometry.hashCode;
}
