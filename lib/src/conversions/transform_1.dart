// ignore_for_file: always_specify_types

import 'dart:convert';

import 'package:console_tools/console_tools.dart';
import 'package:power_geojson/power_geojson.dart';

const List<String> _esriFields = <String>[
  "displayFieldName",
  "fieldAliases",
  "geometryType",
  "spatialReference",
  "fields",
];

String checkEsri(String readasstring) {
  Map<String, Object?> map = jsonDecode(readasstring) as Map<String, Object?>;
  bool isEsri = map.keys.every((String field) => _esriFields.contains(field));
  String checkEsri = isEsri ? PowerJSON(PowerEsriJSON(map).toGeoJSON()).toText() : readasstring;
  return checkEsri;
}

class PowerEsriJSON {
  final Map<String, dynamic> data;

  PowerEsriJSON(this.data);
  Map<String, Object?> toGeoJSON() {
    var output = {"type": "FeatureCollection", "features": []};
    var data2 = data['features'];
    var fl = data2.length;
    var i = 0;
    while (fl > i) {
      var ft = data['features'][i];
      /* as only ESRI based products care if all the features are the same type of geometry, check for geometry type at a feature level*/
      var outFT = {"type": "Feature", "properties": _prop(ft['attributes'])};
      var geometry = ft['geometry'];
      if (geometry['x'] != null) {
        //check if it's a point
        outFT['geometry'] = _point2D(geometry);
      } else if (geometry['points'] != null) {
        //check if it is a multipoint
        outFT['geometry'] = _points2D(geometry);
      } else if (geometry['paths'] != null) {
        //check if a line (or "ARC" in ESRI terms)
        outFT['geometry'] = _line2D(geometry);
      } else if (geometry['rings'] != null) {
        outFT['geometry'] = _polygon(geometry);
      }
      var outPut2 = output['features'] as List;
      outPut2.add(outFT);
      i++;
    }
    Console.log('outPut = ${json.encode(output)}');
    return output;
  }

// \.(points|x|y|paths|rings)
  Map<String, Object?> _point2D(geometry) {
    //this one is easy
    return {
      "type": "Point",
      "coordinates": [geometry['x'], geometry['y']]
    };
  }

  Map<String, Object?> _points2D(geometry) {
    //checks if the multipoint only has one point, if so exports as point instead
    if (geometry['points'].length == 1) {
      return {"type": "Point", "coordinates": geometry['points'][0]};
    } else {
      return {"type": "MultiPoint", "coordinates": geometry['points']};
    }
  }

  Map<String, Object?> _line2D(geometry) {
    //checks if their are multiple paths or just one
    if (geometry['paths'].length == 1) {
      return {"type": "LineString", "coordinates": geometry['paths'][0]};
    } else {
      return {"type": "MultiLineString", "coordinates": geometry['paths']};
    }
  }

  Map<String, Object?> _polygon(geometry) {
    //first we check for some easy cases, like if their is only one ring
    if (geometry['rings'].length == 1) {
      return {"type": "Polygon", "coordinates": geometry['rings']};
    } else {
      /*if it isn't that easy then we have to start checking ring direction, basically the ring goes clockwise its part of the polygon,
            if it goes counterclockwise it is a hole in the polygon, but geojson does it by haveing an array with the first element be the polygons 
            and the next elements being holes in it*/
      return _decodePolygon(geometry['rings']);
    }
  }

  Map<String, Object?> _decodePolygon(a) {
    //returns the feature
    var coords = [];
    String type;
    var len = a.length;
    var i = 0;
    var len2 = coords.length - 1;
    while (len > i) {
      if (_ringIsClockwise(a[i])) {
        coords.add([a[i]]);
        len2++;
      } else {
        var coord = coords[len2] as List;
        coord.add(a[i]);
      }
      i++;
    }
    if (coords.length == 1) {
      type = "Polygon";
    } else {
      type = "MultiPolygon";
    }
    return {"type": type, "coordinates": (coords.length == 1) ? coords[0] : coords};
  }

  bool _ringIsClockwise(ringToTest) {
    var total = 0, i = 0, rLength = ringToTest.length, pt1 = ringToTest[i];
    List<int> pt2;
    for (int i = 0; i < rLength - 1; i++) {
      pt2 = ringToTest[i + 1];
      var pt22 = pt2[0];
      var pt12 = pt1[0] as int;
      var pt23 = pt2[1];
      var pt13 = pt1[1] as int;
      total += (pt22 - pt12) * (pt23 + pt13);
      pt1 = pt2;
    }
    return (total >= 0);
  }

  Map<dynamic, Object?> _prop(Map<String, dynamic> a) {
    var p = {};
    for (var k in a.keys) {
      if (a[k] != null) {
        p[k] = a[k];
      }
    }
    return p;
  }
}
