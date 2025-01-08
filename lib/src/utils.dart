import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:power_geojson/src/src.dart';
export 'dart:developer';

/// Zooms the map view to fit the specified geographic features.
///
/// The `zoomTo` function calculates an optimal zoom level and position to ensure that
/// all the provided geographic features are visible within the map view.
///
/// The [features] parameter is a list of features, where each feature is represented
/// as a list of four double values [minLongitude, minLatitude, maxLongitude, maxLatitude].
/// A feature defines a bounding box in geographic coordinates.
///
/// The [mapController] parameter is the [MapController] used to control the map view.
///
/// Example usage:
///
/// ```dart
/// List<List<double>?> features = [
///   [-122.5, 37.5, -122.3, 37.7], // Feature 1
///   [-123.0, 37.0, -122.8, 37.2], // Feature 2
///   // Add more features as needed
/// ];
///
/// MapController myMapController = MapController();
///
/// // Zoom the map to fit all the features
/// zoomTo(features, myMapController);
/// ```
///
/// In this example, the `zoomTo` function is used to zoom the map view to fit all the
/// specified geographic features within the `features` list using the provided `mapController`.
///
/// If any of the features or the `mapController` is null, the function returns early.
///
/// This function modifies the map view to display all the specified features.
void zoomTo(List<List<double>?> features, MapController? mapController) {
  var atLeast = features.firstWhereOrNull((fe) => fe != null);
  if (atLeast == null) return;
  if (mapController == null) return;
  var firstBounds = LatLngBounds.fromPoints([
    LatLng(atLeast[1], atLeast[0]),
    LatLng(atLeast[3], atLeast[2]),
  ]);
  var latLngBounds = features.fold<LatLngBounds>(
    firstBounds,
    (previousValue, bbox) {
      if (bbox == null) return previousValue;
      var elementBounds = LatLngBounds.fromPoints([
        LatLng(bbox[1], bbox[0]),
        LatLng(bbox[3], bbox[2]),
      ]);
      previousValue.extendBounds(elementBounds);
      return previousValue;
    },
  );
  mapController.fitCamera(CameraFit.bounds(bounds: latLngBounds));
}
