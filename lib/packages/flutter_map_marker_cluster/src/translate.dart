import 'dart:math';

import 'package:flutter/material.dart';
import 'core/util.dart' as util;
import 'map_calculator.dart';
import 'node/marker_cluster_node.dart';
import 'node/marker_node.dart';
import 'node/marker_or_cluster_node.dart';
import 'package:latlong2/latlong.dart';

@immutable
abstract class Translate {
  const Translate();

  Animation<Point<double>>? animation(AnimationController animationController);

  Point<double> get position;

  static Point<double> _getNodePixel(
    MapCalculator mapCalculator,
    MarkerOrClusterNode node, {
    LatLng? customPoint,
  }) {
    if (node is MarkerNode) {
      return _getMarkerPixel(mapCalculator, node, customPoint: customPoint);
    } else if (node is MarkerClusterNode) {
      return _getClusterPixel(mapCalculator, node, customPoint: customPoint);
    } else {
      throw ArgumentError(
        'Unknown node type when calculating pixel: ${node.runtimeType}',
      );
    }
  }

  static Point<double> _getMarkerPixel(
    MapCalculator mapCalculator,
    MarkerNode marker, {
    LatLng? customPoint,
  }) {
    final Point<double> pos =
        mapCalculator.getPixelFromPoint(customPoint ?? marker.point);
    return util.removeAlignment(
        pos, marker.width, marker.height, marker.alignment ?? Alignment.center);
  }

  static Point<double> _getClusterPixel(
    MapCalculator mapCalculator,
    MarkerClusterNode clusterNode, {
    LatLng? customPoint,
  }) {
    final Point<double> pos = mapCalculator
        .getPixelFromPoint(customPoint ?? clusterNode.bounds.center);

    final Size calculatedSize = clusterNode.size();

    return util.removeAlignment(
      pos,
      calculatedSize.width,
      calculatedSize.height,
      clusterNode.alignment ?? Alignment.center,
    );
  }
}

class StaticTranslate extends Translate {
  @override
  final Point<double> position;

  StaticTranslate(MapCalculator mapCalculator, MarkerOrClusterNode node)
      : position = Translate._getNodePixel(mapCalculator, node);

  @override
  Animation<Point<double>>? animation(
          AnimationController animationController) =>
      null;
}

class AnimatedTranslate extends Translate {
  @override
  final Point<double> position;
  final Point<double> newPosition;
  late final Tween<Point<double>> _tween;
  final Curve curve;
  AnimatedTranslate.fromMyPosToNewPos({
    required MapCalculator mapCalculator,
    required MarkerOrClusterNode from,
    required MarkerClusterNode to,
    required this.curve,
  })  : position = Translate._getNodePixel(mapCalculator, from),
        newPosition = Translate._getNodePixel(
          mapCalculator,
          from,
          customPoint: to.bounds.center,
        ) {
    _tween = Tween<Point<double>>(
      begin: Point<double>(position.x, position.y),
      end: Point<double>(newPosition.x, newPosition.y),
    );
  }

  AnimatedTranslate.fromNewPosToMyPos({
    required MapCalculator mapCalculator,
    required MarkerOrClusterNode from,
    required MarkerClusterNode to,
    required this.curve,
  })  : position = Translate._getNodePixel(mapCalculator, from),
        newPosition = Translate._getNodePixel(
          mapCalculator,
          from,
          customPoint: to.bounds.center,
        ) {
    _tween = Tween<Point<double>>(
      begin: Point<double>(newPosition.x, newPosition.y),
      end: Point<double>(position.x, position.y),
    );
  }

  AnimatedTranslate.spiderfy({
    required MapCalculator mapCalculator,
    required MarkerClusterNode cluster,
    required MarkerNode marker,
    required Point<double> point,
    required this.curve,
  })  : position = Translate._getMarkerPixel(
          mapCalculator,
          marker,
          customPoint: cluster.bounds.center,
        ),
        newPosition = util.removeAlignment(
          point,
          marker.width,
          marker.height,
          marker.alignment ?? Alignment.center,
        ) {
    _tween = Tween<Point<double>>(
      begin: Point<double>(position.x, position.y),
      end: Point<double>(newPosition.x, newPosition.y),
    );
  }

  @override
  Animation<Point<double>> animation(AnimationController animationController) =>
      _tween.chain(CurveTween(curve: curve)).animate(animationController);
}
