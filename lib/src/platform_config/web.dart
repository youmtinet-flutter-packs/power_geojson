import 'dart:convert';
import 'dart:typed_data';

Future<String> strUint8List(Uint8List list) async {
  String string = utf8.decode(list);
  return string;
}

/// A default file load builder that reads the contents of a file from the specified [path].
Future<String> defaultFileLoadBuilder(String path) async {
  return path;
}

abstract class AppPlatform {
  static bool isAndroid = false;
  static bool isIOS = false;
  static bool isFuchsia = false;
  static bool isWindows = false;
  static bool isLinux = false;
  static bool isMacOS = false;
  static bool isWeb = true;
  static bool isDesktop = false;
  static bool isPhone = false;
}
