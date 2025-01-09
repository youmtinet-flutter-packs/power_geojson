import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'node/marker_cluster_node.dart';
import 'core/distance_grid.dart';
import 'map_calculator.dart';

import 'node/marker_node.dart';
import 'node/marker_or_cluster_node.dart';

class ClusterManager {
  final MapCalculator mapCalculator;
  final Alignment? alignment;
  final Size predefinedSize;
  final Size Function(List<Marker>)? computeSize;
  final int minZoom;

  final List<DistanceGrid<MarkerClusterNode>> _gridClusters;
  final List<DistanceGrid<MarkerNode>> _gridUnclustered;
  final MarkerClusterNode _topClusterLevel;

  const ClusterManager._({
    required this.mapCalculator,
    required this.alignment,
    required this.predefinedSize,
    required this.computeSize,
    required this.minZoom,
    required List<DistanceGrid<MarkerClusterNode>> gridClusters,
    required List<DistanceGrid<MarkerNode>> gridUnclustered,
    required MarkerClusterNode topClusterLevel,
  })  : _gridClusters = gridClusters,
        _gridUnclustered = gridUnclustered,
        _topClusterLevel = topClusterLevel;

  factory ClusterManager.initialize({
    required MapCalculator mapCalculator,
    required Alignment? alignment,
    required Size predefinedSize,
    required Size Function(List<Marker>)? computeSize,
    required int minZoom,
    required int maxZoom,
    required int maxClusterRadius,
  }) {
    final int len = maxZoom - minZoom + 1;
    final List<DistanceGrid<MarkerClusterNode>> gridClusters =
        List<DistanceGrid<MarkerClusterNode>>.generate(
            len, (_) => DistanceGrid<MarkerClusterNode>(maxClusterRadius),
            growable: false);
    final List<DistanceGrid<MarkerNode>> gridUnclustered =
        List<DistanceGrid<MarkerNode>>.generate(
            len, (_) => DistanceGrid<MarkerNode>(maxClusterRadius),
            growable: false);

    final MarkerClusterNode topClusterLevel = MarkerClusterNode(
      alignment: alignment,
      zoom: minZoom - 1,
      predefinedSize: predefinedSize,
      computeSize: computeSize,
    );

    return ClusterManager._(
      alignment: alignment,
      mapCalculator: mapCalculator,
      predefinedSize: predefinedSize,
      computeSize: computeSize,
      minZoom: minZoom,
      gridClusters: gridClusters,
      gridUnclustered: gridUnclustered,
      topClusterLevel: topClusterLevel,
    );
  }

  void addLayer(MarkerNode marker, int disableClusteringAtZoom, int maxZoom,
      int minZoom) {
    for (int zoom = maxZoom; zoom >= minZoom; zoom--) {
      final Point<double> markerPoint =
          mapCalculator.project(marker.point, zoom: zoom.toDouble());
      if (zoom <= disableClusteringAtZoom) {
        // try find a cluster close by
        final MarkerClusterNode? cluster =
            _gridClusters[zoom - minZoom].getNearObject(markerPoint);
        if (cluster != null) {
          cluster.addChild(marker, marker.point);
          return;
        }

        final MarkerNode? closest =
            _gridUnclustered[zoom - minZoom].getNearObject(markerPoint);
        if (closest != null) {
          final MarkerClusterNode parent = closest.parent!;
          parent.removeChild(closest);

          final MarkerClusterNode newCluster = MarkerClusterNode(
            zoom: zoom,
            alignment: alignment,
            predefinedSize: predefinedSize,
            computeSize: computeSize,
          )
            ..addChild(closest, closest.point)
            ..addChild(marker, closest.point);

          _gridClusters[zoom - minZoom].addObject(
            newCluster,
            mapCalculator.project(
              newCluster.bounds.center,
              zoom: zoom.toDouble(),
            ),
          );

          // First create any new intermediate parent clusters that don't exist
          MarkerClusterNode lastParent = newCluster;
          for (int z = zoom - 1; z > parent.zoom; z--) {
            final MarkerClusterNode newParent = MarkerClusterNode(
              zoom: z,
              alignment: alignment,
              predefinedSize: predefinedSize,
              computeSize: computeSize,
            );
            newParent.addChild(
              lastParent,
              lastParent.bounds.center,
            );
            lastParent = newParent;
            _gridClusters[z - minZoom].addObject(
              lastParent,
              mapCalculator.project(
                closest.point,
                zoom: z.toDouble(),
              ),
            );
          }
          parent.addChild(lastParent, lastParent.bounds.center);

          _removeFromNewPosToMyPosGridUnclustered(closest, zoom, minZoom);
          return;
        }
      }

      _gridUnclustered[zoom - minZoom].addObject(marker, markerPoint);
    }

    //Didn't get in anything, add us to the top
    _topClusterLevel.addChild(marker, marker.point);
  }

  void _removeFromNewPosToMyPosGridUnclustered(
      MarkerNode marker, int zoom, int minZoom) {
    for (; zoom >= minZoom; zoom--) {
      if (!_gridUnclustered[zoom - minZoom].removeObject(marker)) {
        break;
      }
    }
  }

  void recalculateTopClusterLevelProperties() =>
      _topClusterLevel.recalculate(recursively: true);

  void recursivelyFromTopClusterLevel(
          int zoomLevel,
          int disableClusteringAtZoom,
          LatLngBounds recursionBounds,
          Function(MarkerOrClusterNode) fn) =>
      _topClusterLevel.recursively(
          zoomLevel, disableClusteringAtZoom, recursionBounds, fn);
}
