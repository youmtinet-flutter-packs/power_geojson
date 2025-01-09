import 'dart:math';

import 'package:flutter/widgets.dart';
import 'map_widget.dart';
import 'rotate.dart';

class PositionedMapWidget extends MapWidget {
  final Size size;
  final Widget child;
  final Point<double> position;
  final Rotate? rotate;

  const PositionedMapWidget({
    required this.child,
    required this.size,
    required this.position,
    this.rotate,
    super.key,
  }) : super.withKey();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: size.width,
      height: size.height,
      left: position.x,
      top: position.y,
      child: rotate == null
          ? child
          : Transform.rotate(
              angle: rotate!.angle,
              alignment: (rotate!.alignment ?? Alignment.center) * -1,
              child: child,
            ),
    );
  }
}
