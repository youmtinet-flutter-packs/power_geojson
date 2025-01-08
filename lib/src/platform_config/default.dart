import 'dart:io';
import 'dart:typed_data';

Future<String> strUint8List(Uint8List list) async {
  File file = File.fromRawPath(list);
  var string = await file.readAsString();
  return string;
}

/// A default file load builder that reads the contents of a file from the specified [path].
///
/// This function is used for loading data from local files.
///
/// - [path]: The path to the file to be read.
///
/// Returns a [Future] that completes with the contents of the file as a string.
Future<String> defaultFileLoadBuilder(String path) async {
  final file = File(path);
  var exists = await file.exists();
  if (exists) {
    var readAsString = await file.readAsString();
    return readAsString;
  }
  return throw Exception('File not found');
}

abstract class AppPlatform {
  static bool isAndroid = Platform.isAndroid;
  static bool isIOS = Platform.isIOS;
  static bool isFuchsia = Platform.isFuchsia;
  static bool isWindows = Platform.isWindows;
  static bool isLinux = Platform.isLinux;
  static bool isMacOS = Platform.isMacOS;
  static bool isWeb = false;
  static bool isDesktop = isMacOS || isWindows || isLinux;
  static bool isPhone = isAndroid || isIOS || isFuchsia;
}
