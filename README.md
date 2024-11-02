# Flutter power_geojson

[![pub package](https://img.shields.io/pub/v/power_geojson.svg)](https://pub.dev/packages/power_geojson)
[![GitHub stars](https://img.shields.io/github/stars/youmtinet-flutter-packs/power_geojson.svg?style=flat&logo=github&colorB=deeppink&label=Stars)](https://github.com/youmtinet-flutter-packs/power_geojson)

A Flutter package for easily displaying GeoJSON polygons and polylines on maps, with customizable styling options.

## Features

- Display GeoJSON markers, polygons and polylines on maps.
- Load GeoJSON data from network, assets, files, memory, or strings.
- Customize the appearance and behavior of polygons and polylines.
- Supports Flutter maps and map controllers.

## Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  power_geojson: latest
```

## Usage

---

---

### Displaying GeoJSON Polygons

```dart
import 'package:power_geojson/power_geojson.dart';
PowerGeoJSONPolygons.asset(
    'assets/polygons.geojson',
    builder: (coordinates, properties) {
        return Polygon(
            points: coordinates,
            // Customize polygon appearance here
            fillColor: Colors.blue,
            borderStokeWidth: 2,
            );
        },
    )
```

### Displaying GeoJSON Polylines

```dart
import 'package:power_geojson/power_geojson.dart';  PowerGeoJSONPolylines.asset(
    'assets/polylines.geojson',
    builder: (polylineProperties, properties) {
         return Polyline(
           points: polylineProperties,
       // Customize polyline appearance here
       color: Colors.red,
       strokeWidth: 3.0,
     );
     },
    )
```

For more detailed usage examples and customization options, refer to the [documentation](https://pub.dev/packages/power_geojson).

# Documentation

---

Full documentation for this package can be found on the [pub.dev](https://pub.dev/packages/power_geojson) page.

# Changelog

---

See the [CHANGELOG.md](CHANGELOG.md) file for details about recent updates.

# Issues and Contributions

---

Please file any issues, bugs, or feature requests on the

- [GitHub repository](https://github.com/youmtinet-flutter-packs/power_geojson)
- [GitLab repository](https://gitlab.com/flutter381/power_geojson)
- [BitBucket repository](https://bitbucket.org/youmti/power_geojson)

. Contributions are welcome!

# License

---

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Checkout my other Packages you may like

- [PopupMenu2](https://pub.dev/packages/popup_menu_2)
- [ConsoleLogger](https://pub.dev/packages/console_tools)
