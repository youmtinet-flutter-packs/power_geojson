import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:power_geojson/power_geojson.dart';

/// Enum defining indexes for polygon layer properties.
///
/// The `LayerPolygonIndexes` enum is used to define indexes for accessing
/// specific properties of a polygon layer.
///
/// - `fillColor`: Index for the fill color of polygons.
/// - `label`: Index for labels associated with polygons.
/// - `borderStokeWidth`: Index for the border/stroke width of polygons.
/// - `borderColor`: Index for the border/stroke color of polygons.
///
/// Example usage:
///
/// ```dart
/// LayerPolygonIndexes index = LayerPolygonIndexes.fillColor;
/// if (index == LayerPolygonIndexes.fillColor) {
///   // Handle fill color property
/// }
/// ```
enum LayerPolygonIndexes {
  /// Index for the fill color of polygons.
  fillColor,

  /// Index for labels associated with polygons.
  label,

  /// Index for the border/stroke width of polygons.
  borderStokeWidth,

  /// Index for the border/stroke color of polygons.
  borderColor,
}

/// A class representing properties for rendering polygons on a map.
///
/// The `PolygonProperties` class encapsulates various properties for rendering
/// polygons, such as fill color, border color, label, stroke width, and more.
///
/// Example usage:
///
/// ```dart
/// PolygonProperties properties = PolygonProperties(
///   fillColor: Colors.blue,
///   borderColor: Colors.red,
///   label: 'Polygon Label',
///   isFilled: true,
///   borderStokeWidth: 2,
/// );
/// ```
class PolygonProperties<T extends Object> {
  /// Default fill color for polygons.
  static const Color defFillColor = Color(0x9C2195F3);

  /// Default value indicating whether holes should disable their border.
  static const bool defDisableHolesBorder = true;

  /// Default value indicating whether polygons should be filled.
  static const bool defIsFilled = true;

  /// Default label for polygons.
  static const String defLabel = '';

  /// Default border/stroke width for polygons.
  static const double defBorderStokeWidth = 2;

  /// Default border/stroke color for polygons.
  static const Color defBorderColor = Color(0xFF1E00FD);

  /// Default value indicating whether polygons are labeled.
  static const bool defLabeled = false;

  /// Default value indicating whether polygons are rendered as dotted lines.
  static const StrokePattern defIsDotted = StrokePattern.solid();

  /// Default label placement for polygons.
  static const PolygonLabelPlacement defLabelPlacement = PolygonLabelPlacement.polylabel;

  /// Default label style for polygons.
  static const TextStyle defLabelStyle = TextStyle();

  /// Default value indicating whether labels should be rotated.
  static const bool defRotateLabel = false;

  /// Default stroke cap style for polygons.
  static const StrokeCap defStrokeCap = StrokeCap.round;

  /// Default stroke join style for polygons.
  static const StrokeJoin defStrokeJoin = StrokeJoin.round;

  /// The fill color of polygons.
  final Color? fillColor;

  /// The label associated with polygons.
  final String label;

  /// The border/stroke width of polygons.
  final double borderStokeWidth;

  /// The border/stroke color of polygons.
  final Color borderColor;

  final bool isFilled;

  /// Indicates whether holes should disable their border.
  final bool disableHolesBorder;

  /// Indicates whether polygons are labeled.
  final bool labeled;

  /// Indicates whether polygons are rendered as dotted lines.
  final StrokePattern pattern;

  /// The polygon layer properties.
  final Map<LayerPolygonIndexes, String>? layerProperties;

  /// The label placement for polygons.
  final PolygonLabelPlacement labelPlacement;

  /// The label style for polygons.
  final TextStyle labelStyle;

  /// Indicates whether labels should be rotated.
  final bool rotateLabel;

  /// hint value.
  final T? hintValue;

  /// The stroke cap style for polygons.
  final StrokeCap strokeCap;

  /// The stroke join style for polygons.
  final StrokeJoin strokeJoin;

  /// Creates a new `PolygonProperties` instance.
  ///
  /// You can customize the rendering properties of polygons by providing
  /// values for the various parameters.
  ///
  /// Example:
  ///
  /// ```dart
  /// PolygonProperties properties = PolygonProperties(
  ///   fillColor: Colors.blue,
  ///   borderColor: Colors.red,
  ///   label: 'Polygon Label',
  ///   isFilled: true,
  ///   borderStokeWidth: 2,
  /// );
  /// ```

