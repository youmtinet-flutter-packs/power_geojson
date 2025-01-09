import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'marker_node.dart';
import 'marker_or_cluster_node.dart';
import 'package:latlong2/latlong.dart';

class _Derived {
  final List<MarkerNode> markerNodes = <MarkerNode>[];
  late final LatLngBounds? bounds;
  late final List<Marker> markers;
  late final Size? size;

  _Derived(
    List<MarkerOrClusterNode> children,
    Size Function(List<Marker>)? computeSize, {
    required bool recursively,
  }) {
    markerNodes.addAll(children.whereType<MarkerNode>());

    // Depth first traversal.
    void dfs(MarkerClusterNode child) {
      for (final MarkerOrClusterNode c in child.children) {
        if (c is MarkerClusterNode) {
          dfs(c);
        }
      }
      child.recalculate(recursively: false);
    }

    for (final MarkerClusterNode child in children.whereType<MarkerClusterNode>()) {
      // If `recursively` is true, update children first from the leafs up.
      if (recursively) {
        dfs(child);
      }

      markerNodes.addAll(child.markers);
    }

    bounds = markerNodes.isEmpty ? null : LatLngBounds.fromPoints(List<LatLng>.generate(markerNodes.length, (int index) => markerNodes[index].point));

    markers = markerNodes.map((MarkerNode m) => m.marker).toList();
    size = computeSize?.call(markers);
  }
}

class MarkerClusterNode extends MarkerOrClusterNode {
  final int zoom;
  final Alignment? alignment;
  final Size predefinedSize;
  final Size Function(List<Marker>)? computeSize;
  final List<MarkerOrClusterNode> children = <MarkerOrClusterNode>[];

  late _Derived _derived;

  MarkerClusterNode({
    required this.zoom,
    required this.alignment,
    required this.predefinedSize,
    this.computeSize,
  }) : super(parent: null) {
    _derived = _Derived(children, computeSize, recursively: false);
  }

  /// A list of all marker nodex recursively, i.e including child layers.
  List<MarkerNode> get markers => _derived.markerNodes;

  /// A list of all Marker widgets recursively, i.e. including child layers.
  List<Marker> get mapMarkers => _derived.markers;

  /// LatLong bounds of the transitive markers covered by this cluster.
  /// Note, hacky way of dealing with now null-safe LatLngBounds. Ideally we'd
  // return null here for nodes that are empty and don't have bounds.
  LatLngBounds get bounds => _derived.bounds ?? LatLngBounds(const LatLng(0, 0), const LatLng(0, 0));

  Size size() => _derived.size ?? predefinedSize;

  void addChild(MarkerOrClusterNode child, LatLng childPoint) {
    children.add(child);
    child.parent = this;
    recalculate(recursively: false);
  }

  void removeChild(MarkerOrClusterNode child) {
    children.remove(child);
    recalculate(recursively: false);
  }

  void recalculate({required bool recursively}) {
    _derived = _Derived(children, computeSize, recursively: recursively);
  }

  void recursively(
    int zoomLevel,
    int disableClusteringAtZoom,
    LatLngBounds recursionBounds,
    Function(MarkerOrClusterNode node) fn,
  ) {
    if (zoom == zoomLevel && zoomLevel <= disableClusteringAtZoom) {
      fn(this);

      // Stop recursion. We've recursed to the point where we won't
      // draw any smaller levels
      return;
    }
    assert(zoom <= disableClusteringAtZoom, '$zoom $disableClusteringAtZoom $zoomLevel');

    for (final MarkerOrClusterNode child in children) {
      if (child is MarkerNode) {
        fn(child);
      } else if (child is MarkerClusterNode) {
        // OPTIMIZATION: Skip clusters that don't overlap with given recursion
        // (map) bounds. Their markers would get culled later anyway.
        if (recursionBounds.isOverlapping(child.bounds)) {
          child.recursively(zoomLevel, disableClusteringAtZoom, recursionBounds, fn);
        }
      }
    }
  }

  @override
  Bounds<double> pixelBounds(MapCamera map) {
    final double width = size().width;
    final double height = size().height;

    final double left = 0.5 * width * ((alignment ?? Alignment.center).x + 1);
    final double top = 0.5 * height * ((alignment ?? Alignment.center).y + 1);
    final double right = width - left;
    final double bottom = height - top;

    final Point<double> ne = map.project(bounds.northEast) + Point<double>(right, -top);
    final Point<double> sw = map.project(bounds.southWest) + Point<double>(-left, bottom);

    return Bounds<double>(ne, sw);
  }
}
