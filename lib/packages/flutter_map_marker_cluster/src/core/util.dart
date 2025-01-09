import 'dart:math';

import 'package:flutter/material.dart';

Point<double> removeAlignment(Point<double> pos, double width, double height, Alignment alignment) {
  final double left = 0.5 * width * (alignment.x + 1);
  final double top = 0.5 * height * (alignment.y + 1);
  final double x = pos.x - (width - left);
  final double y = pos.y - (height - top);
  return Point<double>(x, y);
}
