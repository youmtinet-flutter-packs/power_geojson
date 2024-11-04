import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:power_geojson_example/lib.dart';

// // Network ==> Rabat
// // File    ==> Casablanca
// // String  ==> Rissani
// // Asset   ==> Marrakech + Tanger + Maroc

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS) && kDebugMode) {
    await WakelockPlus.enable();
    // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AppHome(),
    ),
  );
}


/* 
TileLayer(
	urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
	backgroundColor: Color(0xFF202020),
	maxZoom: 19,
), 
FeatureLayer(
	options: FeatureLayerOptions(
		"https://services.arcgis.com/V6ZHFr6zdgNZuVG0/arcgis/rest/services/Landscape_Trees/FeatureServer/0",
		"point",
	),
	stream: esri(),
), 
*/
