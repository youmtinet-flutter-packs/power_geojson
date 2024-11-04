import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CircleOfMap extends StatelessWidget {
  const CircleOfMap({
    Key? key,
    required this.latLng,
  }) : super(key: key);

  final LatLng latLng;

  @override
  Widget build(BuildContext context) {
    return CircleLayer(
      circles: [
        CircleMarker(
          point: latLng,
          radius: 500,
          color: Colors.indigo.withOpacity(0.6),
          borderColor: Colors.black,
          borderStrokeWidth: 3,
          useRadiusInMeter: true,
        ),
      ],
    );
  }
}

class PinCentered extends StatelessWidget {
  const PinCentered({super.key, required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    double parent = 30;
    // double gapH = 1;
    // double gapW = 1;
    double iconSize = parent / 2;
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(width: parent, height: parent),
        // Positioned(left: 0, top: (parentH - gapH) / 2, child: Container(height: gapH, width: parentW, color: Colors.white)),
        // Positioned(left: (parentW - gapW) / 2, top: 0, child: Container(height: parentH, width: gapW, color: Colors.white)),

        Positioned(
          left: (parent - iconSize) / 2,
          top: parent / 2 - iconSize,
          child: Icon(
            CupertinoIcons.pin_fill,
            size: iconSize,
            color: color,
          ),
        ),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    );
  }
}
