import 'package:flutter/material.dart';

/// An enumeration representing indexes for marker layer properties.
///
/// The `LayerMarkerIndexes` enum is used to access specific properties within
/// a marker layer, such as width, height, and rotation. It provides a convenient
/// way to access these properties using named constants.
///
/// Example usage:
///
/// ```dart
/// LayerMarkerIndexes index = LayerMarkerIndexes.rotate;
///
/// if (index == LayerMarkerIndexes.rotate) {
///   // Handle rotation property
///   print("Handling rotation property");
/// }
/// ```
enum LayerMarkerIndexes {
  /// Represents the width property of a marker layer.
  width,

  /// Represents the height property of a marker layer.
  height,

  /// Represents the rotation property of a marker layer.
  rotate,
}

/// Represents properties for a marker on a map.
///
/// The `MarkerProperties` class defines various properties that can be associated
/// with a marker on a map, such as width, height, anchor position, rotation, and
/// layer-specific properties.
///
/// Example usage:
///
/// ```dart
/// MarkerProperties markerProps = MarkerProperties(
///   width: 40.0,
///   height: 40.0,
///   anchorPos: AnchorPos(bottom: 0.0, left: 0.0),
///   rotate: true,
///   layerProperties: {
///     LayerMarkerIndexes.width: 'custom_width',
///     LayerMarkerIndexes.height: 'custom_height',
///     LayerMarkerIndexes.rotate: 'custom_rotate',
///   },
/// );
/// ```
class MarkerProperties {
  /// An optional key that can be used to uniquely identify the marker.
  final Key? key;

  /// The width of the marker.
  final double width;

  /// The height of the marker.
  final double height;

  /// The anchor position of the marker, specifying its relative position within
  /// the marker's bounding box.

  /// A flag indicating whether the marker should rotate.
  final bool? rotate;

  /// The alignment for the marker's rotation.
  final Alignment? rotateAlignment;

  /// A map of layer-specific properties associated with the marker.
  final Map<LayerMarkerIndexes, String>? layerProperties;

  /// Creates a `MarkerProperties` object with the specified properties.
  ///
  /// The [width] and [height] parameters specify the dimensions of the marker.
  /// The [anchorPos] parameter allows you to set the anchor position within the
  /// marker's bounding box.
  ///
  /// The [rotate] parameter determines whether the marker should rotate.
  /// The [rotateOrigin] parameter specifies the rotation origin, and the
  /// [rotateAlignment] parameter sets the alignment for the rotation.
  ///
  /// The [layerProperties] parameter allows you to define layer-specific properties
  /// for the marker.
  const MarkerProperties({
    this.layerProperties,
    this.key,
    this.width = 30.0,
    this.height = 30.0,
    this.rotate,
    this.rotateAlignment,
  });

  /// Creates a `MarkerProperties` object by extracting properties from a map of
  /// properties and merging them with the provided [markerLayerProperties].
  ///
  /// The [properties] map should contain keys corresponding to the properties
  /// to be extracted, and [markerLayerProperties] provides default values.
  factory MarkerProperties.fromMap(
    Map<String, dynamic>? properties,
    MarkerProperties markerLayerProperties,
  ) {
    Map<LayerMarkerIndexes, String>? layerMarkerProperties = markerLayerProperties.layerProperties;
    if (properties != null && layerMarkerProperties != null) {
      final String? keyPropertieWidth = layerMarkerProperties[LayerMarkerIndexes.width];
      double? propWidth = properties[keyPropertieWidth];

      final String? keyPropertieHeight = layerMarkerProperties[LayerMarkerIndexes.height];
      double? propHeight = properties[keyPropertieHeight];

      final String? keyPropertieRotate = layerMarkerProperties[LayerMarkerIndexes.rotate];
      bool? propRotate = properties[keyPropertieRotate];

      return MarkerProperties(
        key: markerLayerProperties.key,
        width: propWidth ?? markerLayerProperties.width,
        height: propHeight ?? markerLayerProperties.height,
        rotate: propRotate,
        rotateAlignment: markerLayerProperties.rotateAlignment,
      );
    } else {
      return markerLayerProperties;
    }
  }
}
