import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:power_geojson/power_geojson.dart';

enum LayerPolylineIndexes {
  color,
  strokeWidth,
  borderColor,
}

class PolylineProperties<T extends Object> {
  static const Color defFillColor = Color(0x9C2195F3);
  static const double defBorderStokeWidth = 2;
  static const Color defBorderColor = Color(0xFF1E00FD);
  static const StrokePattern defIsDotted = StrokePattern.solid();
  static const bool defUseStrokeWidthInMeter = false;
  static const StrokeCap defStrokeCap = StrokeCap.round;
  static const StrokeJoin defStrokeJoin = StrokeJoin.round;
  static const List<double> defColorsStop = <double>[];
  static const List<Color> defGradientColors = <Color>[];
  static const double defStrokeWidth = 1;

  final double strokeWidth;
  final T? hintValue;
  final Color color;
  final double borderStrokeWidth;
  final Color borderColor;
  final List<Color>? gradientColors;
  final List<double>? colorsStop;
  final StrokePattern isDotted;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  final bool useStrokeWidthInMeter;
  final Map<LayerPolylineIndexes, String>? layerProperties;

  static PolylineProperties<T> fromMap<T extends Object>(
    Map<String, dynamic>? properties,
    PolylineProperties<T> polylineProperties,
  ) {
    Map<LayerPolylineIndexes, String>? layerProperties = polylineProperties.layerProperties;
    if (properties != null && layerProperties != null) {
      // fill
      final String? keyPropertieFillColor = layerProperties[LayerPolylineIndexes.color];
      String hexString = '${properties[keyPropertieFillColor]}';
      final Color color = HexColor.fromHex(hexString, polylineProperties.color);
      // border color
      final String? keyPropertieBorderColor = layerProperties[LayerPolylineIndexes.borderColor];
      String hexString2 = '${properties[keyPropertieBorderColor]}';
      Color fall = polylineProperties.borderColor;
      final Color borderColor = HexColor.fromHex(hexString2, fall);
      // border width
      String? keyPropertieBWidth = layerProperties[LayerPolylineIndexes.strokeWidth];
      double defBorderStokeWidth = polylineProperties.borderStrokeWidth;
      final double borderWidth = properties[keyPropertieBWidth] ?? defBorderStokeWidth;
      return PolylineProperties<T>(
        colorsStop: polylineProperties.colorsStop,
        gradientColors: polylineProperties.gradientColors,
        strokeWidth: borderWidth,
        layerProperties: layerProperties,
        useStrokeWidthInMeter: polylineProperties.useStrokeWidthInMeter,
        isDotted: polylineProperties.isDotted,
        strokeCap: polylineProperties.strokeCap,
        strokeJoin: polylineProperties.strokeJoin,
        borderStrokeWidth: polylineProperties.borderStrokeWidth,
        borderColor: borderColor,
        color: color,
        //
      );
    } else {
      return polylineProperties;
    }
  }

  const PolylineProperties({
    this.colorsStop = PolylineProperties.defColorsStop,
    this.useStrokeWidthInMeter = PolylineProperties.defUseStrokeWidthInMeter,
    this.gradientColors = PolylineProperties.defGradientColors,
    this.strokeWidth = PolylineProperties.defStrokeWidth,
    this.isDotted = PolylineProperties.defIsDotted,
    this.strokeCap = PolylineProperties.defStrokeCap,
    this.strokeJoin = PolylineProperties.defStrokeJoin,
    this.layerProperties,
    this.hintValue,
    this.borderStrokeWidth = PolylineProperties.defBorderStokeWidth,
    this.borderColor = PolylineProperties.defBorderColor,
    this.color = PolylineProperties.defFillColor,
  });
}
