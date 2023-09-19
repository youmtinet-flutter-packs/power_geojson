import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

extension StringX on String {
  /// Parses a String Uri
  Uri toUri() {
    return Uri.parse(this);
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String? hexString, Color fallColor) {
    if (hexString == null) return fallColor;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } else if (hexString.length == 9 || hexString.length == 10) {
      buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 10));
    } else {
      return fallColor;
    }
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

/// An extension on lists of lists containing double values to provide a
/// convenient method for converting them into a list of LatLng objects.
extension LantLngX<T> on List<List<double>> {
  /// Converts a list of lists of double values representing latitude and longitude
  /// into a list of LatLng objects.
  ///
  /// Each inner list should contain two double values in the order [longitude, latitude].
  ///
  /// Returns a list of LatLng objects.
  List<LatLng> toLatLng() {
    return map((e) {
      var x = e[1]; // Latitude
      var y = e[0]; // Longitude
      return LatLng(x, y);
    }).toList();
  }
}