  const PolygonProperties({
    this.layerProperties,
    this.labeled = PolygonProperties.defLabeled,
    this.pattern = PolygonProperties.defIsDotted,
    this.labelPlacement = PolygonProperties.defLabelPlacement,
    this.labelStyle = PolygonProperties.defLabelStyle,
    this.rotateLabel = PolygonProperties.defRotateLabel,
    this.strokeCap = PolygonProperties.defStrokeCap,
    this.strokeJoin = PolygonProperties.defStrokeJoin,
    this.fillColor = PolygonProperties.defFillColor,
    this.label = PolygonProperties.defLabel,
    this.hintValue,
    this.borderStokeWidth = PolygonProperties.defBorderStokeWidth,
    this.borderColor = PolygonProperties.defBorderColor,
    this.disableHolesBorder = PolygonProperties.defDisableHolesBorder,
    this.isFilled = PolygonProperties.defIsFilled,
  });

  /// Creates a `PolygonProperties` instance from a map of properties.
  ///
  /// The [properties] parameter is a map containing properties for customizing
  /// polygon rendering. It can be used to override the default properties specified
  /// in the [polygonLayerProperties].
  ///
  /// Example:
  ///
  /// ```dart
  /// Map<String, dynamic> customProperties = {
  ///   'fillColor': '#FFA500', // Override fill color
  ///   'label': 'Custom Label', // Override label
  ///   // Add more custom properties as needed
  /// };
  ///
  /// PolygonProperties properties = PolygonProperties.fromMap(
  ///   customProperties,
  ///   PolygonProperties(),
  /// );
  /// ```
  static PolygonProperties<T> fromMap<T extends Object>(
    Map<String, dynamic>? properties,
    PolygonProperties<T> polygonLayerProperties,
  ) {
    Map<LayerPolygonIndexes, String>? layerProperties = polygonLayerProperties.layerProperties;
    if (properties != null && layerProperties != null) {
      // fill
      final String? keyPropertieFillColor = layerProperties[LayerPolygonIndexes.fillColor];
      bool isFilledMap = keyPropertieFillColor != null;
      String hexString = '${properties[keyPropertieFillColor]}';
      Color? polyLayProp = polygonLayerProperties.fillColor;
      final Color? fillColor = polyLayProp == null ? null : HexColor.fromHex(hexString, polyLayProp);
      // border color
      final String? layerPropertieBorderColor = layerProperties[LayerPolygonIndexes.borderColor];
      String hexString2 = '${properties[layerPropertieBorderColor]}';
      Color fall = polygonLayerProperties.borderColor;
      final Color borderColor = HexColor.fromHex(hexString2, fall);
      // border width
      String? layerPropertieBWidth = layerProperties[LayerPolygonIndexes.borderStokeWidth];
      // label
      final String? label = layerProperties[LayerPolygonIndexes.label];
      final bool labeled = properties[label] != null;
      bool isLabelled = labeled && polygonLayerProperties.labeled;
      String label2 = labeled ? '${properties[label]}' : polygonLayerProperties.label;
      return PolygonProperties<T>(
        isFilled: isFilledMap && polygonLayerProperties.isFilled,
        fillColor: fillColor,
        borderColor: borderColor,
        borderStokeWidth: (properties[layerPropertieBWidth] ?? polygonLayerProperties.borderStokeWidth).toDouble(),
        label: label2,
        layerProperties: layerProperties,
        labeled: isLabelled,
        disableHolesBorder: polygonLayerProperties.disableHolesBorder,
        pattern: polygonLayerProperties.pattern,
        labelPlacement: polygonLayerProperties.labelPlacement,
        labelStyle: polygonLayerProperties.labelStyle,
        rotateLabel: polygonLayerProperties.rotateLabel,
        strokeCap: polygonLayerProperties.strokeCap,
        strokeJoin: polygonLayerProperties.strokeJoin,
      );
    } else {
      return polygonLayerProperties;
    }
  }
}
