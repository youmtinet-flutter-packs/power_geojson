import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:power_geojson/power_geojson.dart';

import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:power_geojson_example/lib.dart';

// // Network ==> Rabat
// // File    ==> Casablanca
// // String  ==> Rissani
// // Asset   ==> Marrakech + Tanger + Maroc

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ((AppPlatform.isAndroid || AppPlatform.isIOS) && kDebugMode) {
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
