import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:power_geojson/power_geojson.dart';

class PowerMarker extends Marker {
  final Map<String, Object?>? properties;
  const PowerMarker({
    required super.point,
    required super.child,
    super.alignment,
    super.height,
    super.key,
    super.rotate,
    super.width,
    this.properties,
  });
}

class PowerPopupOptions {
  /// Used to construct the popup.
  final PowerPopupBuilder popupBuilder;

  /// If a PopupController is provided it can be used to programmatically show
  /// and hide the popup.
  final PopupController popupController;

  /// Controls the position of the popup relative to the marker or popup.
  final PopupSnap popupSnap;

  /// Allows the use of an animation for showing/hiding popups. Defaults to no
  /// animation.
  final PopupAnimation? popupAnimation;

  /// Whether or not the markers rotate counter clockwise to the map rotation,
  /// defaults to false.
  final bool markerRotate;

  /// Set the popup building on hover rather than on tap.
  final bool buildPopupOnHover;

  /// Time (in milliseconds) required before the popup is shown when hovering. Set to 300 ms by default.
  final int timeToShowPopupOnHover;

  /// The default MarkerTapBehavior is
  /// [MarkerTapBehavior.togglePopupAndHideRest] which will toggle the popup of
  /// the tapped marker and hide all other popups. This is a sensible default
  /// when you only want to show a single popup at a time but if you show
  /// multiple popups you probably want to use [MarkerTapBehavior.togglePopup].
  ///
  /// For more information and other options see [MarkerTapBehavior].
  final MarkerTapBehavior markerTapBehavior;

  PowerPopupOptions({
    required this.popupBuilder,
    this.popupSnap = PopupSnap.markerTop,
    required this.popupController,
    this.popupAnimation,
    this.markerRotate = false,
    MarkerTapBehavior? markerTapBehavior,
    this.buildPopupOnHover = false,
    this.timeToShowPopupOnHover = 300,
  }) : markerTapBehavior = markerTapBehavior ?? MarkerTapBehavior.togglePopupAndHideRest();
}

// In a separate file so it can be exported individually in extension_api.dart
typedef PowerPopupBuilder = Widget Function(BuildContext context, PowerMarker powerMarker);
typedef PowerClusterWidgetBuilder = Widget Function(BuildContext context, List<PowerMarker> markers);

class PowerMarkerClusterOptions {
  //
  /// Cluster builder
  final PowerClusterWidgetBuilder builder;

  /// If true markers will be counter rotated to the map rotation
  final bool? rotate;

  /// Cluster size
  final Size size;

  /// Cluster compute size
  final Size Function(List<Marker>)? computeSize;

  /// Cluster anchor
  final Alignment? alignment;

  /// A cluster will cover at most this many pixels from its center
  final int maxClusterRadius;

  /// Zoom buonds with animation on click cluster
  final bool zoomToBoundsOnClick;

  /// animations options
  final AnimationsOptions animationsOptions;

  /// When click marker, center it with animation
  final bool centerMarkerOnClick;

  /// If false remove spiderfy effect on tap
  final bool spiderfyCluster;

  /// Increase to increase the distance away that circle spiderfied markers appear from the center
  final int spiderfyCircleRadius;

  /// If set, at this zoom level and below, markers will not be clustered. This defaults to 20 (max zoom)
  final int disableClusteringAtZoom;

  /// Increase to increase the distance away that spiral spiderfied markers appear from the center
  final int spiderfySpiralDistanceMultiplier;

  /// Show spiral instead of circle from this marker count upwards.
  /// 0 -> always spiral; Infinity -> always circle
  final int circleSpiralSwitchover;

  /// Make it possible to provide custom function to calculate spiderfy shape positions
  final List<Point<double>> Function(int, Point<double>)? spiderfyShapePositions;

  /// If true show polygon then tap on cluster
  final bool showPolygon;

  /// Polygon's options that shown when tap cluster.
  final PolygonOptions polygonOptions;

  /// Function to call when a Marker is tapped
  final void Function(Marker)? onMarkerTap;

  /// Function to call when a Marker is double tapped
  final void Function(Marker)? onMarkerDoubleTap;

  /// Function to call when a Marker starts to be hovered
  final void Function(Marker)? onMarkerHoverEnter;

  /// Function to call when a Marker stops to be hovered
  final void Function(Marker)? onMarkerHoverExit;

  /// Function to call when markers are clustered
  final void Function(List<Marker>)? onMarkersClustered;

  /// Function to call when a cluster Marker is tapped
  final void Function(MarkerClusterNode)? onClusterTap;

  ///If set to [true] the marker will have only gesture behavior that is provided by the marker child.
  ///Can be used in cases where the marker child is a widget that already has gesture behavior and [GestureDetector] from the [MarkerClusterLayer] is interfering with it.
  ///If set to [true] [onMarkerTap] [onMarkerHoverEnter] [onMarkerHoverExit] [centerMarkerOnClick] will not work.
  ///
  ///Defaults to [false].
  final bool markerChildBehavior;

  /// Popup's options that show when tapping markers or via the PopupController.
  final PowerPopupOptions? popupOptions;

