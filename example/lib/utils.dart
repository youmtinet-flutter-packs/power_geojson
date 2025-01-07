import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:power_geojson/power_geojson.dart';

const String url = 'https://ymrabti.github.io/undisclosed-tools/assets/';
Future<void> createFiles() async {
  final String assetsPoints /**********/ = await rootBundle
      .loadString('assets/file/points.geojson' /**************/);
  final String assetsLines /***********/ = await rootBundle
      .loadString('assets/file/lines.geojson' /***************/);
  final String assetsPolygons /********/ = await rootBundle
      .loadString('assets/file/polygons.geojson' /************/);
  await createFile('files_points', /**********/ assetsPoints);
  await createFile('files_lines', /***********/ assetsLines);
  await createFile('files_polygons', /********/ assetsPolygons);
}

Future<File> createFile(String filename, String data) async {
  List<Directory>? list = await getExternalDir();
  String directory =
      ((list == null || list.isEmpty) ? Directory('/') : list[0]).path;
  String path = "$directory/$filename";
  File file = File(path);
  bool exists = await file.exists();
  if (!exists) {
    return file..writeAsStringSync(data);
  }
  return file;
}

Future<PowerGeoPolygon> assetPolygons(String path) async {
  final string = await rootBundle.loadString(path);
  return PowerGeoJSONFeatureCollection.fromJson(string).geoJSONPolygons.first;
}
