import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'marker_center_animation.dart';
import 'package:latlong2/latlong.dart';
import 'options/popup_marker_layer_options.dart';
import 'popup_spec.dart';
import 'state/popup_state.dart';
import 'package:provider/provider.dart';

import 'controller/popup_controller.dart';

@immutable
class MarkerLayer extends StatefulWidget {
  final PopupMarkerLayerOptions layerOptions;
  final MapCamera mapCamera;
  final MapController mapController;
  final PopupState popupState;
  final PopupController popupController;

  const MarkerLayer({
    super.key,
    required this.layerOptions,
    required this.mapCamera,
    required this.mapController,
    required this.popupState,
    required this.popupController,
  });

  @override
  State<MarkerLayer> createState() => _MarkerLayerState();
}

class _MarkerLayerState extends State<MarkerLayer> with SingleTickerProviderStateMixin {
  late AnimationController _centerMarkerController;
  void Function()? _animationListener;

  @override
  void initState() {
    super.initState();
    _centerMarkerController = AnimationController(
      vsync: this,
      duration: widget.layerOptions.markerCenterAnimation?.duration,
    );
  }

  @override
  void dispose() {
    _centerMarkerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapCamera map = MapCamera.of(context);

    if (widget.layerOptions.selectedMarkerBuilder != null) {
      context.watch<PopupState>();
    }

    return MobileLayerTransformer(
      child: Stack(
        // ignore: avoid_types_on_closure_parameters
        children: (List<Marker> markers) sync* {
          for (final Marker m in markers) {
            // Resolve real alignment
            final double left = 0.5 * m.width * ((m.alignment ?? Alignment.center).x + 1);
            final double top = 0.5 * m.height * ((m.alignment ?? Alignment.center).y + 1);
            final double right = m.width - left;
            final double bottom = m.height - top;

            // Perform projection
            final Point<double> pxPoint = map.project(m.point);

            // Cull if out of bounds
            if (!map.pixelBounds.containsPartialBounds(
              Bounds<double>(
                Point<double>(pxPoint.x + left, pxPoint.y - bottom),
                Point<double>(pxPoint.x - right, pxPoint.y + top),
              ),
            )) continue;

            // Apply map camera to marker position
            final Point<double> pos = Point<double>(pxPoint.x - map.pixelOrigin.x, pxPoint.y - map.pixelOrigin.y);

            Widget markerChild = m.child;
            if (widget.layerOptions.selectedMarkerBuilder != null && widget.popupState.isSelected(m)) {
              markerChild = widget.layerOptions.selectedMarkerBuilder!(context, m);
            }
            final GestureDetector markerWithGestureDetector = GestureDetector(
              onTap: () {
                if (!widget.popupState.selectedMarkers.contains(m)) {
                  _centerMarker(m);
                }

                widget.layerOptions.markerTapBehavior.apply(
                  PopupSpec.wrap(m),
                  widget.popupState,
                  widget.popupController,
                );
              },
              child: markerChild,
            );

            yield Positioned(
              key: m.key,
              width: m.width,
              height: m.height,
              left: pos.x - right,
              top: pos.y - bottom,
              child: (m.rotate == true)
                  ? Transform.rotate(
                      angle: -map.rotationRad,
                      alignment: (m.alignment ?? Alignment.center) * -1,
                      child: markerWithGestureDetector,
                    )
                  : markerWithGestureDetector,
            );
          }
        }(widget.layerOptions.markers)
            .toList(),
      ),
    );
  }

  void _centerMarker(Marker marker) {
    final MarkerCenterAnimation? markerLayerAnimation = widget.layerOptions.markerCenterAnimation;
    if (markerLayerAnimation == null) return;

    final LatLng center = widget.mapCamera.center;
    final LatLngTween tween = LatLngTween(begin: center, end: marker.point);

    Animation<double> animation = CurvedAnimation(
      parent: _centerMarkerController,
      curve: markerLayerAnimation.curve,
    );

    void listener() {
      widget.mapController.move(
        tween.evaluate(animation),
        widget.mapCamera.zoom,
      );
    }

    _centerMarkerController.removeListener(_animationListener ?? () {});
    _centerMarkerController.reset();
    _animationListener = listener;

    _centerMarkerController.addListener(listener);
    _centerMarkerController.forward().then((_) {
      _centerMarkerController
        ..removeListener(listener)
        ..reset();
      _animationListener = null;
    });
  }
}