  final EdgeInsets padding;
  final double maxZoom;
  final bool inside;

  /// By default calculations will return fractional zoom levels.
  /// If this parameter is set to [true] fractional zoom levels will be round
  /// to the next suitable integer.
  final bool forceIntegerZoomLevel;

  PowerMarkerClusterOptions({
    required this.builder,
    this.rotate,
    this.size = const Size(30, 30),
    this.computeSize,
    this.alignment,
    this.maxClusterRadius = 80,
    this.disableClusteringAtZoom = 20,
    this.animationsOptions = const AnimationsOptions(),
    this.padding = EdgeInsets.zero,
    this.maxZoom = 17.0,
    this.inside = false,
    this.forceIntegerZoomLevel = false,
    this.zoomToBoundsOnClick = true,
    this.centerMarkerOnClick = true,
    this.spiderfyCircleRadius = 40,
    this.spiderfySpiralDistanceMultiplier = 1,
    this.circleSpiralSwitchover = 9,
    this.spiderfyShapePositions,
    this.spiderfyCluster = true,
    this.polygonOptions = const PolygonOptions(),
    this.showPolygon = true,
    this.onMarkerTap,
    this.onMarkerDoubleTap,
    this.onMarkerHoverEnter,
    this.onMarkerHoverExit,
    this.onClusterTap,
    this.onMarkersClustered,
    this.popupOptions,
    this.markerChildBehavior = false,
  });

  MarkerClusterLayerOptions toClusterOptions(PowerMarkerClusterOptions powerClusterOptions, List<PowerMarker> markers) {
    return MarkerClusterLayerOptions(
      builder: (BuildContext context, List<Marker> markers) => builder(context, markers.whereType<PowerMarker>().toList()),
      rotate: rotate,
      markers: markers,
      size: size,
      computeSize: computeSize,
      alignment: alignment,
      maxClusterRadius: maxClusterRadius,
      disableClusteringAtZoom: disableClusteringAtZoom,
      animationsOptions: animationsOptions,
      padding: padding,
      maxZoom: maxZoom,
      inside: inside,
      forceIntegerZoomLevel: forceIntegerZoomLevel,
      zoomToBoundsOnClick: zoomToBoundsOnClick,
      centerMarkerOnClick: centerMarkerOnClick,
      spiderfyCircleRadius: spiderfyCircleRadius,
      spiderfySpiralDistanceMultiplier: spiderfySpiralDistanceMultiplier,
      circleSpiralSwitchover: circleSpiralSwitchover,
      spiderfyShapePositions: spiderfyShapePositions,
      spiderfyCluster: spiderfyCluster,
      polygonOptions: polygonOptions,
      showPolygon: showPolygon,
      onMarkerTap: onMarkerTap,
      onMarkerDoubleTap: onMarkerDoubleTap,
      onMarkerHoverEnter: onMarkerHoverEnter,
      onMarkerHoverExit: onMarkerHoverExit,
      onClusterTap: onClusterTap,
      onMarkersClustered: onMarkersClustered,
      popupOptions: PopupOptions(
        buildPopupOnHover: popupOptions?.buildPopupOnHover ?? false,
        markerRotate: popupOptions?.markerRotate ?? false,
        markerTapBehavior: popupOptions?.markerTapBehavior,
        popupAnimation: popupOptions?.popupAnimation,
        popupController: popupOptions?.popupController,
        popupSnap: popupOptions?.popupSnap ?? PopupSnap.markerTop,
        timeToShowPopupOnHover: popupOptions?.timeToShowPopupOnHover ?? 300,
        popupBuilder: (_, Marker marker) => _markerBuilder(powerClusterOptions, marker),
      ),
      markerChildBehavior: markerChildBehavior,
    );
  }

  PopupMarkerLayerOptions toPopupOptions(PowerMarkerClusterOptions powerClusterOptions, List<PowerMarker> markers) {
    return PopupMarkerLayerOptions(
      markers: markers,
      markerTapBehavior: popupOptions?.markerTapBehavior,
      popupController: popupOptions?.popupController,
      selectedMarkerBuilder: (BuildContext context, Marker marker) {
        return SizedBox(width: 45, height: 45, child: _markerBuilder /**/ (powerClusterOptions, marker));
      },
      popupDisplayOptions: PopupDisplayOptions(
        builder: (BuildContext context, Marker marker) => _markerBuilder /**/ (powerClusterOptions, marker),
        animation: popupOptions?.popupAnimation,
        snap: popupOptions?.popupSnap ?? PopupSnap.markerTop,
      ),
      //   initiallySelected: ,
      //   markerCenterAnimation: ,
      //   onPopupEvent: ,
    );
  }

  Widget _markerBuilder(PowerMarkerClusterOptions powerClusterOptions, Marker marker) {
    PowerPopupOptions? popupOptions = powerClusterOptions.popupOptions;
    if ((marker is PowerMarker && popupOptions != null)) {
      return Builder(builder: (BuildContext context) {
        return popupOptions.popupBuilder(context, marker);
      });
    } else {
      return Container(
        width: 50,
        height: 50,
        color: Colors.amber,
      );
    }
  }
}
